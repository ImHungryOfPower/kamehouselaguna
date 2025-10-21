import 'package:flutter/material.dart';

/// 🐉 Tema inspirado en Dragon Ball Z
/// Colores vibrantes y energéticos como el anime
class AppTheme {
  // Paleta Dragon Ball Z
  static const dragonOrange = Color(0xFFFF6B35); // Naranja Goku
  static const superSaiyanGold = Color(0xFFFFD700); // Dorado Super Saiyan
  static const kiBlue = Color(0xFF0EA5E9); // Azul energía
  static const kaioRed = Color(0xFFEF4444); // Rojo Kaio-ken
  static const namekGreen = Color(0xFF10B981); // Verde Namek
  static const capsulePurple = Color(0xFF8B5CF6); // Morado Capsule Corp
  
  // Colores principales del tema
  static const primary = dragonOrange;
  static const secondary = superSaiyanGold;
  static const accent = kiBlue;

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF5E6), // Fondo crema anaranjado suave
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: dragonOrange,
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: dragonOrange.withOpacity(0.3),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(dragonOrange),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
            textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w700)),
            elevation: const WidgetStatePropertyAll(4),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(dragonOrange),
            foregroundColor: const WidgetStatePropertyAll(Colors.white),
            elevation: const WidgetStatePropertyAll(4),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
        chipTheme: ChipThemeData(
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          side: BorderSide(color: dragonOrange.withOpacity(0.3)),
          backgroundColor: superSaiyanGold.withOpacity(0.1),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: dragonOrange,
          foregroundColor: Colors.white,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: dragonOrange,
        ),
      );
}
