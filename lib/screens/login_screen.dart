import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'club@sport-ix.com');
  final _passwordController = TextEditingController(text: 'Club2024!');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await ref.read(authProvider.notifier).login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    final state = ref.read(authProvider);
    if (state.isAuthenticated && mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: SportixColors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text('SX', style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white,
                    )),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Sportix Scanner', style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800, color: SportixColors.textPrimary,
                )),
                const SizedBox(height: 8),
                const Text('Connectez-vous avec votre compte club', style: TextStyle(
                  fontSize: 14, color: SportixColors.textTertiary,
                )),
                const SizedBox(height: 40),

                // Error
                if (authState.error != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: SportixColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: SportixColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Text(authState.error!, style: const TextStyle(
                      color: SportixColors.error, fontSize: 13,
                    )),
                  ),

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: SportixColors.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'club@sport-ix.com',
                    prefixIcon: Icon(Icons.email_outlined, color: SportixColors.textTertiary),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: SportixColors.textPrimary, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline, color: SportixColors.textTertiary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: SportixColors.textTertiary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: SportixColors.accentGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: authState.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white,
                            ))
                          : const Text('Se connecter', style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white,
                            )),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Demo info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: SportixGlass.cardSubtle,
                  child: const Column(
                    children: [
                      Text('Compte démo', style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600, color: SportixColors.textTertiary,
                      )),
                      SizedBox(height: 4),
                      Text('club@sport-ix.com / Club2024!', style: TextStyle(
                        fontSize: 11, color: SportixColors.textTertiary,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
