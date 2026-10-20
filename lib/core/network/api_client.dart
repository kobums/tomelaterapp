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

// 401(토큰 만료·무효) 수신 시 호출할 콜백. main.dart 에서 로그인 화면 이동으로 덮어쓴다.
// (router.dart 는 화면들을 import 하므로 여기서 직접 참조하지 않는다.)
final unauthorizedHandlerProvider = Provider<void Function()>((ref) => () {});

// 로그인·가입·계정찾기 요청의 401 은 "자격 증명 오류"이지 세션 만료가 아니다.
bool _isAuthRequest(String path) =>
    path.startsWith('/api/auth/') || path.startsWith('/api/jwt');

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
      onError: (DioException e, handler) async {
        if (kDebugMode) {
          print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
          print('MESSAGE: ${e.message}');
        }
        // 토큰을 실어 보낸 요청이 401 이면 토큰이 만료/무효다. 저장된 로그인 정보를 지우고
        // 로그인 화면으로 보낸다(서버는 리프레시 토큰이 없어 재로그인만 가능).
        // 동시에 여러 요청이 401 을 받아도 토큰이 남아 있을 때 한 번만 처리한다.
        if (e.response?.statusCode == 401 &&
            !_isAuthRequest(e.requestOptions.path) &&
            e.requestOptions.headers['Authorization'] != null &&
            storageService.getToken() != null) {
          await storageService.clearAll();
          ref.read(unauthorizedHandlerProvider)();
        }
        return handler.next(e);
      },
    ),
  );

  return dio;
});
