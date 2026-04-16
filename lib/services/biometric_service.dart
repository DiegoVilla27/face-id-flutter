import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_service.g.dart';

enum AppAuthType {
  face,
  fingerprint,
  pin,
  none,
}

@riverpod
class BiometricService extends _$BiometricService {
  late final LocalAuthentication _auth;

  @override
  void build() {
    _auth = LocalAuthentication();
  }

  /// Checks if the device has biometric hardware and if it is enabled.
  Future<bool> canAuthenticate() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool isDeviceSupported = await _auth.isDeviceSupported();
    return canAuthenticateWithBiometrics && isDeviceSupported;
  }

  /// Detects the strongest available authentication method.
  Future<AppAuthType> getAvailableAuthType() async {
    final bool canCheck = await _auth.canCheckBiometrics;
    final bool isSupported = await _auth.isDeviceSupported();
    
    if (!canCheck && !isSupported) return AppAuthType.none;

    final List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
    
    if (availableBiometrics.contains(BiometricType.face)) {
      return AppAuthType.face;
    } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
      return AppAuthType.fingerprint;
    } else if (isSupported) {
      return AppAuthType.pin;
    }
    
    return AppAuthType.none;
  }

  /// Performs the actual authentication.
  Future<bool> authenticate({
    required String localizedReason,
    bool biometricOnly = true,
  }) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}

@riverpod
Future<AppAuthType> authType(AuthTypeRef ref) {
  return ref.watch(biometricServiceProvider.notifier).getAvailableAuthType();
}
