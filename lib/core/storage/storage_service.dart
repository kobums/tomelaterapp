import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(); // Initialized in main.dart
});

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserNickname = 'user_nickname';

  Future<void> setToken(String token) async {
    await _prefs.setString(keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(keyToken);
  }

  Future<void> removeToken() async {
    await _prefs.remove(keyToken);
  }

  Future<void> setUser({required int id, required String email, required String nickname}) async {
    await _prefs.setInt(keyUserId, id);
    await _prefs.setString(keyUserEmail, email);
    await _prefs.setString(keyUserNickname, nickname);
  }

  int? getUserId() {
    return _prefs.getInt(keyUserId);
  }

  String? getUserEmail() {
    return _prefs.getString(keyUserEmail);
  }

  String? getUserNickname() {
    return _prefs.getString(keyUserNickname);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
