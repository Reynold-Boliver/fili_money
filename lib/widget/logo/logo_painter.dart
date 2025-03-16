import 'package:fili_money/theme/color.dart';
import 'package:fili_money/widget/logo/icons/left_arrow.dart';
import 'package:fili_money/widget/logo/logo_painter/facebook_painter.dart';
import 'package:fili_money/widget/logo/logo_painter/google_painter.dart';
import 'package:flutter/material.dart';

const Color color = AppPalette.teal;

class LogoPainter extends StatelessWidget {
  final Widget appLogos;

  const LogoPainter({required this.appLogos, super.key});

  factory LogoPainter.facebook({Key? key, double size = 24}) {
    return LogoPainter(
        appLogos: FacebookLogo(
          size: size,
          color: color,
        ),
        key: key);
  }

  factory LogoPainter.google({Key? key, double size = 24}) {
    return LogoPainter(
        appLogos: GoogleLogo(size: size, color: color), key: key);
  }

  // factory LogoPainter.dashboard({Key? key, double size = 24}) {
  //   return LogoPainter(
  //       appLogos: DashBoard(size: size, color: color), key: key);
  // }


  @override
  Widget build(BuildContext context) {
    return appLogos;
  }
}

class AppIcons extends StatelessWidget {
  final Widget icon;

  const AppIcons({required this.icon, super.key});

  factory AppIcons.leftArrow({Key? key, double size = 24}) {
    return AppIcons(
        icon: LeftArrow(
          size: size,
          color: color,
        ),
        key: key);
  }

  @override
  Widget build(BuildContext context) {
    return icon;
  }
}
