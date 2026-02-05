import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../model/user.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  User? build() {
    return null;
  }

  void login(User user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}
