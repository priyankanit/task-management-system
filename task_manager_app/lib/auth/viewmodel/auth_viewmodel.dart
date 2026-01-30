import 'package:flutter/material.dart';

import '../../core/storage/secure_storage.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final _repo = AuthRepository();
  final _storage = SecureStorage();

  bool isLoading = false;

   bool _isLoggedIn = false;
   bool _isCheckingAuth = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isCheckingAuth => _isCheckingAuth;

  Future<void> checkLoginStatus() async {
     _isCheckingAuth = true;
    notifyListeners();
    final token = await _storage.getAccessToken();
    _isLoggedIn = token != null;
    _isCheckingAuth = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final data = await _repo.login(email, password);
    await _storage.saveTokens(
      data['accessToken'],
      data['refreshToken'],
    );

    isLoading = false;
    notifyListeners();
  }
  

  Future<void> register(String email, String password) async {
    await _repo.register(email, password);
  }

  Future<void> logout() async {
  await _storage.clear();
  _isLoggedIn = false;
    notifyListeners();
}

}


