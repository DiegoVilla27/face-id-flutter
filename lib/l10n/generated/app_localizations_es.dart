// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Face ID Pro';

  @override
  String get loginTitle => 'Bienvenido';

  @override
  String get loginSubtitle => 'Autentícate para continuar';

  @override
  String get unlockWithFaceId => 'Desbloquear con Face ID';

  @override
  String get unlockWithFingerprint => 'Desbloquear con Huella';

  @override
  String get unlockWithPin => 'Desbloquear con PIN';

  @override
  String get unlockDevice => 'Desbloquear Dispositivo';

  @override
  String get homeTitle => 'Inicio Seguro';

  @override
  String get homeWelcome => 'Entorno seguro detectado';

  @override
  String get logout => 'Cerrar sesión';
}
