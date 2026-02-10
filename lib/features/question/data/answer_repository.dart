import 'package:app/core/network/api_client.dart';
import 'package:app/shared/models/answer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnswerRepository {
  final Dio _dio;

  AnswerRepository(this._dio);

  Future<void> createAnswer({
    required int uid,
    required int qid,
    required String content,
    required bool isPublic,
  }) async {
    try {
      await _dio.post(
        '/api/answer',
        data: {
          'uid': uid,
          'qid': qid,
          'content': content,
          'ispublic': isPublic ? 'PUBLIC' : 'PRIVATE',
        },
      );
    } catch (e) {
      throw e;
    }
  }

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
      throw e;
    }
  }
  Future<List<Answer>> getMyAnswers(int uid, {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(
        '/api/answer',
        queryParameters: {
          'uid': uid,
          'page': page,
          'pagesize': size,
          // Sort handled by backend often, but here we just get paged data
        },
      );

      final data = response.data;
      if (data != null && data['content'] != null) {
        final list = data['content'] as List;
        return list.map((e) => Answer.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      throw e;
    }
  }
}

final answerRepositoryProvider = Provider<AnswerRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AnswerRepository(dio);
});
