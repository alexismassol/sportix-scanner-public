import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportix_scanner_public/app.dart';

void main() {
  group('Full Flow Integration Tests', () {
    testWidgets('should show login screen when not authenticated', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SportixScannerApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sportix Scanner'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
    });

    testWidgets('should show email and password fields on login', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SportixScannerApp()),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
    });

    testWidgets('should show demo account info', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: SportixScannerApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Compte démo'), findsOneWidget);
      expect(find.text('club@sport-ix.com / Club2024!'), findsOneWidget);
    });
  });
}
