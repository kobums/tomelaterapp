import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/storage_service.dart';

// Use 10.0.2.2 for Android emulator, localhost for iOS simulator
// final String kBaseUrl = Platform.isAndroid ? 'http://10.0.2.2:8006' : 'http://localhost:8006';
final String kBaseUrl = 'https://tomelaterspring.gowoobro.com';

// 디버그 로그에 비밀번호가 찍히지 않도록 가린다.
Object? _redact(Object? data) {
  if (data is Map) {
    return data.map((k, v) =>
        MapEntry(k, k == 'passwd' || k == 'newPasswd' ? '***' : v));
  }
  return data;
}

final dioProvider = Provider<Dio>((ref) {
  final storageService = ref.watch(storageServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = storageService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token'; // Assumes Bearer token
        }
        
        if (kDebugMode) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('DATA: ${_redact(options.data)}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          print('DATA: ${response.data}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          print('MESSAGE: ${e.message}');
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
