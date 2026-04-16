import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';

extension AppContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  
  // Design System Shortcut (Theme)
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get typography => theme.textTheme;
}
