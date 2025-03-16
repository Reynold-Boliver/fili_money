import 'package:flutter/material.dart';

class LeftArrow extends StatelessWidget {
  final double size;
  final Color color;

  const LeftArrow({super.key, this.size = 24, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: RPSCustomPainter(color: color),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  final Color color;

  RPSCustomPainter({super.repaint, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4166667, size.height * -0.08333333);
    path_0.lineTo(0, size.height * -0.5000000);
    path_0.lineTo(size.width * 0.4166667, size.height * -0.9166667);
    path_0.lineTo(size.width * 0.4906250, size.height * -0.8427083);
    path_0.lineTo(size.width * 0.1479167, size.height * -0.5000000);
    path_0.lineTo(size.width * 0.4906250, size.height * -0.1572917);
    path_0.lineTo(size.width * 0.4166667, size.height * -0.08333333);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
