import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

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
              // Face ID button or Loading
              authState.maybeWhen(
                loading: () => const CircularProgressIndicator.adaptive(),
                orElse: () => ElevatedButton(
                  onPressed: () {
                    ref.read(authNotifierProvider.notifier).loginWithBiometrics(
                          reason: context.l10n.loginSubtitle,
                        );
                  },
                  child: Text(context.l10n.unlockWithFaceId),
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
                          style: TextStyle(color: context.colors.error),
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
