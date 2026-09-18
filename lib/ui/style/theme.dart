import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

abstract class AppTheme {
  static final ValueNotifier<ThemeMode> modo = ValueNotifier(ThemeMode.light);

  static void alternarTema() {
    modo.value = modo.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  static final ThemeData temaClaro = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.fundo,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.azul),
    textTheme: GoogleFonts.robotoTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.azul,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borda),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.borda),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.azul, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.azul,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.azul,
      foregroundColor: Colors.white,
    ),
  );

  static final ThemeData temaEscuro = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.azulClaro, brightness: Brightness.dark),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF102A43),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF243B53),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.azulClaro,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.azulClaro,
      foregroundColor: Colors.white,
    ),
  );
}
