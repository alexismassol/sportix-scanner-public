import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../services/scan_service.dart';

class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null && token != null;

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _authService.login(email, password);
      state = AuthState(user: result.user, token: result.token);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Identifiants incorrects');
    }
  }

  void logout() {
    _authService.logout();
    state = const AuthState();
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final api = ApiService();
  // Configuration IP locale pour communication native avec backend
  api.updateBaseUrl('192.168.5.178', port: '3000');
  return api;
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(apiServiceProvider));
});

final scanServiceProvider = Provider<ScanService>((ref) {
  return ScanService(ref.read(apiServiceProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});
