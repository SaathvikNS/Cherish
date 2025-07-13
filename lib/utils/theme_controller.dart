import 'package:cherish/utils/theme.dart';
import 'package:flutter/material.dart';

enum AppMode { western, hindu }

class ThemeController extends ChangeNotifier {
  AppMode appMode = AppMode.western;
  ThemeMode themeMode = ThemeMode.system;

  void switchThemeMode() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void switchAppMode(AppMode mode) {
    appMode = mode;
    notifyListeners();
  }

  ThemePalette getPalette(Brightness brightness) {
    final effectiveBrightness = themeMode == ThemeMode.system
        ? brightness
        : _resolveThemeModeBrightness();

    if (appMode == AppMode.hindu) {
      return effectiveBrightness == Brightness.dark
          ? AppThemeColors.hinduDark
          : AppThemeColors.hinduLight;
    } else {
      return effectiveBrightness == Brightness.dark
          ? AppThemeColors.westernDark
          : AppThemeColors.westernLight;
    }
  }

  Brightness _resolveThemeModeBrightness() {
    return themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }
}
