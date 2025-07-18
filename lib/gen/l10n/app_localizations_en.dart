// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Command Manager';

  @override
  String get tabCommand => 'Command Manager';

  @override
  String get run => 'Run';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get runningCommands => 'Running Commands';

  @override
  String get noRunningCommands => 'No running commands';

  @override
  String get startTime => 'Start Time';

  @override
  String get terminateProcess => 'Terminate Process';

  @override
  String get tabRunning => 'Running';

  @override
  String get tabSettings => 'Settings';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get language => 'Language';
}
