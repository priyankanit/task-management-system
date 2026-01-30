import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorage storage;

  AuthInterceptor(this.dio, this.storage);

  @override
  Future onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler) async {
    final token = await storage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future onError(
      DioError err,
      ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.getRefreshToken();

      if (refreshToken != null) {
        final response = await dio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newToken = response.data['accessToken'];
        await storage.saveTokens(newToken, refreshToken);

        err.requestOptions.headers['Authorization'] =
            'Bearer $newToken';

        final retryResponse =
            await dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      }
    }
    return handler.reject(err);
  }
}
