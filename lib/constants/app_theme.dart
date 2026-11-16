import 'package:flutter/material.dart';

class AppTheme {
  // Warm & Soft Beige / Tan Palette (Editorial Illustrated Style)
  static const Color warmBg = Color(0xFFF5EFEB);
  static const Color warmBgLight = Color(0xFFFDFBF7);
  static const Color warmSurface = Color(0xFFEBE3D7);
  static const Color warmBorder = Color(0xFFDFD5C6);
  
  // Contrasting Dark Space Cards
  static const Color cardDark = Color(0xFF171E2E);
  static const Color cardDarkElevated = Color(0xFF222B3D);
  static const Color cardLight = Colors.white;

  // Harmonious Accent Colors
  static const Color portalGreen = Color(0xFF0FB981);
  static const Color portalGreenLight = Color(0xFFD1FAE5);
  static const Color turquoise = Color(0xFF0891B2);
  static const Color turquoiseLight = Color(0xFFCFFAFE);
  static const Color dimensionPurple = Color(0xFF7C3AED);
  static const Color dimensionPurpleLight = Color(0xFFEDE9FE);
  static const Color mutedBrown = Color(0xFF7C5843);
  static const Color mutedBrownLight = Color(0xFFF4ECE6);
  static const Color mortyYellow = Color(0xFFD97706);
  static const Color mortyYellowLight = Color(0xFFFEF3C7);
  
  // Status Colors
  static const Color statusAlive = Color(0xFF059669);
  static const Color statusDead = Color(0xFFDC2626);
  static const Color statusUnknown = Color(0xFFD97706);

  // Typography Colors
  static const Color textDark = Color(0xFF1A202C);
  static const Color textDarkSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);
  static const Color textLight = Color(0xFFF8FAFC);

  // Soft Premium Shadows
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF2D2319).withValues(alpha: 0.07),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: const Color(0xFF2D2319).withValues(alpha: 0.03),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get cardDarkShadow => [
        BoxShadow(
          color: const Color(0xFF0D131F).withValues(alpha: 0.25),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: warmBg,
      primaryColor: portalGreen,
      cardColor: cardLight,
      colorScheme: const ColorScheme.light(
        primary: portalGreen,
        secondary: turquoise,
        surface: warmBgLight,
        error: statusDead,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: warmBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: textDark),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: cardDark,
        contentTextStyle: const TextStyle(
          color: textLight,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      fontFamily: 'sans-serif',
    );
  }
}
