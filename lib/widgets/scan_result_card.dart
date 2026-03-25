import 'package:flutter/material.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';

class ScanResultCard extends StatelessWidget {
  final ScanResult result;

  const ScanResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor.withValues(alpha: 0.3), width: 2),
      ),
      child: Column(
        children: [
          // Status icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _statusColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(_statusIcon, color: _statusColor, size: 32),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            _statusTitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _statusColor,
            ),
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            result.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: SportixColors.textSecondary),
          ),

          // Holder name
          if (result.holderName != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: SportixColors.textTertiary, size: 16),
                  const SizedBox(width: 6),
                  Text(result.holderName!, style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500, color: SportixColors.textPrimary,
                  )),
                ],
              ),
            ),
          ],

          // Seat info
          if (result.seatInfo != null) ...[
            const SizedBox(height: 8),
            Text(result.seatInfo!, style: const TextStyle(
              fontSize: 12, color: SportixColors.textTertiary,
            )),
          ],

          // Balance info (credits)
          if (result.previousBalance != null && result.newBalance != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BalanceBox(label: 'Avant', value: '${result.previousBalance!.toStringAsFixed(2)}€', color: SportixColors.textTertiary),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.arrow_forward, color: SportixColors.textTertiary, size: 18),
                ),
                _BalanceBox(label: 'Après', value: '${result.newBalance!.toStringAsFixed(2)}€', color: SportixColors.success),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color get _statusColor {
    switch (result.status) {
      case 'valid': return SportixColors.success;
      case 'already_scanned': return SportixColors.warning;
      case 'insufficient': return SportixColors.warning;
      default: return SportixColors.error;
    }
  }

  IconData get _statusIcon {
    switch (result.status) {
      case 'valid': return Icons.check_circle;
      case 'already_scanned': return Icons.warning_amber;
      case 'insufficient': return Icons.account_balance_wallet;
      default: return Icons.cancel;
    }
  }

  String get _statusTitle {
    switch (result.status) {
      case 'valid': return 'Validé';
      case 'already_scanned': return 'Doublon détecté';
      case 'refunded': return 'Remboursé';
      case 'insufficient': return 'Solde insuffisant';
      default: return 'Invalide';
    }
  }
}

class _BalanceBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _BalanceBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: SportixColors.textTertiary)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
