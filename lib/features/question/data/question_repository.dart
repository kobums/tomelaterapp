import 'package:app/core/network/api_client.dart';
import 'package:app/shared/models/question.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionRepository {
  final Dio _dio;

  QuestionRepository(this._dio);

  Future<Question?> getDailyQuestion() async {
    final today = DateTime.now();
    try {
      final response = await _dio.get(
        '/api/question',
        queryParameters: {
          'month': today.month,
          'day': today.day,
          'page': 0,
          'pagesize': 1,
        },
      );
      
      final data = response.data;
      if (data != null && data['content'] != null) {
        final list = data['content'] as List;
        if (list.isNotEmpty) {
          return Question.fromJson(list[0]);
        }
      }
      return null;
    } catch (e) {
      throw e;
    }
  }
}

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return QuestionRepository(dio);
});
