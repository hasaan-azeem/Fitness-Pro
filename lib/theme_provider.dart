import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOption { system, light, dark }

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(ThemeOption option) async {
    switch (option) {
      case ThemeOption.light:
        _themeMode = ThemeMode.light;
        break;
      case ThemeOption.dark:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeOption.system:
        _themeMode = ThemeMode.system;
        break;
    }

    // Save the selected theme option in shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', option.index);
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    int themeIndex = prefs.getInt('themeMode') ?? ThemeOption.system.index;
    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }
}
