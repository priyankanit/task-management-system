import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'accessToken', value: access);
    await _storage.write(key: 'refreshToken', value: refresh);
  }

  Future<String?> getAccessToken() =>
      _storage.read(key: 'accessToken');

  Future<String?> getRefreshToken() =>
      _storage.read(key: 'refreshToken');

  Future<void> clear() async => _storage.deleteAll();
}
