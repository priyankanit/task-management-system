import '../../core/network/api_service.dart';

class AuthRepository {
  final api = ApiService().dio;

  Future<Map<String, dynamic>> login(
      String email, String password) async {
    final res = await api.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return res.data;
  }

  Future<void> register(
      String email, String password) async {
    await api.post(
      '/auth/register',
      data: {'email': email, 'password': password},
    );
  }
}
