import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sportix_scanner_public/screens/login_screen.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('should display login form', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.text('Sportix Scanner'), findsOneWidget);
      expect(find.text('Se connecter'), findsOneWidget);
      expect(find.text('Compte démo'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    });

    testWidgets('should show pre-filled demo credentials', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      final emailField = find.byType(TextField).first;
      final emailWidget = tester.widget<TextField>(emailField);
      expect(emailWidget.controller?.text, 'club@sport-ix.com');
    });

    testWidgets('should have a password toggle button', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: LoginScreen()),
        ),
      );

      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });
}
