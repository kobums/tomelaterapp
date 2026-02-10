import 'package:app/core/network/api_client.dart';
import 'package:app/shared/models/answer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// History 피처를 위한 Repository
/// AnswerRepository를 래핑하여 히스토리 관련 기능 제공
class HistoryRepository {
  final Dio _dio;

  HistoryRepository(this._dio);

  /// 사용자의 답변 히스토리를 페이지네이션으로 조회
  Future<List<Answer>> getMyAnswers(int uid, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/api/answer',
        queryParameters: {
          'uid': uid,
          'page': page,
          'pagesize': size,
        },
      );

      final data = response.data;
      if (data != null && data['content'] != null) {
        final list = data['content'] as List;
        return list.map((e) => Answer.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// 특정 질문에 대한 답변 조회
  Future<Answer?> getAnswerForQuestion({required int uid, required int qid}) async {
    try {
      final response = await _dio.get(
        '/api/answer',
        queryParameters: {
          'uid': uid,
          'qid': qid,
        },
      );

      final data = response.data;
      if (data != null && data['content'] != null) {
        final list = data['content'] as List;
        if (list.isNotEmpty) {
          return Answer.fromJson(list[0]);
        }
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return HistoryRepository(dio);
});
