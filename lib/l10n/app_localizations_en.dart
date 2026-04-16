// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Face ID Pro';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Authenticate to continue';

  @override
  String get unlockWithFaceId => 'Unlock with Face ID';

  @override
  String get homeTitle => 'Secure Home';

  @override
  String get homeWelcome => 'Safe surroundings detected';

  @override
  String get logout => 'Logout';
}
