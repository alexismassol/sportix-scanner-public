import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportix_scanner_public/widgets/scan_result_card.dart';
import 'package:sportix_scanner_public/models/scan_result.dart';

void main() {
  group('ScanResultCard Widget Tests', () {
    testWidgets('should display valid result', (tester) async {
      final result = ScanResult(
        status: 'valid',
        message: 'Entrée autorisée',
        holderName: 'Jean Dupont',
        seatInfo: 'Tribune A — Rang 5',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanResultCard(result: result),
          ),
        ),
      );

      expect(find.text('Validé'), findsOneWidget);
      expect(find.text('Entrée autorisée'), findsOneWidget);
      expect(find.text('Jean Dupont'), findsOneWidget);
      expect(find.text('Tribune A — Rang 5'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should display already_scanned result', (tester) async {
      final result = ScanResult(
        status: 'already_scanned',
        message: 'Ce billet a déjà été scanné',
        holderName: 'Marie Martin',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanResultCard(result: result),
          ),
        ),
      );

      expect(find.text('Doublon détecté'), findsOneWidget);
      expect(find.text('Ce billet a déjà été scanné'), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('should display credit result with balance', (tester) async {
      final result = ScanResult(
        status: 'valid',
        message: '5.00€ débités',
        holderName: 'Jean Dupont',
        previousBalance: 45.50,
        newBalance: 40.50,
        amount: 5.0,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanResultCard(result: result),
          ),
        ),
      );

      expect(find.text('Validé'), findsOneWidget);
      expect(find.text('Avant'), findsOneWidget);
      expect(find.text('Après'), findsOneWidget);
      expect(find.text('45.50€'), findsOneWidget);
      expect(find.text('40.50€'), findsOneWidget);
    });

    testWidgets('should display invalid result', (tester) async {
      final result = ScanResult(
        status: 'invalid',
        message: 'QR code non reconnu',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScanResultCard(result: result),
          ),
        ),
      );

      expect(find.text('Invalide'), findsOneWidget);
      expect(find.text('QR code non reconnu'), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });
  });
}
