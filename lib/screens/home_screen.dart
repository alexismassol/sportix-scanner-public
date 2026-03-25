import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bonjour, ${user?.firstName ?? ''}',
                        style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w800, color: SportixColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.clubName ?? 'Club partenaire',
                        style: const TextStyle(fontSize: 14, color: SportixColors.textTertiary),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    icon: const Icon(Icons.logout, color: SportixColors.textTertiary),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick actions
              const Text('Actions rapides', style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: SportixColors.textPrimary,
              )),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.qr_code_scanner,
                      title: 'Scanner\nBillet',
                      gradient: SportixColors.accentGradient,
                      onTap: () => Navigator.of(context).pushNamed('/scan/ticket'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.payments_outlined,
                      title: 'Scanner\nCrédit',
                      gradient: SportixColors.successGradient,
                      onTap: () => Navigator.of(context).pushNamed('/scan/credit'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Menu items
              _MenuItem(
                icon: Icons.event,
                title: 'Événements',
                subtitle: 'Sélectionner un événement actif',
                onTap: () => Navigator.of(context).pushNamed('/events'),
              ),
              _MenuItem(
                icon: Icons.history,
                title: 'Historique',
                subtitle: 'Derniers scans effectués',
                onTap: () => Navigator.of(context).pushNamed('/history'),
              ),
              _MenuItem(
                icon: Icons.settings,
                title: 'Paramètres',
                subtitle: 'Configuration de l\'application',
                onTap: () => Navigator.of(context).pushNamed('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            Text(title, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, height: 1.3,
            )),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: SportixGlass.card,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: SportixColors.textSecondary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: SportixColors.textPrimary,
                  )),
                  Text(subtitle, style: const TextStyle(
                    fontSize: 12, color: SportixColors.textTertiary,
                  )),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: SportixColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
