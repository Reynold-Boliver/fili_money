import 'package:fili_money/theme/color.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    color: AppPalette.teal,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    color: AppPalette.teal,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: Colors.black54,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppPalette.teal,

  );

  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
