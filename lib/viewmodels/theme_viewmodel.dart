import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const List<Color> presetColors = [
    Colors.blue,
    Colors.green,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];

  bool _isDark = false;
  int _colorIndex = 0;

  bool get isDark => _isDark;
  Color get color => presetColors[_colorIndex];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('theme_dark') ?? false;
    _colorIndex = prefs.getInt('theme_color_index') ?? 0;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_dark', value);
    _isDark = value;
    notifyListeners();
  }

  Future<void> setColorIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_color_index', index);
    _colorIndex = index;
    notifyListeners();
  }
}
