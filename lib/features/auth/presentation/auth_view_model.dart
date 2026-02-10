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

  Future<void> logout() async {
    await _storageService.clearAll();
    // Router redirect will handle navigation
  }
}
