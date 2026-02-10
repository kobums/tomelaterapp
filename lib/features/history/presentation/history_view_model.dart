import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/question/data/answer_repository.dart';
import 'package:app/shared/models/answer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryState {
  final bool isLoading;
  final bool isLoadingMore;
  final List<Answer> answers;
  final String? error;
  final int page;
  final bool hasMore;

  HistoryState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.answers = const [],
    this.error,
    this.page = 0,
    this.hasMore = true,
  });

  HistoryState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    List<Answer>? answers,
    String? error,
    int? page,
    bool? hasMore,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      answers: answers ?? this.answers,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class HistoryViewModel extends StateNotifier<HistoryState> {
  final AnswerRepository _answerRepository;
  final StorageService _storageService;
  static const int _pageSize = 10;

  HistoryViewModel(this._answerRepository, this._storageService) : super(HistoryState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    final userId = _storageService.getUserId();
    if (userId == null) {
      state = state.copyWith(error: '로그인이 필요합니다.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null, page: 0, answers: [], hasMore: true);
    try {
      final answers = await _answerRepository.getMyAnswers(userId, page: 0, size: _pageSize);
      // Sort is likely handled by backend pagination or we accept backend order. 
      // Assuming backend returns latest first or we rely on insertion order.
      // If we need client side sort with pagination, it's tricky. Let's assume backend serves correctly.
      
      state = state.copyWith(
        isLoading: false, 
        answers: answers,
        page: 1,
        hasMore: answers.length >= _pageSize
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '기록을 불러오는데 실패했습니다: $e');
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;

    final userId = _storageService.getUserId();
    if (userId == null) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final currentAnswers = state.answers;
      final newAnswers = await _answerRepository.getMyAnswers(
        userId, 
        page: state.page, 
        size: _pageSize
      );

      state = state.copyWith(
        isLoadingMore: false,
        answers: [...currentAnswers, ...newAnswers],
        page: state.page + 1,
        hasMore: newAnswers.length >= _pageSize
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: '추가 기록을 불러오는데 실패했습니다: $e');
    }
  }

  Future<void> refresh() async {
    await loadHistory();
  }
}

final historyViewModelProvider =
    StateNotifierProvider.autoDispose<HistoryViewModel, HistoryState>((ref) {
  final answerRepo = ref.watch(answerRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return HistoryViewModel(answerRepo, storageService);
});
