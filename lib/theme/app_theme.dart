import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const background = Color(0xFF080B12);
  static const surface = Color(0xFF101725);
  static const elevated = Color(0xFF172235);
  static const accent = Color(0xFF2589FF);
  static const cyan = Color(0xFF36D6E8);
  static const primaryText = Color(0xFFF2F6FC);
  static const secondaryText = Color(0xFF93A4BA);

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.dark, surface: surface);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(backgroundColor: background, foregroundColor: primaryText, elevation: 0),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: Color(0xFF202D40))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: elevated,
        hintStyle: const TextStyle(color: secondaryText),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      ),
    );
  }
}
