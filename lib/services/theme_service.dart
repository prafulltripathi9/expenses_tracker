import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'selectedTheme';

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey) ?? 'system';

    switch (savedTheme) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;

      case 'dark':
        _themeMode = ThemeMode.dark;
        break;

      default:
        _themeMode = ThemeMode.system;
    }

    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();

    String themeValue;

    switch (mode) {
      case ThemeMode.light:
        themeValue = 'light';
        break;

      case ThemeMode.dark:
        themeValue = 'dark';
        break;

      case ThemeMode.system:
        themeValue = 'system';
        break;
    }

    await prefs.setString(_themeKey, themeValue);

    notifyListeners();
  }
}