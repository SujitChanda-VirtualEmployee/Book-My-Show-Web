import 'package:book_my_show_clone_web/utils/color_palette.dart';
import 'package:flutter/material.dart';

class CustomStyleClass {
  static  TextStyle onboardingHeadingStyle = const TextStyle(
      color: ColorPalette.primary,
      letterSpacing: 1,
      fontWeight: FontWeight.bold,
      fontSize: 10 * 4);

  static  TextStyle onboardingBodyTextStyle =
      const TextStyle(color: ColorPalette.dark, fontSize: 10 * 2.3);

  static  TextStyle onboardingSkipButtonStyle = const TextStyle(
      color: ColorPalette.secondary,
      fontSize: 10 * 2.3,
      fontWeight: FontWeight.bold);
}
