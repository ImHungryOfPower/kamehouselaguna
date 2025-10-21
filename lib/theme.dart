import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF0EA5E9); // azul cielo
  static const secondary = Color(0xFFF97316); // naranja
  static const neutral = Color(0xFF0F172A); // gris-azul oscuro

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        appBarTheme: const AppBarTheme(centerTitle: true),
        // 👇 Aquí estaba el problema: usar CardThemeData en lugar de CardTheme
        cardTheme: CardThemeData(
          elevation: 1,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 14, vertical: 10)),
            textStyle: const WidgetStatePropertyAll(TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
        chipTheme: const ChipThemeData(
          labelStyle: TextStyle(fontWeight: FontWeight.w600),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          side: BorderSide(color: Color(0xFFE2E8F0)),
        ),
      );
}
