import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'biometric_service.dart';

part 'auth_service.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<bool> build() => const AsyncValue.data(false);

  Future<void> loginWithBiometrics({required String reason}) async {
    state = const AsyncValue.loading();
    
    final biometricService = ref.read(biometricServiceProvider.notifier);
    final bool canCheck = await biometricService.canAuthenticate();
    
    if (canCheck) {
      final bool isAuthenticated = await biometricService.authenticate(
        localizedReason: reason,
      );
      
      if (isAuthenticated) {
        state = const AsyncValue.data(true);
      } else {
        state = AsyncValue.error('Authentication failed: Could not verify identity.', StackTrace.current);
      }
    } else {
      state = AsyncValue.error('Biometrics not available: Ensure Face ID is enrolled in Simulator features.', StackTrace.current);
    }
  }

  void logout() {
    state = const AsyncValue.data(false);
  }
}
