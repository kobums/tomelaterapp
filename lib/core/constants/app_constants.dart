/// 앱 전역 상수 정의
class AppConstants {
  // API 설정
  static const String apiBaseUrl = 'https://tomelaterspring.gowoobro.com';
  
  // 타임아웃 설정
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // 페이지네이션
  static const int defaultPageSize = 20;
  static const int historyPageSize = 10;
  
  // 로컬 스토리지 키
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserNickname = 'user_nickname';
  
  // 앱 정보
  static const String appName = 'To Me, A Year Later';
  static const String appVersion = '1.0.0';
}
