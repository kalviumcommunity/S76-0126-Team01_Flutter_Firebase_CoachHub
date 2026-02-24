import 'package:flutter/material.dart';

class AppTheme {
  // Figma Colors
  static const Color primaryBlue = Color(
    0xFF4E65FF,
  ); // The main button/card blue
  static const Color backgroundGrey = Color(
    0xFFF5F6FA,
  ); // The slight grey background
  static const Color textDark = Color(0xFF1E2022);
  static const Color textLight = Color(0xFF7A869A);
  static const Color successGreen = Color(0xFF36B37E);

  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundGrey,
      primaryColor: primaryBlue,
      fontFamily: 'Inter', // Assuming Inter from the clean Figma look
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundGrey,
        elevation: 0,
        iconTheme: IconThemeData(color: textDark),
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
    );
  }
}
