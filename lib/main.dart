import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/router/config/router_config.dart';
import 'ui/atoms/colors/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FaceIdApp(),
    ),
  );
}

class FaceIdApp extends ConsumerWidget {
  const FaceIdApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerConfigProvider);

    return MaterialApp.router(
      title: 'Face ID Pro',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.darkTheme,
      
      // Router
      routerConfig: router,
      
      // Localizations
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'), // Defaulting to English for now, can be dynamic
    );
  }
}
