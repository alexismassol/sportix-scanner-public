import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../config/api_config.dart';
import '../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: SportixGlass.card,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: SportixColors.accentGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${authState.user?.firstName.characters.first ?? ''}${authState.user?.lastName.characters.first ?? ''}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.user?.fullName ?? '',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: SportixColors.textPrimary),
                        ),
                        Text(
                          authState.user?.email ?? '',
                          style: const TextStyle(fontSize: 12, color: SportixColors.textTertiary),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: SportixColors.accentPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            authState.user?.role == 'club' ? 'Club' : 'Spectateur',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: SportixColors.accentPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // API config
            const Text('Configuration', style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: SportixColors.textTertiary,
            )),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: SportixGlass.card,
              child: Column(
                children: [
                  _InfoRow(label: 'Serveur API', value: ApiConfig.baseUrl),
                  const Divider(color: SportixColors.borderSubtle, height: 24),
                  const _InfoRow(label: 'Version', value: '1.0.0 (demo)'),
                  const Divider(color: SportixColors.borderSubtle, height: 24),
                  const _InfoRow(label: 'Auteur', value: 'Alexis MASSOL'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                icon: const Icon(Icons.logout, size: 18),
                label: const Text('Déconnexion'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SportixColors.error,
                  side: const BorderSide(color: SportixColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: SportixColors.textTertiary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: SportixColors.textPrimary)),
      ],
    );
  }
}
