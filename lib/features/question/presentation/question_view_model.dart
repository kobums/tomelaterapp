import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/question/data/answer_repository.dart';
import 'package:app/features/question/data/question_repository.dart';
import 'package:app/shared/models/answer.dart';
import 'package:app/shared/models/question.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionState {
  final bool isLoading;
  final bool isSubmitting;
  final Question? question;
  final Answer? existingAnswer;
  final String? error;

  QuestionState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.question,
    this.existingAnswer,
    this.error,
  });

  QuestionState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    Question? question,
    Answer? existingAnswer,
    String? error,
  }) {
    return QuestionState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      question: question ?? this.question,
      existingAnswer: existingAnswer ?? this.existingAnswer,
      error: error,
    );
  }
}

class QuestionViewModel extends StateNotifier<QuestionState> {
  final QuestionRepository _questionRepository;
  final AnswerRepository _answerRepository;
  final StorageService _storageService;

  QuestionViewModel(
      this._questionRepository, this._answerRepository, this._storageService)
      : super(QuestionState()) {
    loadDailyQuestion();
  }

  Future<void> loadDailyQuestion() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final question = await _questionRepository.getDailyQuestion();
      if (question != null) {
        final userId = _storageService.getUserId();
        if (userId != null) {
          final answer = await _answerRepository.getAnswerForQuestion(
              uid: userId, qid: question.id);
          state =
              state.copyWith(isLoading: false, question: question, existingAnswer: answer);
        } else {
          state = state.copyWith(isLoading: false, question: question);
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '질문을 불러오는데 실패했습니다: $e');
    }
  }

  Future<bool> submitAnswer(String content, bool isPublic) async {
    if (state.question == null) return false;
    final userId = _storageService.getUserId();
    if (userId == null) {
      state = state.copyWith(error: '로그인이 필요합니다.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await _answerRepository.createAnswer(
        uid: userId,
        qid: state.question!.id,
        content: content,
        isPublic: isPublic,
      );
      
      // Refresh to get the created answer back (including ID etc)
      final answer = await _answerRepository.getAnswerForQuestion(
          uid: userId, qid: state.question!.id);
          
      state = state.copyWith(isSubmitting: false, existingAnswer: answer);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: '답변 제출 실패: $e');
      return false;
    }
  }
}

final questionViewModelProvider =
    StateNotifierProvider.autoDispose<QuestionViewModel, QuestionState>((ref) {
  final questionRepo = ref.watch(questionRepositoryProvider);
  final answerRepo = ref.watch(answerRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return QuestionViewModel(questionRepo, answerRepo, storageService);
});
