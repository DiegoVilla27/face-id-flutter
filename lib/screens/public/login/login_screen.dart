import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../services/auth_service.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
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
            ),
            const SizedBox(height: 48),
            // Placeholder for Face ID button
            ElevatedButton(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).login();
              },
              child: Text(context.l10n.unlockWithFaceId),
            ),
          ],
        ),
      ),
    );
  }
}
