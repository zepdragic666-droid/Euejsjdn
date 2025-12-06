
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A service that provides real, hardware-backed, AES-256 secure storage.
///
/// This service uses the Keychain on iOS and the Keystore on Android.
class SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  /// Encrypts and writes data to secure storage.
  Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Reads and decrypts data from secure storage.
  Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  /// Deletes data from secure storage.
  Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }
}
