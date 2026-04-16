import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'biometric_service.dart';

part 'auth_service.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<bool> build() => const AsyncValue.data(false);

  Future<void> login() async {
    state = const AsyncValue.loading();
    
    final biometricService = ref.read(biometricServiceProvider.notifier);
    
    // Check what we have available
    final authType = await ref.read(authTypeProvider.future);
    
    // If device is insecure (none), bypass authentication with a direct success
    if (authType == AppAuthType.none) {
      state = const AsyncValue.data(true);
      return;
    }

    // We allow biometricOnly: false if the device only supports PIN/Pattern
    final bool biometricOnly = authType != AppAuthType.pin;

    final bool isAuthenticated = await biometricService.authenticate(
      localizedReason: 'Authenticate to access your secure vault',
      biometricOnly: biometricOnly,
    );
    
    if (isAuthenticated) {
      state = const AsyncValue.data(true);
    } else {
      state = AsyncValue.error('Authentication failed', StackTrace.current);
    }
  }

  void logout() {
    state = const AsyncValue.data(false);
  }
}
