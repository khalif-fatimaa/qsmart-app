import 'package:flutter/material.dart';

class AppColors {
  static const deepNavy = Color(0xFF0C1445);
  static const royalBlue = Color(0xFF1E2A78);
  static const electricBlue = Color(0xFF3E5CE6);
  static const offWhite = Color(0xFFF2E6D0);
  static const richGold = Color(0xFFC9932C);
  static const brightGold = Color(0xFFFFD26F);
}

final ThemeData qsmartTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.deepNavy,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.electricBlue,
    brightness: Brightness.dark,
    surface: AppColors.royalBlue,
    primary: AppColors.electricBlue,
    onPrimary: AppColors.offWhite,
    onSurface: AppColors.offWhite,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.royalBlue,
    foregroundColor: AppColors.offWhite,
    centerTitle: false,
    elevation: 0,
  ),
  cardTheme: CardThemeData(
    color: AppColors.royalBlue,
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      color: AppColors.offWhite,
      fontWeight: FontWeight.w700,
    ),
    bodyMedium: TextStyle(color: AppColors.offWhite),
    labelLarge: TextStyle(color: AppColors.offWhite),
  ),
);
