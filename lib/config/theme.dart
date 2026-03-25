import 'package:flutter/material.dart';

class SportixColors {
  static const Color bgPrimary = Color(0xFF0A0E1A);
  static const Color bgSecondary = Color(0xFF111827);
  static const Color bgTertiary = Color(0xFF181C2A);
  static const Color accentPrimary = Color(0xFFFF2D55);
  static const Color accentSecondary = Color(0xFFFF6B35);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% white
  static const Color textTertiary = Color(0x8CFFFFFF); // 55% white
  static const Color success = Color(0xFF00E676);
  static const Color warning = Color(0xFFFFAB40);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF40C4FF);
  static const Color cardBg = Color(0x1AFFFFFF); // 10% white
  static const Color borderSubtle = Color(0x1AFFFFFF);

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentPrimary, accentSecondary],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00C853), Color(0xFF00897B)],
  );
}

class SportixTheme {
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: SportixColors.bgPrimary,
    fontFamily: 'Poppins',
    colorScheme: const ColorScheme.dark(
      primary: SportixColors.accentPrimary,
      secondary: SportixColors.accentSecondary,
      surface: SportixColors.bgSecondary,
      error: SportixColors.error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: SportixColors.textPrimary,
      ),
      iconTheme: IconThemeData(color: SportixColors.textPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SportixColors.accentPrimary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: SportixColors.cardBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SportixColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SportixColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: SportixColors.accentPrimary),
      ),
      hintStyle: const TextStyle(color: SportixColors.textTertiary, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardTheme(
      color: SportixColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: SportixColors.borderSubtle),
      ),
      elevation: 0,
    ),
  );
}

class SportixGlass {
  static BoxDecoration get card => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.10),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
  );

  static BoxDecoration get cardSubtle => BoxDecoration(
    color: Colors.white.withValues(alpha: 0.06),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
  );
}
