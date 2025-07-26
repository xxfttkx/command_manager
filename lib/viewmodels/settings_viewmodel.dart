import 'package:flutter/material.dart';
import 'package:is_admin/is_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  late final SharedPreferences _prefs;

  Locale _locale = const Locale('en');
  bool _isDark = false;
  int _colorIndex = 0;
  String _shellPath = 'powershell.exe';
  String _argsTemplate = '-Command';
  bool _newCommandOnTop = false;
  bool _runCommandOnTop = false;
  bool _isAdmin = false;

  Locale get locale => _locale;
  static const List<Color> presetColors = [
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];
  bool get isDark => _isDark;
  Color get color => presetColors[_colorIndex];
  String get shellPath => _shellPath;
  String get argsTemplate => _argsTemplate;
  bool get newCommandOnTop => _newCommandOnTop;
  bool get runCommandOnTop => _runCommandOnTop;
  bool get isAdmin => _isAdmin;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final code = _prefs.getString('locale_code') ?? 'en';
    _locale = Locale(code);
    _isDark = _prefs.getBool('theme_dark') ?? false;
    _colorIndex = _prefs.getInt('theme_color_index') ?? 0;
    _shellPath = _prefs.getString('shell_path') ?? 'powershell.exe';
    _argsTemplate = _prefs.getString('args_template') ?? '-Command';
    _newCommandOnTop = _prefs.getBool('new_command_on_top') ?? false;
    _runCommandOnTop = _prefs.getBool('run_command_on_top') ?? false;
    _isAdmin = IsAdmin.isAdmin;
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString('locale_code', locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('theme_dark', value);
    _isDark = value;
    notifyListeners();
  }

  Future<void> setColorIndex(int index) async {
    await _prefs.setInt('theme_color_index', index);
    _colorIndex = index;
    notifyListeners();
  }

  Future<void> setShellPath(String value) async {
    await _prefs.setString('shell_path', value);
    _shellPath = value;
  }

  Future<void> setArgsTemplate(String value) async {
    await _prefs.setString('args_template', value);
    _argsTemplate = value;
  }

  Future<void> setNewCommandOnTop(bool value) async {
    _newCommandOnTop = value;
    await _prefs.setBool('new_command_on_top', value);
    notifyListeners();
  }

  Future<void> setRunCommandOnTop(bool value) async {
    _runCommandOnTop = value;
    await _prefs.setBool('run_command_on_top', value);
    notifyListeners();
  }

  Future<void> setIsAdmin(bool value) async {
    _isAdmin = value;
    notifyListeners();
  }
}
