import 'package:flutter/material.dart';

class AppTheme {
  static const Color bgDeep = Color(0xFF0A0E1A);
  static const Color bgCard = Color(0xFF111827);
  static const Color bgSurface = Color(0xFF1C2333);
  static const Color cyan = Color(0xFF00BCD4);
  static const Color cyanDim = Color(0xFF0097A7);
  static const Color blue = Color(0xFF1E40AF);
  static const Color blueAccent = Color(0xFF3B82F6);
  static const Color textPrimary = Color(0xFFC8CFE8);
  static const Color textSecondary = Color(0xFF78819C);
  static const Color textMuted = Color(0xFF333E65);
  static const Color danger = Color(0xFFEF4444);
  static const Color success = Color(0xFF22C55E);
  static const Color divider = Color(0xFF1E293B);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bgDeep,
    colorScheme: const ColorScheme.dark(
      primary: cyan,
      secondary: blueAccent,
      surface: bgCard,
      error: danger,
    ),
    fontFamily: 'Exo2',
    appBarTheme: const AppBarTheme(
      backgroundColor: bgDeep,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cyan,
        foregroundColor: bgDeep,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cyanDim, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: textMuted, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cyan, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: danger, width: 1),
      ),
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textMuted),
      prefixIconColor: cyanDim,
    ),
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: divider, width: 1),
      ),
    ),
    dividerTheme: const DividerThemeData(color: divider, thickness: 1),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: bgSurface,
      contentTextStyle: TextStyle(color: textPrimary),
    ),
  );
}

class AppConstants {
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  static const String uploadsUrl = 'http://10.0.2.2:3000/uploads';
}