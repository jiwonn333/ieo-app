import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle headlineLarge = GoogleFonts.notoSansKr(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.notoSansKr(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  static TextStyle titleLarge = GoogleFonts.notoSansKr(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.notoSansKr(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.notoSansKr(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.notoSansKr(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle labelLarge = GoogleFonts.notoSansKr(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Colors.white,
  );

  static TextStyle labelMedium = GoogleFonts.notoSansKr(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
}