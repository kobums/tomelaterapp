import 'dart:async';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/util/validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterViewModel, RegisterState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterViewModel(authRepository);
});

class RegisterState {
  final bool isLoading;
  final bool isEmailSent;
  final bool isEmailVerified;
  final bool isSendingCode;
  final bool isVerifyingCode;
  final int timeLeft;
  final String? error;
  final Map<String, String> fieldErrors;

  RegisterState({
    this.isLoading = false,
    this.isEmailSent = false,
    this.isEmailVerified = false,
    this.isSendingCode = false,
    this.isVerifyingCode = false,
    this.timeLeft = 0,
    this.error,
    this.fieldErrors = const {},
  });

  RegisterState copyWith({
    bool? isLoading,
    bool? isEmailSent,
    bool? isEmailVerified,
    bool? isSendingCode,
    bool? isVerifyingCode,
    int? timeLeft,
    String? error,
    Map<String, String>? fieldErrors,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isEmailSent: isEmailSent ?? this.isEmailSent,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
      timeLeft: timeLeft ?? this.timeLeft,
      error: error,
      fieldErrors: fieldErrors ?? this.fieldErrors,
    );
  }
}

class RegisterViewModel extends StateNotifier<RegisterState> {
  final AuthRepository _authRepository;
  Timer? _timer;

  RegisterViewModel(this._authRepository) : super(RegisterState());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(timeLeft: 300); // 5 minutes
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        state = state.copyWith(timeLeft: state.timeLeft - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> sendVerificationCode(String email) async {
    final emailError = ValidationUtils.validateEmail(email);
    if (emailError != null) {
      state = state.copyWith(
          fieldErrors: {...state.fieldErrors, 'email': emailError});
      return;
    }

    state = state.copyWith(
        isSendingCode: true,
        fieldErrors: {...state.fieldErrors}..remove('email'));
    try {
      await _authRepository.sendVerificationCode(email);
      state = state.copyWith(isEmailSent: true, isSendingCode: false);
      _startTimer();
    } catch (e) {
      state = state.copyWith(
          error: '인증 코드 발송 실패: ${e.toString()}', isSendingCode: false);
    }
  }

  Future<void> verifyCode(String email, String code) async {
    if (code.length != 6) {
      state = state.copyWith(
          fieldErrors: {...state.fieldErrors, 'code': '인증 코드는 6자리 숫자여야 합니다.'});
      return;
    }

    if (state.timeLeft == 0) {
      state = state.copyWith(error: '인증 시간이 만료되었습니다. 다시 시도해주세요.');
      return;
    }

    state = state.copyWith(
        isVerifyingCode: true,
        fieldErrors: {...state.fieldErrors}..remove('code'));
    try {
      final isValid = await _authRepository.checkVerificationCode(email, code);
      if (isValid) {
        state = state.copyWith(
            isEmailVerified: true,
            isVerifyingCode: false,
            timeLeft: 0);
        _timer?.cancel();
      } else {
       state = state.copyWith(
            fieldErrors: {...state.fieldErrors, 'code': '인증 코드가 일치하지 않습니다.'},
            isVerifyingCode: false);
      }
    } catch (e) {
      state = state.copyWith(
          error: '인증 코드 확인 실패: ${e.toString()}', isVerifyingCode: false);
    }
  }

  Future<bool> register({
    required String nickname,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // 이메일 인증 확인
    if (!state.isEmailVerified) {
      state = state.copyWith(error: '이메일 인증을 완료해주세요.');
      return false;
    }

    // 전체 필드 검증
    final Map<String, String> newFieldErrors = {};
    
    final nicknameError = ValidationUtils.validateNickname(nickname);
    if (nicknameError != null) {
      newFieldErrors['nickname'] = nicknameError;
    }
    
    final emailError = ValidationUtils.validateEmail(email);
    if (emailError != null) {
      newFieldErrors['email'] = emailError;
    }
    
    final passwordError = ValidationUtils.validatePassword(password);
    if (passwordError != null) {
      newFieldErrors['password'] = passwordError;
    }
    
    final confirmPasswordError = ValidationUtils.validatePasswordMatch(password, confirmPassword);
    if (confirmPasswordError != null) {
      newFieldErrors['confirmPassword'] = confirmPasswordError;
    }

    if (newFieldErrors.isNotEmpty) {
      state = state.copyWith(fieldErrors: newFieldErrors);
      return false;
    }

    state = state.copyWith(isLoading: true, error: null, fieldErrors: {});
    try {
      await _authRepository.register({
        'nickname': nickname,
        'email': email,
        'passwd': password,
        'socialtype': 'NONE',
        'socialid': '',
      });
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: '회원가입 실패: ${e.toString()}');
      return false;
    }
  }

  String formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
