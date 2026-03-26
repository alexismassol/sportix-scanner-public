import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';
import '../providers/auth_provider.dart';
import '../widgets/scan_result_card.dart';

class CreditScannerScreen extends ConsumerStatefulWidget {
  const CreditScannerScreen({super.key});

  @override
  ConsumerState<CreditScannerScreen> createState() => _CreditScannerScreenState();
}

class _CreditScannerScreenState extends ConsumerState<CreditScannerScreen> {
  bool _scanning = false;
  ScanResult? _lastResult;
  double _amount = 5.0;

  Future<void> _simulateScan(String qrCode) async {
    setState(() {
      _scanning = true;
      _lastResult = null;
    });

    try {
      final scanService = ref.read(scanServiceProvider);
      final result = await scanService.scanCredit(qrCode, debitAmount: _amount);
      setState(() {
        _lastResult = result;
        _scanning = false;
      });
    } catch (e) {
      setState(() {
        _lastResult = ScanResult(
          status: 'invalid',
          message: 'Erreur de connexion au serveur',
        );
        _scanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner Crédit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Zone de simulation démo (scan via boutons de scénarios)
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: SportixColors.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.payments_outlined, size: 48, color: SportixColors.success.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  const Text('Scanner un crédit', style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600, color: SportixColors.textSecondary,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Amount selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: SportixGlass.card,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Montant à débiter', style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: SportixColors.textSecondary,
                  )),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [3.0, 5.0, 10.0, 15.0].map((amount) {
                      final selected = _amount == amount;
                      return GestureDetector(
                        onTap: () => setState(() => _amount = amount),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: selected ? SportixColors.successGradient : null,
                            color: selected ? null : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${amount.toStringAsFixed(0)}€',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : SportixColors.textTertiary,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Demo scenarios
            const Text('Scénarios de démonstration', style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600, color: SportixColors.textSecondary,
            )),
            const SizedBox(height: 12),
            _DemoButton(
              label: 'Paiement réussi',
              icon: Icons.check_circle,
              color: SportixColors.success,
              onTap: _scanning ? null : () => _simulateScan('REVNTy1DUkVESVQtT0s='), // Base64 de 'DEMO-CREDIT-OK'
            ),
            _DemoButton(
              label: 'Solde insuffisant',
              icon: Icons.warning_amber,
              color: SportixColors.warning,
              onTap: _scanning ? null : () {
                setState(() => _amount = 100);
                _simulateScan('REVNTy1DUkVESVQtTE9X'); // Base64 de 'DEMO-CREDIT-LOW'
              },
            ),
            _DemoButton(
              label: 'QR invalide',
              icon: Icons.block,
              color: SportixColors.error,
              onTap: _scanning ? null : () => _simulateScan('Q1JFSURUQ1JFQRlWRU5U'), // Base64 de 'CREDIT-INVALID'
            ),
            const SizedBox(height: 24),

            if (_scanning)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: SportixColors.success),
              ),

            if (_lastResult != null && !_scanning)
              ScanResultCard(result: _lastResult!),
          ],
        ),
      ),
    );
  }
}

class _DemoButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DemoButton({
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: SportixGlass.cardSubtle,
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
            const Spacer(),
            Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
