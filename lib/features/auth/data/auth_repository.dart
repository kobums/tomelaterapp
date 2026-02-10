import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/shared/models/user.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.get(
        '/api/jwt',
        queryParameters: {'email': email, 'passwd': password},
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
         if (data is Map && data.containsKey('message')) {
           throw Exception(data['message']);
        }
      }
      throw Exception('로그인에 실패했습니다.');
    } catch (e) {
      throw Exception('로그인 중 오류가 발생했습니다.');
    }
  }

  Future<void> register(Map<String, dynamic> data) async {
    try {
      await _dio.post('/api/user', data: data);
    } on DioException catch (e) {
       if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
         // Handle plain string response
        if (data is String) {
            throw Exception(data);
        }
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
         if (data is Map && data.containsKey('message')) {
           throw Exception(data['message']);
        }
      }
      throw Exception('회원가입에 실패했습니다.');
    } catch (e) {
       throw Exception('회원가입 중 오류가 발생했습니다.');
    }
  }

  Future<String> findEmail(String nickname) async {
    try {
      final response = await _dio.post(
        '/api/auth/find/email',
        data: {'nickname': nickname},
      );
      return response.data['email'];
    } on DioException catch (e) {
       if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
      }
      throw Exception('이메일을 찾을 수 없습니다.');
    } catch (e) {
      throw Exception('이메일 찾기 중 오류가 발생했습니다.');
    }
  }

  Future<void> sendVerificationCode(String email) async {
    try {
      await _dio.post('/api/auth/verify/send', data: {'email': email});
    } on DioException catch (e) {
        if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
      }
      throw Exception('인증 코드 발송에 실패했습니다.');
    } catch (e) {
      throw Exception('인증 코드 발송 중 오류가 발생했습니다.');
    }
  }

  Future<bool> checkVerificationCode(String email, String code) async {
    try {
      final response = await _dio.post(
        '/api/auth/verify/check',
        data: {'email': email, 'code': code},
      );
      return response.data['valid'];
    } on DioException catch (e) {
       if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
      }
      throw Exception('인증 코드 확인에 실패했습니다.');
    } catch (e) {
      throw Exception('인증 코드 확인 중 오류가 발생했습니다.');
    }
  }

  Future<void> sendPasswordResetCode(String email) async {
    try {
      await _dio.post('/api/auth/password/code', data: {'email': email});
    } on DioException catch (e) {
       if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
      }
      throw Exception('인증 코드 발송에 실패했습니다.');
    } catch (e) {
      throw Exception('인증 코드 발송 중 오류가 발생했습니다.');
    }
  }

  Future<void> resetPassword(String email, String code, String newPasswd) async {
    try {
      await _dio.post(
        '/api/auth/password/reset',
        data: {'email': email, 'code': code, 'newPasswd': newPasswd},
      );
    } on DioException catch (e) {
       if (e.response != null && e.response!.data != null) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('error')) {
           throw Exception(data['error']);
        }
      }
      throw Exception('비밀번호 변경에 실패했습니다.');
    } catch (e) {
      throw Exception('비밀번호 변경 중 오류가 발생했습니다.');
    }
  }
}




class LoginResponse {
  final String token;
  final User user;

  LoginResponse({required this.token, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});
