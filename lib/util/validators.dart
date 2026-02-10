/// 입력값 검증을 위한 유틸리티 클래스
/// 
/// front/src/util/index.ts의 정규식을 그대로 사용합니다.
class ValidationUtils {
  ValidationUtils._();

  // 정규식 상수
  
  /// 이메일 형식: [텍스트]@[텍스트].[텍스트]
  static final RegExp emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// 비밀번호 형식: 영문, 숫자 포함 8자 이상
  static final RegExp passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$');

  /// 닉네임 형식: 2~10자의 영문, 숫자, 한글
  static final RegExp nicknameRegex = RegExp(r'^[a-zA-Z0-9가-힣]{2,10}$');

  // 검증 메서드

  /// 이메일 검증
  /// 
  /// Returns: 에러 메시지 (유효한 경우 null)
  static String? validateEmail(String email) {
    if (email.isEmpty) {
      return '이메일을 입력해주세요.';
    }
    if (!emailRegex.hasMatch(email)) {
      return '유효하지 않은 이메일 형식입니다.';
    }
    return null;
  }

  /// 비밀번호 검증
  /// 
  /// Returns: 에러 메시지 (유효한 경우 null)
  static String? validatePassword(String password) {
    if (password.isEmpty) {
      return '비밀번호를 입력해주세요.';
    }
    if (!passwordRegex.hasMatch(password)) {
      return '비밀번호는 영문과 숫자를 포함하여 8자 이상이어야 합니다.';
    }
    return null;
  }

  /// 닉네임 검증
  /// 
  /// Returns: 에러 메시지 (유효한 경우 null)
  static String? validateNickname(String nickname) {
    if (nickname.isEmpty) {
      return '닉네임을 입력해주세요.';
    }
    if (!nicknameRegex.hasMatch(nickname)) {
      return '닉네임은 2~10자의 영문, 숫자, 한글만 가능합니다.';
    }
    return null;
  }

  /// 비밀번호 일치 확인
  /// 
  /// Returns: 에러 메시지 (일치하는 경우 null)
  static String? validatePasswordMatch(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return '비밀번호 확인을 입력해주세요.';
    }
    if (password != confirmPassword) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }
}
