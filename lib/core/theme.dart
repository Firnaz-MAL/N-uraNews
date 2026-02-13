import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF6D83F2);
  static const Color secondaryPurple = Color(0xFF8E54E9);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [primaryBlue, secondaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: primaryBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: secondaryPurple,
      ),
    );
  }
}
