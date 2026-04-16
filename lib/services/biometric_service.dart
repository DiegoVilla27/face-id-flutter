import 'package:local_auth/local_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'biometric_service.g.dart';

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

  /// Returns a list of available biometric types (face, fingerprint, etc.).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    return await _auth.getAvailableBiometrics();
  }

  /// Performs the actual authentication.
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      // Logic for handling lockout or specific errors can go here
      return false;
    }
  }
}
