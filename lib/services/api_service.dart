import 'package:dio/dio.dart';
import '../config/api_config.dart';

class ApiService {
  late final Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  void setToken(String? token) {
    _token = token;
  }

  Future<Response> get(String path) async {
    return _dio.get(path);
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    return _dio.post(path, data: data);
  }

  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void updateBaseUrl(String host, {String port = '3000'}) {
    _dio.options.baseUrl = 'http://$host:$port/api';
  }
}
