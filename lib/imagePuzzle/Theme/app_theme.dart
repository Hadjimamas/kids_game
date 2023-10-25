import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Core/app_colors.dart';

class Themes {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w700,
        fontSize: 23,
      ),
    ),
    displayMedium: GoogleFonts.poppins(
      textStyle: const TextStyle(
        color: AppColors.greyColor,
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
    ),
    titleMedium: GoogleFonts.roboto(
      textStyle: const TextStyle(
        color: AppColors.blackColor,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    ),
  );
}
