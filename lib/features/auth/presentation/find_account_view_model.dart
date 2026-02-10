import 'dart:async';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/util/validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FindAccountTab { email, password }
enum FindPasswordStep { request, verify }

class FindAccountState {
  final FindAccountTab currentTab;
  
  // Find Email State
  final String nickname;
  final String? foundEmail;
  final bool isFindingEmail;
  final String? findEmailError;

  // Find Password State
  final FindPasswordStep passwordStep;
  final String email;
  final String verificationCode;
  final String newPassword;
  final String confirmPassword;
  final bool isSendingCode;
  final bool isResettingPassword;
  final int timeLeft;
  final String? findPasswordError;
  final String? passwordSuccessMessage;

  FindAccountState({
    this.currentTab = FindAccountTab.email,
    this.nickname = '',
    this.foundEmail,
    this.isFindingEmail = false,
    this.findEmailError,
    this.passwordStep = FindPasswordStep.request,
    this.email = '',
    this.verificationCode = '',
    this.newPassword = '',
    this.confirmPassword = '',
    this.isSendingCode = false,
    this.isResettingPassword = false,
    this.timeLeft = 0,
    this.findPasswordError,
    this.passwordSuccessMessage,
  });

  FindAccountState copyWith({
    FindAccountTab? currentTab,
    String? nickname,
    String? foundEmail,
    bool? isFindingEmail,
    String? findEmailError,
    FindPasswordStep? passwordStep,
    String? email,
    String? verificationCode,
    String? newPassword,
    String? confirmPassword,
    bool? isSendingCode,
    bool? isResettingPassword,
    int? timeLeft,
    String? findPasswordError,
    String? passwordSuccessMessage,
  }) {
    // Note: For nullable fields, this simple copyWith doesn't support setting to null.
    // Use specific methods or rebuild state if clearing is needed.
    return FindAccountState(
      currentTab: currentTab ?? this.currentTab,
      nickname: nickname ?? this.nickname,
      foundEmail: foundEmail ?? this.foundEmail,
      isFindingEmail: isFindingEmail ?? this.isFindingEmail,
      findEmailError: findEmailError ?? this.findEmailError,
      passwordStep: passwordStep ?? this.passwordStep,
      email: email ?? this.email,
      verificationCode: verificationCode ?? this.verificationCode,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isResettingPassword: isResettingPassword ?? this.isResettingPassword,
      timeLeft: timeLeft ?? this.timeLeft,
      findPasswordError: findPasswordError ?? this.findPasswordError,
      passwordSuccessMessage: passwordSuccessMessage ?? this.passwordSuccessMessage,
    );
  }
}

class FindAccountViewModel extends StateNotifier<FindAccountState> {
  final AuthRepository _authRepository;
  Timer? _timer;

  FindAccountViewModel(this._authRepository) : super(FindAccountState());

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setTab(FindAccountTab tab) {
    // When switching tabs, reset all state to ensure clean UI
    state = FindAccountState(currentTab: tab);
  }

  // Find Email Logic
  Future<void> findEmail(String nickname) async {
    if (nickname.isEmpty) {
      // Force update error by creating new state with error
      state = state.copyWith(findEmailError: '닉네임을 입력해주세요.');
      return;
    }

    // Set loading and clear error
    state = FindAccountState(
      currentTab: state.currentTab,
      nickname: nickname,
      isFindingEmail: true,
      // preserve other fields if needed, but for isolation usually fine to reset result
    );

    try {
      final email = await _authRepository.findEmail(nickname);
      state = state.copyWith(
        isFindingEmail: false,
        foundEmail: email,
      );
    } catch (e) {
      state = state.copyWith(
        isFindingEmail: false,
        findEmailError: '이메일을 찾을 수 없습니다.', // Simply the message
      );
    }
  }

  void resetFindEmail() {
    state = state.copyWith(foundEmail: null, nickname: '');
    // Since copyWith can't set null with the above implementation,
    // we manually construct:
    state = FindAccountState(currentTab: state.currentTab);
  }

  // Find Password Logic
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

  Future<void> sendResetCode(String email) async {
    if (email.isEmpty || !email.contains('@')) {
       // Force error update
       state = FindAccountState(
         currentTab: state.currentTab,
         passwordStep: state.passwordStep,
         email: email,
         findPasswordError: '유효하지 않은 이메일 형식입니다.',
       );
      return;
    }

    state = state.copyWith(isSendingCode: true, findPasswordError: '');
    // Note: copyWith above won't clear error if it's not null in previous state with '??'.
    // So we need to be careful. Better to reconstruct or fix copyWith.
    // Let's rely on constructing new state for major transitions.
    
    try {
      await _authRepository.sendPasswordResetCode(email);
      state = state.copyWith(
        isSendingCode: false,
        passwordStep: FindPasswordStep.verify,
        email: email,
      );
      _startTimer();
    } catch (e) {
      state = state.copyWith(
        isSendingCode: false,
        findPasswordError: '인증 코드 발송 실패: ${e.toString()}',
      );
    }
  }

  Future<void> resetPassword(String code, String newPass, String confirmPass) async {
    if (code.length != 6) {
      state = state.copyWith(findPasswordError: '인증 코드는 6자리 숫자여야 합니다.');
      return;
    }
    if (state.timeLeft == 0) {
       state = state.copyWith(findPasswordError: '인증 시간이 만료되었습니다. 다시 시도해주세요.');
       return;
    }
    
    // 비밀번호 검증을 ValidationUtils로 통합
    final passwordError = ValidationUtils.validatePassword(newPass);
    if (passwordError != null) {
      state = state.copyWith(findPasswordError: passwordError);
      return;
    }
    
    if (newPass != confirmPass) {
      state = state.copyWith(findPasswordError: '비밀번호가 일치하지 않습니다.');
      return;
    }

    state = state.copyWith(isResettingPassword: true, findPasswordError: '');
    try {
      await _authRepository.resetPassword(state.email, code, newPass);
      state = state.copyWith(
        isResettingPassword: false,
        passwordSuccessMessage: '비밀번호가 성공적으로 변경되었습니다. 로그인해주세요.',
      );
      _timer?.cancel();
    } catch (e) {
      state = state.copyWith(
        isResettingPassword: false,
        findPasswordError: '비밀번호 변경 실패: ${e.toString()}',
      );
    }
  }

  void resetPasswordStep() {
    _timer?.cancel();
     state = FindAccountState(
       currentTab: state.currentTab,
       passwordStep: FindPasswordStep.request,
    );
  }

  String formatTime(int seconds) {
    final mins = (seconds / 60).floor();
    final secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

final findAccountViewModelProvider =
    StateNotifierProvider.autoDispose<FindAccountViewModel, FindAccountState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return FindAccountViewModel(authRepository);
});
