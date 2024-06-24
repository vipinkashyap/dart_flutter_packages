import 'package:flutter/material.dart';

class AppConstants {
  ThemeData kThemeData = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light().copyWith(
        surfaceTint: Colors.white,
        primary: const Color(0xFF47a239),
        secondary: Colors.black,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF47a239),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF47a239)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF47a239),
            disabledForegroundColor: Colors.black.withOpacity(0.38),
            disabledBackgroundColor: Colors.black.withOpacity(0.12)),
      ),
      primarySwatch: Colors.green,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.black));
}
