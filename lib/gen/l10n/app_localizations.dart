import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Command Manager'**
  String get appTitle;

  /// No description provided for @addCommand.
  ///
  /// In en, this message translates to:
  /// **'Add Command'**
  String get addCommand;

  /// No description provided for @editCommand.
  ///
  /// In en, this message translates to:
  /// **'Edit Command'**
  String get editCommand;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @commandsLabel.
  ///
  /// In en, this message translates to:
  /// **'Commands (one per line)'**
  String get commandsLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @nameAndCommandsRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and commands cannot be empty'**
  String get nameAndCommandsRequired;

  /// Hint text for the search input field
  ///
  /// In en, this message translates to:
  /// **'Search by name or content'**
  String get searchCommand;

  /// Text shown when no commands match the search
  ///
  /// In en, this message translates to:
  /// **'No matched commands'**
  String get noMatchedCommand;

  /// Title of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Deletion'**
  String get deleteConfirmTitle;

  /// Content message of the delete confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this command? This action cannot be undone.'**
  String get deleteConfirmContent;

  /// Snackbar message after successful deletion
  ///
  /// In en, this message translates to:
  /// **'Command \"{commandName}\" deleted successfully.'**
  String deleteSuccessMessage(Object commandName);

  /// No description provided for @scrollToTopTooltip.
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get scrollToTopTooltip;

  /// Tooltip text for the add command FAB
  ///
  /// In en, this message translates to:
  /// **'Add Command'**
  String get addCommandTooltip;

  /// Snackbar message after successful save
  ///
  /// In en, this message translates to:
  /// **'Command \"{commandName}\" saved successfully.'**
  String saveSuccessMessage(Object commandName);

  /// Snackbar error when duplicate command name is added
  ///
  /// In en, this message translates to:
  /// **'Another command with name \"{commandName}\" already exists.'**
  String duplicateCommandMessage(Object commandName);

  /// Message shown when a command starts running
  ///
  /// In en, this message translates to:
  /// **'Starting command \"{commandName}\"'**
  String startCommand(Object commandName);

  /// Message shown when a command finishes running
  ///
  /// In en, this message translates to:
  /// **'Command \"{commandName}\" completed'**
  String endCommand(Object commandName);

  /// No description provided for @run.
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get run;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @runningCommands.
  ///
  /// In en, this message translates to:
  /// **'Running Commands'**
  String get runningCommands;

  /// No description provided for @noRunningCommands.
  ///
  /// In en, this message translates to:
  /// **'No running commands'**
  String get noRunningCommands;

  /// No description provided for @finishedCommands.
  ///
  /// In en, this message translates to:
  /// **'Finished Commands'**
  String get finishedCommands;

  /// No description provided for @noFinishedCommands.
  ///
  /// In en, this message translates to:
  /// **'No finished commands'**
  String get noFinishedCommands;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @terminateProcess.
  ///
  /// In en, this message translates to:
  /// **'Terminate Process'**
  String get terminateProcess;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @shellSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Shell Settings'**
  String get shellSettingsTitle;

  /// No description provided for @shellPathTitle.
  ///
  /// In en, this message translates to:
  /// **'Shell Path'**
  String get shellPathTitle;

  /// No description provided for @argsTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Shell Argument Template'**
  String get argsTemplateTitle;

  /// No description provided for @shellPathHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., powershell.exe or /bin/bash'**
  String get shellPathHint;

  /// No description provided for @argsTemplateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., -Command or -c'**
  String get argsTemplateHint;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettings;

  /// No description provided for @commandDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'Command Display Settings'**
  String get commandDisplaySettings;

  /// No description provided for @newCommandOnTop.
  ///
  /// In en, this message translates to:
  /// **'New commands appear on top'**
  String get newCommandOnTop;

  /// No description provided for @runCommandOnTop.
  ///
  /// In en, this message translates to:
  /// **'Move command to top after running'**
  String get runCommandOnTop;

  /// No description provided for @isAdmin.
  ///
  /// In en, this message translates to:
  /// **'Run as Administrator'**
  String get isAdmin;

  /// No description provided for @adminSwitchNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Switching administrator privileges is not supported'**
  String get adminSwitchNotSupported;

  /// No description provided for @fontSizeFactorLabel.
  ///
  /// In en, this message translates to:
  /// **'Font size factor'**
  String get fontSizeFactorLabel;

  /// No description provided for @logRealtimeOutput.
  ///
  /// In en, this message translates to:
  /// **'Live Output'**
  String get logRealtimeOutput;

  /// No description provided for @defaultLiveOutputEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enable live output by default'**
  String get defaultLiveOutputEnabled;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
