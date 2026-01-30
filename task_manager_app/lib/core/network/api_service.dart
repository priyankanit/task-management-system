import 'package:dio/dio.dart';
import 'package:task_manager_app/core/config/api_config.dart';

import '../storage/secure_storage.dart';
import 'dio_interceptor.dart';

class ApiService {
  late Dio dio;

  ApiService() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl, 
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(dio, SecureStorage()),
    );
  }
}
