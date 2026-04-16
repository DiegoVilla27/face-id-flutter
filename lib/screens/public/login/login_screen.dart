import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../services/auth_service.dart';
import '../../../services/biometric_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController(text: 'admin@pro.com');
  final _passwordController = TextEditingController(text: 'admin123');

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometrics if waiting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAutoBiometrics();
    });
  }

  Future<void> _checkAutoBiometrics() async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    
    // Auto-trigger ONLY if state is waitingForBiometrics
    if (authState == AuthStatus.waitingForBiometrics) {
      ref.read(authNotifierProvider.notifier).loginWithBiometrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final authType = ref.watch(authTypeProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(context.l10n.loginTitle, style: context.typography.headlineLarge),
              const SizedBox(height: 12),
              Text(context.l10n.loginSubtitle, style: context.typography.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 48),
              
              // Login Form
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),

              // Action Button
              authState.maybeWhen(
                loading: () => const CircularProgressIndicator.adaptive(),
                orElse: () => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(authNotifierProvider.notifier).loginWithPassword(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                    },
                    child: const Text('Login'),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              
              // Biometric Shortcut (Always show if hardware supports it, but action depends on state)
              authType.maybeWhen(
                data: (type) => _AuthButton(type: type),
                orElse: () => const SizedBox.shrink(),
              ),
              
              if (authState.hasError) ...[
                const SizedBox(height: 24),
                _ErrorBanner(message: authState.error.toString()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: context.colors.error),
          const SizedBox(width: 12),
          Expanded(child: Text(message, style: TextStyle(color: context.colors.error, fontSize: 13))),
        ],
      ),
    );
  }
}

class _AuthButton extends ConsumerWidget {
  final AppAuthType type;
  const _AuthButton({required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IconData icon;
    final String label;

    switch (type) {
      case AppAuthType.face: icon = Icons.face; label = context.l10n.unlockWithFaceId;
      case AppAuthType.fingerprint: icon = Icons.fingerprint; label = context.l10n.unlockWithFingerprint;
      case AppAuthType.pin: icon = Icons.grid_view_sharp; label = context.l10n.unlockWithPin;
      case AppAuthType.none: icon = Icons.no_encryption_gmailerrorred_rounded; label = context.l10n.enterUnsecured;
    }

    return TextButton.icon(
      onPressed: () => ref.read(authNotifierProvider.notifier).loginWithBiometrics(),
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
