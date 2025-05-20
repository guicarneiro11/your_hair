import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF4A6D58); // Verde oliva/sage
  static const secondary = Color(0xFFF5E3DC); // Rosa claro/pêssego
  static const accent = Color(0xFF9EBBB3); // Verde mint suave

  static const background = Color(0xFFF9F9F7); // Off-white
  static const cardBackground = Colors.white;
  static const textDark = Color(0xFF303030); // Quase preto
  static const textMedium = Color(0xFF606060); // Cinza escuro
  static const textLight = Color(0xFF909090); // Cinza claro

  static const hydration = Color(0xFF7FC8DE); // Azul - Hidratação
  static const nutrition = Color(0xFF9DC88D); // Verde - Nutrição
  static const reconstruction = Color(0xFFEFBE8F); // Laranja claro - Reconstrução
  static const detox = Color(0xFFC5ABDB); // Lavanda - Detox
  static const haircut = Color(0xFFE98EA0); // Rosa - Corte
  static const special = Color(0xFFF8D888); // Amarelo - Tratamentos especiais
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        background: AppColors.background,
        surface: AppColors.cardBackground,
        onPrimary: Colors.white,
        onSecondary: AppColors.textDark,
        onBackground: AppColors.textDark,
        onSurface: AppColors.textDark,
      ),
      useMaterial3: true,
      textTheme: GoogleFonts.nunitoSansTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          displaySmall: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppColors.textMedium,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppColors.textMedium,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          elevation: 2,
          shadowColor: AppColors.primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        hintStyle: const TextStyle(color: AppColors.textLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    return lightTheme; // Por enquanto, usaremos apenas o tema claro
  }
}