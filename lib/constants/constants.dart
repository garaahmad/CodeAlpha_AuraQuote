import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuraQuoteColors {
  static const Color background = Color(0xFF131313);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceDim = Color(0xFF131313);
  static const Color primary = Color(0xFFB8C3FF);
  static const Color primaryContainer = Color(0xFF2E5BFF);
  static const Color onPrimaryContainer = Color(0xFFEFEFFF);
  static const Color secondary = Color(0xFFDFC29C);
  static const Color secondaryContainer = Color(0xFF5A4628);
  static const Color onSecondaryContainer = Color(0xFFD0B48E);
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFC4C5D9);
  static const Color outline = Color(0xFF8E90A2);
}

class AuraQuoteTypography {
  static TextStyle get headlineLg => GoogleFonts.montserrat(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  );

  static TextStyle get labelCaps => GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
  );

  static TextStyle get displayQuote => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.64,
  );

  static TextStyle get bodyMain => GoogleFonts.playfairDisplay(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.6,
  );

  static TextStyle get uiControl => GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
}
