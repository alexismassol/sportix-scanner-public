import 'package:flutter_test/flutter_test.dart';
import 'package:sportix_scanner_public/providers/auth_provider.dart';

void main() {
  group('AuthState', () {
    test('should be unauthenticated by default', () {
      const state = AuthState();

      expect(state.isAuthenticated, false);
      expect(state.user, null);
      expect(state.token, null);
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    test('should copy with new values', () {
      const state = AuthState();
      final updated = state.copyWith(isLoading: true);

      expect(updated.isLoading, true);
      expect(updated.user, null);
    });

    test('should clear error on copyWith', () {
      const state = AuthState(error: 'Some error');
      final updated = state.copyWith(error: null);

      expect(updated.error, null);
    });
  });
}
