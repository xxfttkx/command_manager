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
  String get addCommand => 'Add Command';

  @override
  String get editCommand => 'Edit Command';

  @override
  String get nameLabel => 'Name';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get commandsLabel => 'Commands (one per line)';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get nameAndCommandsRequired => 'Name and commands cannot be empty';

  @override
  String get searchCommand => 'Search command name or content';

  @override
  String get noMatchedCommand => 'No matched command';

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
  String get tabSettings => 'Settings';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get language => 'Language';
}
