import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

class ScanHistoryScreen extends ConsumerWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scanService = ref.read(scanServiceProvider);
    final history = scanService.history;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: SportixColors.textTertiary),
              onPressed: () {
                scanService.clearHistory();
                (context as Element).markNeedsBuild();
              },
            ),
        ],
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 48, color: SportixColors.textTertiary.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text('Aucun scan effectué', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: SportixColors.textTertiary,
                  )),
                  const SizedBox(height: 8),
                  const Text('Les scans apparaîtront ici', style: TextStyle(
                    fontSize: 13, color: SportixColors.textTertiary,
                  )),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final scan = history[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: SportixGlass.card,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _statusColor(scan.status).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_statusIcon(scan.status), color: _statusColor(scan.status), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scan.message,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: SportixColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (scan.holderName != null)
                              Text(scan.holderName!, style: const TextStyle(
                                fontSize: 11, color: SportixColors.textTertiary,
                              )),
                          ],
                        ),
                      ),
                      Text(
                        '${scan.timestamp.hour.toString().padLeft(2, '0')}:${scan.timestamp.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 11, color: SportixColors.textTertiary),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'valid': return SportixColors.success;
      case 'already_scanned': return SportixColors.warning;
      default: return SportixColors.error;
    }
  }

  IconData _statusIcon(String status) {
    switch (status) {
      case 'valid': return Icons.check_circle;
      case 'already_scanned': return Icons.warning_amber;
      default: return Icons.cancel;
    }
  }
}
