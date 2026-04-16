import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../services/auth_service.dart';
import '../../../services/biometric_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authType = ref.watch(authTypeProvider);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.l10n.loginTitle,
                style: context.typography.headlineLarge,
              ),
              const SizedBox(height: 16),
              Text(
                context.l10n.loginSubtitle,
                style: context.typography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Security Warning Molecule
              authType.maybeWhen(
                data: (type) => type == AppAuthType.none 
                  ? const _SecurityWarning() 
                  : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),
              
              // Dynamic Auth Button
              authState.maybeWhen(
                loading: () => const CircularProgressIndicator.adaptive(),
                orElse: () => authType.when(
                  data: (type) => _AuthButton(type: type),
                  loading: () => const CircularProgressIndicator.adaptive(),
                  error: (_, __) => _AuthButton(type: AppAuthType.none),
                ),
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

class _SecurityWarning extends StatelessWidget {
  const _SecurityWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 32),
          const SizedBox(height: 12),
          Text(
            context.l10n.insecureDeviceWarning,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.continueAtYourOwnRisk,
            style: TextStyle(color: Colors.orange.withValues(alpha: 0.8), fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
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
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: context.colors.error, fontSize: 13),
            ),
          ),
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
      case AppAuthType.face:
        icon = Icons.face;
        label = context.l10n.unlockWithFaceId;
      case AppAuthType.fingerprint:
        icon = Icons.fingerprint;
        label = context.l10n.unlockWithFingerprint;
      case AppAuthType.pin:
        icon = Icons.grid_view_sharp;
        label = context.l10n.unlockWithPin;
      case AppAuthType.none:
        icon = Icons.no_encryption_gmailerrorred_rounded;
        label = context.l10n.enterUnsecured;
    }

    return ElevatedButton.icon(
      onPressed: () {
        ref.read(authNotifierProvider.notifier).login();
      },
      icon: Icon(icon),
      label: Text(label),
      style: type == AppAuthType.none 
        ? ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.black)
        : null,
    );
  }
}
