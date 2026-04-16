import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'biometric_service.dart';
import 'storage_service.dart';

part 'auth_service.g.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
  waitingForBiometrics,
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<AuthStatus> build() {
    _checkPersistedAuth();
    return const AsyncValue.loading();
  }

  Future<void> _checkPersistedAuth() async {
    try {
      final storage = await ref.read(storageServiceProvider.future);
      final token = await storage.getToken();
      
      if (token == null) {
        state = const AsyncValue.data(AuthStatus.unauthenticated);
        return;
      }

      // If token exists, check if biometrics are mandatory
      final isBioEnabled = storage.isBiometricsEnabled();
      if (isBioEnabled) {
        state = const AsyncValue.data(AuthStatus.waitingForBiometrics);
      } else {
        state = const AsyncValue.data(AuthStatus.authenticated);
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Manual Login with Email/Password (Mock)
  Future<void> loginWithPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(seconds: 1));
    
    if (email == 'admin@pro.com' && password == 'admin123') {
      final storage = await ref.read(storageServiceProvider.future);
      await storage.saveToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.dummy.token");
      state = const AsyncValue.data(AuthStatus.authenticated);
    } else {
      state = AsyncValue.error('Invalid credentials', StackTrace.current);
    }
  }

  /// Biometric Login
  Future<void> loginWithBiometrics() async {
    final storage = await ref.read(storageServiceProvider.future);
    final token = await storage.getToken();
    
    if (token == null) {
      state = const AsyncValue.data(AuthStatus.unauthenticated);
      return;
    }

    state = const AsyncValue.loading();
    final biometricService = ref.read(biometricServiceProvider.notifier);
    final authType = await ref.read(authTypeProvider.future);
    
    final bool isAuthenticated = await biometricService.authenticate(
      localizedReason: 'Authenticate to access your secure vault',
      biometricOnly: authType != AppAuthType.pin,
    );
    
    if (isAuthenticated) {
      state = const AsyncValue.data(AuthStatus.authenticated);
    } else {
      // If biometrics fail, we stay in waiting state (or whatever current state was)
      state = const AsyncValue.data(AuthStatus.waitingForBiometrics);
      state = AsyncValue.error('Biometric verification failed', StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final storage = await ref.read(storageServiceProvider.future);
    await storage.deleteToken();
    state = const AsyncValue.data(AuthStatus.unauthenticated);
  }

  Future<void> toggleBiometrics(bool enabled) async {
    final storage = await ref.read(storageServiceProvider.future);
    await storage.setBiometricsEnabled(enabled);
    ref.invalidate(isBiometricsEnabledProvider);
  }
}

@riverpod
bool isBiometricsEnabled(IsBiometricsEnabledRef ref) {
  final storage = ref.watch(storageServiceProvider).valueOrNull;
  return storage?.isBiometricsEnabled() ?? false;
}
