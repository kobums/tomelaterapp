import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return AuthViewModel(authRepository, storageService);
});

class AuthViewModel extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;
  final StorageService _storageService;

  AuthViewModel(this._authRepository, this._storageService) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await _authRepository.login(email, password);
      await _storageService.setToken(response.token);
      await _storageService.setUser(
        id: response.user.id,
        email: response.user.email,
        nickname: response.user.nickname,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // 회원 탈퇴: 서버에서 계정·답변을 삭제한 뒤 저장된 로그인 정보를 지운다.
  // 실패하면 예외를 던지고 로그인 상태는 그대로 둔다.
  Future<void> withdraw() async {
    final id = _storageService.getUserId();
    if (id == null) {
      throw Exception('로그인 정보를 찾을 수 없습니다. 다시 로그인해주세요.');
    }
    await _authRepository.deleteAccount(id);
    await _storageService.clearAll();
  }

  Future<void> logout() async {
    await _storageService.clearAll();
    // Router redirect will handle navigation
  }
}
