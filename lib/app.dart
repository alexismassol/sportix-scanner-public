import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/event_select_screen.dart';
import 'screens/ticket_scanner_screen.dart';
import 'screens/credit_scanner_screen.dart';
import 'screens/scan_history_screen.dart';
import 'screens/settings_screen.dart';
import 'providers/auth_provider.dart';

class SportixScannerApp extends ConsumerWidget {
  const SportixScannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Sportix Scanner',
      debugShowCheckedModeBanner: false,
      theme: SportixTheme.darkTheme,
      initialRoute: authState.isAuthenticated ? '/home' : '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/events': (context) => const EventSelectScreen(),
        '/scan/ticket': (context) => const TicketScannerScreen(),
        '/scan/credit': (context) => const CreditScannerScreen(),
        '/history': (context) => const ScanHistoryScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
