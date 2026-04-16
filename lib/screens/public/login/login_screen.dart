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
              const SizedBox(height: 48),
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
                Container(
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
                          authState.error.toString(),
                          style: TextStyle(color: context.colors.error, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
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
        icon = Icons.lock_open;
        label = context.l10n.unlockDevice;
    }

    return ElevatedButton.icon(
      onPressed: () {
        ref.read(authNotifierProvider.notifier).login();
      },
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
