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
  String get searchCommand => 'Search by name or content';

  @override
  String get noMatchedCommand => 'No matched commands';

  @override
  String get deleteConfirmTitle => 'Confirm Deletion';

  @override
  String get deleteConfirmContent =>
      'Are you sure you want to delete this command? This action cannot be undone.';

  @override
  String deleteSuccessMessage(Object commandName) {
    return 'Command \"$commandName\" deleted successfully.';
  }

  @override
  String get addCommandTooltip => 'Add Command';

  @override
  String saveSuccessMessage(Object commandName) {
    return 'Command \"$commandName\" saved successfully.';
  }

  @override
  String duplicateCommandMessage(Object commandName) {
    return 'Another command with name \"$commandName\" already exists.';
  }

  @override
  String startCommand(Object commandName) {
    return 'Starting command \"$commandName\"';
  }

  @override
  String endCommand(Object commandName) {
    return 'Command \"$commandName\" completed';
  }

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
  String get finishedCommands => 'Finished Commands';

  @override
  String get noFinishedCommands => 'No finished commands';

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
