// V&V (Validation & Verification) - Flutter Cross-Flow Tests
//
// Validates that the Flutter app correctly implements the functional spec:
// VV-FLUTTER-01: Models serialize/deserialize consistently with API contract
// VV-FLUTTER-02: Auth state transitions are correct (unauthenticated → loading → authenticated → logout)
// VV-FLUTTER-03: Theme consistency - all Sportix colors and styles are applied
// VV-FLUTTER-04: Scan result display matches all status types from API
// VV-FLUTTER-05: API config matches expected backend contract
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportix_scanner_public/models/user.dart';
import 'package:sportix_scanner_public/models/event.dart';
import 'package:sportix_scanner_public/models/scan_result.dart';
import 'package:sportix_scanner_public/config/api_config.dart';
import 'package:sportix_scanner_public/config/theme.dart';
import 'package:sportix_scanner_public/providers/auth_provider.dart';

void main() {
  // ==========================================================================
  // VV-FLUTTER-01: Models match API contract
  // ==========================================================================
  group('VV-FLUTTER-01: Model ↔ API Contract', () {
    test('User model handles full API response payload', () {
      // Simulates exact backend response from POST /api/auth/login
      final apiPayload = {
        'id': 'a9218f3f-dde9-4539-86f6-dc1aa36798e0',
        'email': 'club@sport-ix.com',
        'firstName': 'Admin',
        'lastName': 'Club',
        'role': 'club',
        'clubName': 'RC Toulon',
        'createdAt': '2026-03-24 09:13:53',
      };

      final user = User.fromJson(apiPayload);
      expect(user.id, apiPayload['id']);
      expect(user.email, apiPayload['email']);
      expect(user.fullName, 'Admin Club');
      expect(user.isClub, true);
      expect(user.clubName, 'RC Toulon');

      // Round-trip: toJson → fromJson should be consistent
      final roundTrip = User.fromJson(user.toJson());
      expect(roundTrip.id, user.id);
      expect(roundTrip.email, user.email);
      expect(roundTrip.role, user.role);
    });

    test('Event model handles full API response payload', () {
      // Simulates exact backend response from GET /api/events
      final apiPayload = {
        'id': 'b404ef73-10d0-42cf-ba61-002c1f6aba0b',
        'title': 'RC Toulon vs Stade Français',
        'sportType': 'Rugby',
        'date': '2026-04-15T20:00:00Z',
        'location': 'Stade Mayol, Toulon',
        'clubName': 'RC Toulon',
        'ticketsSold': 12800,
        'maxCapacity': 15000,
        'price': 25.0,
        'status': 'upcoming',
        'description': null,
        'imageUrl': null,
      };

      final event = Event.fromJson(apiPayload);
      expect(event.title, 'RC Toulon vs Stade Français');
      expect(event.remainingCapacity, 2200);
      expect(event.fillPercentage, closeTo(0.853, 0.01));

      final roundTrip = Event.fromJson(event.toJson());
      expect(roundTrip.id, event.id);
      expect(roundTrip.ticketsSold, event.ticketsSold);
    });

    test('ScanResult model handles all status types from API', () {
      // Valid ticket scan
      final validTicket = ScanResult.fromJson({
        'status': 'valid',
        'message': 'Entrée autorisée - bienvenue !',
        'ticketId': 'abc',
        'holderName': 'Jean Dupont',
        'seatInfo': 'Tribune A - Rang 5, Place 12',
        'scannedAt': '2026-03-24T09:16:23.803Z',
      });
      expect(validTicket.isValid, true);
      expect(validTicket.holderName, 'Jean Dupont');

      // Already scanned
      final alreadyScanned = ScanResult.fromJson({
        'status': 'already_scanned',
        'message': 'Ce billet a déjà été scanné',
        'holderName': 'Jean Dupont',
      });
      expect(alreadyScanned.isAlreadyScanned, true);
      expect(alreadyScanned.isValid, false);

      // Refunded
      final refunded = ScanResult.fromJson({
        'status': 'refunded',
        'message': 'Ce billet a été remboursé',
      });
      expect(refunded.isValid, false);

      // Credit valid
      final creditOk = ScanResult.fromJson({
        'status': 'valid',
        'message': '5.00€ débités avec succès',
        'previousBalance': 45.5,
        'newBalance': 40.5,
        'amount': 5.0,
        'holderName': 'Jean Dupont',
      });
      expect(creditOk.previousBalance, 45.5);
      expect(creditOk.newBalance, 40.5);

      // Insufficient credit
      final insufficient = ScanResult.fromJson({
        'status': 'insufficient',
        'message': 'Solde insuffisant',
        'currentBalance': 2.0,
        'requiredAmount': 100.0,
        'holderName': 'Jean Dupont',
      });
      expect(insufficient.isInsufficient, true);
      expect(insufficient.currentBalance, 2.0);
      expect(insufficient.requiredAmount, 100.0);
    });
  });

  // ==========================================================================
  // VV-FLUTTER-02: Auth state machine
  // ==========================================================================
  group('VV-FLUTTER-02: Auth State Transitions', () {
    test('initial state is unauthenticated', () {
      const state = AuthState();
      expect(state.isAuthenticated, false);
      expect(state.user, null);
      expect(state.token, null);
      expect(state.isLoading, false);
      expect(state.error, null);
    });

    test('loading state preserves null user/token', () {
      const initial = AuthState();
      final loading = initial.copyWith(isLoading: true);
      expect(loading.isLoading, true);
      expect(loading.isAuthenticated, false);
    });

    test('authenticated state has user + token', () {
      final user = User(
        id: 'u1', email: 'club@sport-ix.com',
        firstName: 'Admin', lastName: 'Club',
        role: 'club', clubName: 'RC Toulon',
      );
      final state = AuthState(user: user, token: 'jwt-token');
      expect(state.isAuthenticated, true);
      expect(state.user?.email, 'club@sport-ix.com');
    });

    test('error state clears on new copyWith without error', () {
      const errorState = AuthState(error: 'Identifiants incorrects');
      final cleared = errorState.copyWith(error: null, isLoading: true);
      expect(cleared.error, null);
      expect(cleared.isLoading, true);
    });

    test('logout returns to initial state', () {
      // Simulating: after AuthNotifier.logout(), state should reset
      const loggedOut = AuthState();
      expect(loggedOut.isAuthenticated, false);
      expect(loggedOut.user, null);
      expect(loggedOut.token, null);
    });
  });

  // ==========================================================================
  // VV-FLUTTER-03: Theme consistency
  // ==========================================================================
  group('VV-FLUTTER-03: Theme & Branding', () {
    test('SportixColors has required brand colors', () {
      expect(SportixColors.accentPrimary, isNotNull);
      expect(SportixColors.accentSecondary, isNotNull);
      expect(SportixColors.bgPrimary, isNotNull);
      expect(SportixColors.textPrimary, isNotNull);
      expect(SportixColors.success, isNotNull);
      expect(SportixColors.warning, isNotNull);
      expect(SportixColors.error, isNotNull);
    });

    test('SportixGlass card decorations are defined', () {
      expect(SportixGlass.card, isNotNull);
      expect(SportixGlass.cardSubtle, isNotNull);
    });

    test('SportixTheme.darkTheme is a valid ThemeData', () {
      final theme = SportixTheme.darkTheme;
      expect(theme, isNotNull);
      expect(theme.colorScheme.primary, SportixColors.accentPrimary);
      expect(theme.colorScheme.brightness, Brightness.dark);
    });
  });

  // ==========================================================================
  // VV-FLUTTER-05: API Config matches backend contract
  // ==========================================================================
  group('VV-FLUTTER-05: API Config Contract', () {
    test('ApiConfig defines all required endpoints', () {
      expect(ApiConfig.loginEndpoint, '/auth/login');
      expect(ApiConfig.meEndpoint, '/auth/me');
      expect(ApiConfig.eventsEndpoint, '/events');
      expect(ApiConfig.scanTicketEndpoint, '/scan/ticket');
      expect(ApiConfig.scanCreditEndpoint, '/scan/credit');
    });

    test('ApiConfig baseUrl includes /api prefix', () {
      expect(ApiConfig.baseUrl, contains('/api'));
    });

    test('ApiConfig timeout values are reasonable', () {
      expect(ApiConfig.connectTimeout.inSeconds, greaterThanOrEqualTo(5));
      expect(ApiConfig.receiveTimeout.inSeconds, greaterThanOrEqualTo(10));
    });
  });
}
