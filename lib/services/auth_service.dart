import '../models/user.dart';
import '../config/api_config.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService(this._api);

  Future<({User user, String token})> login(String email, String password) async {
    final response = await _api.post(ApiConfig.loginEndpoint, data: {
      'email': email,
      'password': password,
    });

    final data = response.data['data'];
    final user = User.fromJson(data['user']);
    final token = data['token'] as String;

    _api.setToken(token);

    return (user: user, token: token);
  }

  Future<User> getMe() async {
    final response = await _api.get(ApiConfig.meEndpoint);
    return User.fromJson(response.data['data']);
  }

  void logout() {
    _api.setToken(null);
  }
}
