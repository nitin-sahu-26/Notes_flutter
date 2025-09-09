import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;

  ThemeProvider() {
    loadTheme();
  }

  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? false;
    notifyListeners();
  }

  void toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDark', _isDark);
    notifyListeners();
  }
}
