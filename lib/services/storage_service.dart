import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'storage_service.g.dart';

class StorageService {
  StorageService(this._secureStorage, this._prefs);

  final FlutterSecureStorage _secureStorage;
  final SharedPreferences _prefs;

  static const _tokenKey = 'auth_token';
  static const _biometricsKey = 'biometrics_enabled';

  // Token Management (Secure)
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: _tokenKey);
  }

  // Preferences Management (Non-sensitive)
  Future<void> setBiometricsEnabled(bool enabled) async {
    await _prefs.setBool(_biometricsKey, enabled);
  }

  bool isBiometricsEnabled() {
    return _prefs.getBool(_biometricsKey) ?? false;
  }
}

@riverpod
Future<StorageService> storageService(StorageServiceRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  return StorageService(const FlutterSecureStorage(), prefs);
}
