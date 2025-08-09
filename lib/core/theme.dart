import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontSizes {
  static final small = 12.0;
  static final standard = 14.0;
  static final standardUp = 16.0;
  static final medium = 20.0;
  static final large = 28.0;
}

class DefaultColors {
  static final Color greyText = Color(0xFFB3B9C9);
  static final Color whiteText = Color(0xFFFFFFFF);
  static final Color senderMessage = Color(0xFF7A8194);
  static final Color recieverMessage = Color(0xFF373E4E);
  static final Color sentMessageInput = Color(0xFF3D4354);
  static final Color messageListPage = Color(0xFF292F3F);
  static final Color buttonColor = Color(0xFF7A8194);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Color(0xFF18202D),
      textTheme: TextTheme(
        titleMedium: GoogleFonts.alegreyaSans(
          fontSize: FontSizes.medium,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.alegreyaSans(
          fontSize: FontSizes.large,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.alegreyaSans(
          fontSize: FontSizes.small,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.alegreyaSans(
          fontSize: FontSizes.standard,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.alegreyaSans(
          fontSize: FontSizes.standardUp,
          color: Colors.white,
        ),
      ),
    );
  }
}
