import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../services/auth_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBiometricsEnabled = ref.watch(isBiometricsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
        actions: [
          IconButton(
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
            icon: const Icon(Icons.logout),
            tooltip: context.l10n.logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.homeWelcome,
              style: context.typography.headlineSmall,
            ),
            const SizedBox(height: 32),
            
            // Security Settings Card
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Biometric Authentication'),
                    subtitle: const Text('Use Face ID or Fingerprint for faster access'),
                    value: isBiometricsEnabled,
                    onChanged: (value) {
                      ref.read(authNotifierProvider.notifier).toggleBiometrics(value);
                    },
                    secondary: const Icon(Icons.fingerprint),
                  ),
                ],
              ),
            ),
            
            const Spacer(),
            
            // App Information
            Center(
              child: Column(
                children: [
                  const Icon(Icons.security, size: 48, color: Colors.blueGrey),
                  const SizedBox(height: 8),
                  Text(
                    'Vault Protected',
                    style: TextStyle(color: context.colors.outline),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
