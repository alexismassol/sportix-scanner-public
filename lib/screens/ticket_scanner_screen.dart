import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../models/scan_result.dart';
import '../providers/auth_provider.dart';
import '../widgets/scan_result_card.dart';

class TicketScannerScreen extends ConsumerStatefulWidget {
  const TicketScannerScreen({super.key});

  @override
  ConsumerState<TicketScannerScreen> createState() => _TicketScannerScreenState();
}

class _TicketScannerScreenState extends ConsumerState<TicketScannerScreen> {
  bool _scanning = false;
  ScanResult? _lastResult;

  Future<void> _simulateScan(String qrCode) async {
    setState(() {
      _scanning = true;
      _lastResult = null;
    });

    try {
      final scanService = ref.read(scanServiceProvider);
      final result = await scanService.scanTicket(qrCode);
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
      appBar: AppBar(title: const Text('Scanner Billet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Zone de simulation démo (scan via boutons de scénarios)
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: SportixColors.accentPrimary.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    size: 64,
                    color: SportixColors.accentPrimary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Scanner un QR code',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: SportixColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sélectionnez un scénario ci-dessous',
                    style: TextStyle(fontSize: 12, color: SportixColors.textTertiary),
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
              label: 'Billet valide',
              icon: Icons.check_circle,
              color: SportixColors.success,
              onTap: _scanning ? null : () => _simulateScan('REVNTy1WQUxJRC1USUNLRVQ='), // Base64 de 'DEMO-VALID-TICKET'
            ),
            _DemoButton(
              label: 'Déjà scanné',
              icon: Icons.warning_amber,
              color: SportixColors.warning,
              onTap: _scanning ? null : () => _simulateScan('REVNTy1TQ0FOTkVELVRJQ0tFVA=='), // Base64 de 'DEMO-SCANNED-TICKET'
            ),
            _DemoButton(
              label: 'Billet remboursé',
              icon: Icons.cancel,
              color: SportixColors.error,
              onTap: _scanning ? null : () => _simulateScan('REVNTy1SRUZVTkRFRC1USUNLRVQ='), // Base64 de 'DEMO-REFUNDED-TICKET'
            ),
            _DemoButton(
              label: 'QR invalide',
              icon: Icons.block,
              color: SportixColors.textTertiary,
              onTap: _scanning ? null : () => _simulateScan('SUJQRUNtRVZFTlRfUExBTk5FRA=='), // Base64 de 'INVALID-TICKET'
            ),
            const SizedBox(height: 24),

            // Loading
            if (_scanning)
              const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: SportixColors.accentPrimary),
              ),

            // Result
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
            Text(label, style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500, color: color,
            )),
            const Spacer(),
            Icon(Icons.chevron_right, color: color.withValues(alpha: 0.5), size: 18),
          ],
        ),
      ),
    );
  }
}
