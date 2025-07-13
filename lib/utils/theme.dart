import 'package:flutter/material.dart';

class ThemePalette {
  final Color backgroundColor;
  final Color text;
  final Color accentColor;
  final Color secondaryText;
  final Color secondaryBackground;
  final Color divider;

  const ThemePalette({
    required this.backgroundColor,
    required this.text,
    required this.accentColor,
    required this.secondaryText,
    required this.secondaryBackground,
    required this.divider,
  });
}

class AppThemeColors {
  static const hinduLight = ThemePalette(
    backgroundColor: Color(0xFFE6DFD8),
    text: Color(0xff4e3b27),
    accentColor: Color(0xff846b52),
    secondaryText: Color(0xffa9a198),
    secondaryBackground: Color(0xffccc5c0),
    divider: Color(0x33846b52),
  );

  static const hinduDark = ThemePalette(
    backgroundColor: Color(0xff4d3a26),
    text: Color(0xffede6de),
    accentColor: Color(0xffbfad9c),
    secondaryText: Color(0xff8e7d6b),
    secondaryBackground: Color(0xff664d32),
    divider: Color(0x33bfad9c),
  );

  static const westernLight = ThemePalette(
    backgroundColor: Color(0xffd5dfe6),
    text: Color(0xff27374D),
    accentColor: Color(0xff526D82),
    secondaryText: Color(0xff99A2A9),
    secondaryBackground: Color(0xffbec6cc),
    divider: Color(0x33526D82),
  );

  static const westernDark = ThemePalette(
    backgroundColor: Color(0xff27374D),
    text: Color(0xffDDE6ED),
    accentColor: Color(0xff9DB2BF),
    secondaryText: Color(0xff6B7B8F),
    secondaryBackground: Color(0xff344966),
    divider: Color(0x339DB2BF),
  );
}
