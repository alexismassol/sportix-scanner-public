import 'package:flutter_test/flutter_test.dart';
import 'package:sportix_scanner_public/models/user.dart';
import 'package:sportix_scanner_public/models/event.dart';
import 'package:sportix_scanner_public/models/scan_result.dart';

void main() {
  group('User Model', () {
    test('should create User from JSON', () {
      final json = {
        'id': 'u1',
        'email': 'club@sport-ix.com',
        'firstName': 'Club',
        'lastName': 'Demo',
        'role': 'club',
        'clubName': 'FC Demo',
      };

      final user = User.fromJson(json);

      expect(user.id, 'u1');
      expect(user.email, 'club@sport-ix.com');
      expect(user.firstName, 'Club');
      expect(user.lastName, 'Demo');
      expect(user.role, 'club');
      expect(user.clubName, 'FC Demo');
      expect(user.fullName, 'Club Demo');
      expect(user.isClub, true);
      expect(user.isSpectator, false);
    });

    test('should serialize User to JSON', () {
      final user = User(
        id: 'u1',
        email: 'test@test.com',
        firstName: 'Jean',
        lastName: 'Dupont',
        role: 'spectator',
      );

      final json = user.toJson();

      expect(json['id'], 'u1');
      expect(json['email'], 'test@test.com');
      expect(json['firstName'], 'Jean');
      expect(json['role'], 'spectator');
      expect(json['clubName'], null);
    });

    test('should identify spectator role', () {
      final user = User(
        id: 'u2',
        email: 'spectateur@sport-ix.com',
        firstName: 'Spectateur',
        lastName: 'Demo',
        role: 'spectator',
      );

      expect(user.isSpectator, true);
      expect(user.isClub, false);
    });
  });

  group('Event Model', () {
    test('should create Event from JSON', () {
      final json = {
        'id': 'e1',
        'title': 'Match de Rugby',
        'sportType': 'Rugby',
        'date': '2026-06-15T20:00:00Z',
        'location': 'Stade Municipal',
        'clubName': 'RC Toulouse',
        'ticketsSold': 800,
        'maxCapacity': 1200,
        'price': 15.0,
        'status': 'upcoming',
      };

      final event = Event.fromJson(json);

      expect(event.id, 'e1');
      expect(event.title, 'Match de Rugby');
      expect(event.sportType, 'Rugby');
      expect(event.ticketsSold, 800);
      expect(event.maxCapacity, 1200);
      expect(event.remainingCapacity, 400);
      expect(event.fillPercentage, closeTo(0.667, 0.01));
    });

    test('should compute remaining capacity', () {
      final event = Event(
        id: 'e2',
        title: 'Test',
        sportType: 'Football',
        date: '2026-06-20T18:00:00Z',
        location: 'Stade',
        clubName: 'FC Test',
        ticketsSold: 500,
        maxCapacity: 1000,
        price: 10.0,
        status: 'upcoming',
      );

      expect(event.remainingCapacity, 500);
      expect(event.fillPercentage, 0.5);
    });
  });

  group('ScanResult Model', () {
    test('should create ScanResult from JSON', () {
      final json = {
        'status': 'valid',
        'message': 'Entrée autorisée',
        'holderName': 'Jean Dupont',
        'seatInfo': 'Tribune A',
        'ticketId': 't1',
      };

      final result = ScanResult.fromJson(json);

      expect(result.status, 'valid');
      expect(result.message, 'Entrée autorisée');
      expect(result.holderName, 'Jean Dupont');
      expect(result.seatInfo, 'Tribune A');
      expect(result.isValid, true);
      expect(result.isAlreadyScanned, false);
    });

    test('should identify already_scanned status', () {
      final result = ScanResult(
        status: 'already_scanned',
        message: 'Déjà scanné',
      );

      expect(result.isAlreadyScanned, true);
      expect(result.isValid, false);
    });

    test('should identify insufficient status', () {
      final result = ScanResult(
        status: 'insufficient',
        message: 'Solde insuffisant',
        previousBalance: 10.0,
        newBalance: 10.0,
        amount: 50.0,
      );

      expect(result.isInsufficient, true);
      expect(result.previousBalance, 10.0);
    });

    test('should serialize ScanResult to JSON', () {
      final result = ScanResult(
        status: 'valid',
        message: 'OK',
        holderName: 'Test',
      );

      final json = result.toJson();

      expect(json['status'], 'valid');
      expect(json['message'], 'OK');
      expect(json['holderName'], 'Test');
      expect(json['timestamp'], isNotNull);
    });
  });
}
