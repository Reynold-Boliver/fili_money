import 'package:flutter/material.dart';

class FiliMoneyPainter extends StatelessWidget {
  final double size;

  const FiliMoneyPainter({
    super.key,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: RPSCustomPainter(),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.08632986, size.height * 0.1247812);
    path_0.lineTo(size.width * 0.03611111, size.height * 0.1247812);
    path_0.cubicTo(
        size.width * 0.03457639,
        size.height * 0.1247812,
        size.width * 0.03333333,
        size.height * 0.1359687,
        size.width * 0.03333333,
        size.height * 0.1497813);
    path_0.lineTo(size.width * 0.03333333, size.height * 0.8497812);
    path_0.cubicTo(
        size.width * 0.03333333,
        size.height * 0.8635937,
        size.width * 0.03457639,
        size.height * 0.8747812,
        size.width * 0.03611111,
        size.height * 0.8748125);
    path_0.lineTo(size.width * 0.03933333, size.height * 0.8748125);
    path_0.cubicTo(
        size.width * 0.04086806,
        size.height * 0.8747812,
        size.width * 0.04211111,
        size.height * 0.8635937,
        size.width * 0.04211111,
        size.height * 0.8497812);
    path_0.lineTo(size.width * 0.04211111, size.height * 0.8497812);
    path_0.lineTo(size.width * 0.04211111, size.height * 0.5698125);
    path_0.lineTo(size.width * 0.08222222, size.height * 0.5698125);
    path_0.cubicTo(
        size.width * 0.08375694,
        size.height * 0.5697812,
        size.width * 0.08500000,
        size.height * 0.5585938,
        size.width * 0.08500347,
        size.height * 0.5447812);
    path_0.lineTo(size.width * 0.08500347, size.height * 0.5157500);
    path_0.cubicTo(
        size.width * 0.08500000,
        size.height * 0.5019375,
        size.width * 0.08375694,
        size.height * 0.4907500,
        size.width * 0.08222222,
        size.height * 0.4907500);
    path_0.lineTo(size.width * 0.04211111, size.height * 0.4907500);
    path_0.lineTo(size.width * 0.04211111, size.height * 0.2037500);
    path_0.lineTo(size.width * 0.08632986, size.height * 0.2037500);
    path_0.cubicTo(
        size.width * 0.08786458,
        size.height * 0.2037500,
        size.width * 0.08910764,
        size.height * 0.1925625,
        size.width * 0.08911111,
        size.height * 0.1787500);
    path_0.lineTo(size.width * 0.08911111, size.height * 0.1497188);
    path_0.cubicTo(
        size.width * 0.08910764,
        size.height * 0.1359063,
        size.width * 0.08786458,
        size.height * 0.1247188,
        size.width * 0.08632986,
        size.height * 0.1247188);
    path_0.lineTo(size.width * 0.08632986, size.height * 0.1247188);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.05400347, size.height * 0.1247812);
    path_1.lineTo(size.width * 0.05722569, size.height * 0.1247812);
    path_1.cubicTo(
        size.width * 0.05876042,
        size.height * 0.1247812,
        size.width * 0.06000347,
        size.height * 0.1359687,
        size.width * 0.06000347,
        size.height * 0.1497813);
    path_1.lineTo(size.width * 0.06000347, size.height * 0.1497813);
    path_1.lineTo(size.width * 0.06000347, size.height * 0.8497812);
    path_1.cubicTo(
        size.width * 0.06000347,
        size.height * 0.8635937,
        size.width * 0.05875694,
        size.height * 0.8748125,
        size.width * 0.05722222,
        size.height * 0.8748125);
    path_1.lineTo(size.width * 0.05722222, size.height * 0.8748125);
    path_1.lineTo(size.width * 0.05400347, size.height * 0.8748125);
    path_1.cubicTo(
        size.width * 0.05246875,
        size.height * 0.8748125,
        size.width * 0.05122569,
        size.height * 0.8636250,
        size.width * 0.05122569,
        size.height * 0.8498125);
    path_1.lineTo(size.width * 0.05122569, size.height * 0.8498125);
    path_1.lineTo(size.width * 0.05122569, size.height * 0.1497812);
    path_1.cubicTo(
        size.width * 0.05122569,
        size.height * 0.1359687,
        size.width * 0.05246875,
        size.height * 0.1247812,
        size.width * 0.05400347,
        size.height * 0.1247812);
    path_1.lineTo(size.width * 0.05400347, size.height * 0.1247812);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.08761111, size.height * 0.7957812);
    path_2.lineTo(size.width * 0.04383333, size.height * 0.7957812);
    path_2.lineTo(size.width * 0.04383333, size.height * 0.1497812);
    path_2.cubicTo(
        size.width * 0.04383333,
        size.height * 0.1359687,
        size.width * 0.04259028,
        size.height * 0.1247812,
        size.width * 0.04105556,
        size.height * 0.1247812);
    path_2.lineTo(size.width * 0.03783333, size.height * 0.1247812);
    path_2.cubicTo(
        size.width * 0.03629861,
        size.height * 0.1247812,
        size.width * 0.03505556,
        size.height * 0.1359687,
        size.width * 0.03505556,
        size.height * 0.1497812);
    path_2.lineTo(size.width * 0.03505556, size.height * 0.8497812);
    path_2.cubicTo(
        size.width * 0.03505556,
        size.height * 0.8635937,
        size.width * 0.03629861,
        size.height * 0.8747812,
        size.width * 0.03783333,
        size.height * 0.8748125);
    path_2.lineTo(size.width * 0.08761111, size.height * 0.8748125);
    path_2.cubicTo(
        size.width * 0.08914583,
        size.height * 0.8747812,
        size.width * 0.09038889,
        size.height * 0.8635937,
        size.width * 0.09039236,
        size.height * 0.8497812);
    path_2.lineTo(size.width * 0.09039236, size.height * 0.8207812);
    path_2.cubicTo(
        size.width * 0.09038889,
        size.height * 0.8069687,
        size.width * 0.08914583,
        size.height * 0.7957812,
        size.width * 0.08761111,
        size.height * 0.7957500);
    path_2.lineTo(size.width * 0.08761111, size.height * 0.7957500);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.05400347, size.height * 0.1247812);
    path_3.lineTo(size.width * 0.05722569, size.height * 0.1247812);
    path_3.cubicTo(
        size.width * 0.05876042,
        size.height * 0.1247812,
        size.width * 0.06000347,
        size.height * 0.1359687,
        size.width * 0.06000347,
        size.height * 0.1497813);
    path_3.lineTo(size.width * 0.06000347, size.height * 0.1497813);
    path_3.lineTo(size.width * 0.06000347, size.height * 0.8497812);
    path_3.cubicTo(
        size.width * 0.06000347,
        size.height * 0.8635937,
        size.width * 0.05875694,
        size.height * 0.8748125,
        size.width * 0.05722222,
        size.height * 0.8748125);
    path_3.lineTo(size.width * 0.05722222, size.height * 0.8748125);
    path_3.lineTo(size.width * 0.05400347, size.height * 0.8748125);
    path_3.cubicTo(
        size.width * 0.05246875,
        size.height * 0.8748125,
        size.width * 0.05122569,
        size.height * 0.8636250,
        size.width * 0.05122569,
        size.height * 0.8498125);
    path_3.lineTo(size.width * 0.05122569, size.height * 0.8498125);
    path_3.lineTo(size.width * 0.05122569, size.height * 0.1497812);
    path_3.cubicTo(
        size.width * 0.05122569,
        size.height * 0.1359687,
        size.width * 0.05246875,
        size.height * 0.1247812,
        size.width * 0.05400347,
        size.height * 0.1247812);
    path_3.lineTo(size.width * 0.05400347, size.height * 0.1247812);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_3, paint3Fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.09455556, size.height * 0.1247812);
    path_4.lineTo(size.width * 0.09178125, size.height * 0.1247812);
    path_4.cubicTo(
        size.width * 0.09178125,
        size.height * 0.1247812,
        size.width * 0.09178125,
        size.height * 0.1247812,
        size.width * 0.09177778,
        size.height * 0.1247812);
    path_4.cubicTo(
        size.width * 0.09077778,
        size.height * 0.1247812,
        size.width * 0.08989931,
        size.height * 0.1295625,
        size.width * 0.08941319,
        size.height * 0.1366875);
    path_4.lineTo(size.width * 0.08940625, size.height * 0.1367812);
    path_4.lineTo(size.width * 0.05555208, size.height * 0.6385937);
    path_4.lineTo(size.width * 0.02170486, size.height * 0.1367812);
    path_4.cubicTo(
        size.width * 0.02121181,
        size.height * 0.1295312,
        size.width * 0.02033333,
        size.height * 0.1247500,
        size.width * 0.01933333,
        size.height * 0.1247500);
    path_4.cubicTo(
        size.width * 0.01933333,
        size.height * 0.1247500,
        size.width * 0.01933333,
        size.height * 0.1247500,
        size.width * 0.01932986,
        size.height * 0.1247500);
    path_4.lineTo(size.width * 0.01655556, size.height * 0.1247500);
    path_4.cubicTo(
        size.width * 0.01502083,
        size.height * 0.1247500,
        size.width * 0.01377778,
        size.height * 0.1359375,
        size.width * 0.01377778,
        size.height * 0.1497500);
    path_4.lineTo(size.width * 0.01377778, size.height * 0.8497500);
    path_4.cubicTo(
        size.width * 0.01377778,
        size.height * 0.8635625,
        size.width * 0.01502083,
        size.height * 0.8747500,
        size.width * 0.01655556,
        size.height * 0.8747812);
    path_4.lineTo(size.width * 0.01977778, size.height * 0.8747812);
    path_4.cubicTo(
        size.width * 0.02131250,
        size.height * 0.8747500,
        size.width * 0.02255556,
        size.height * 0.8635625,
        size.width * 0.02255556,
        size.height * 0.8497500);
    path_4.lineTo(size.width * 0.02255556, size.height * 0.8497500);
    path_4.lineTo(size.width * 0.02255556, size.height * 0.3001562);
    path_4.lineTo(size.width * 0.05185069, size.height * 0.7346875);
    path_4.cubicTo(
        size.width * 0.05234375,
        size.height * 0.7419687,
        size.width * 0.05322222,
        size.height * 0.7467812,
        size.width * 0.05422569,
        size.height * 0.7467812);
    path_4.lineTo(size.width * 0.05678125, size.height * 0.7467812);
    path_4.cubicTo(
        size.width * 0.05778125,
        size.height * 0.7467812,
        size.width * 0.05865972,
        size.height * 0.7420000,
        size.width * 0.05914931,
        size.height * 0.7348750);
    path_4.lineTo(size.width * 0.05915625, size.height * 0.7347812);
    path_4.lineTo(size.width * 0.08855556, size.height * 0.2999375);
    path_4.lineTo(size.width * 0.08855556, size.height * 0.8497812);
    path_4.cubicTo(
        size.width * 0.08855903,
        size.height * 0.8635937,
        size.width * 0.08980208,
        size.height * 0.8747812,
        size.width * 0.09133681,
        size.height * 0.8748125);
    path_4.lineTo(size.width * 0.09455903, size.height * 0.8748125);
    path_4.cubicTo(
        size.width * 0.09609375,
        size.height * 0.8747812,
        size.width * 0.09733681,
        size.height * 0.8635937,
        size.width * 0.09734028,
        size.height * 0.8497812);
    path_4.lineTo(size.width * 0.09734028, size.height * 0.1497812);
    path_4.cubicTo(
        size.width * 0.09733681,
        size.height * 0.1359687,
        size.width * 0.09609375,
        size.height * 0.1247812,
        size.width * 0.09455903,
        size.height * 0.1247812);
    path_4.lineTo(size.width * 0.09455903, size.height * 0.1247812);
    path_4.close();

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_4, paint4Fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.1872222, size.height * 0.3150312);
    path_5.cubicTo(
        size.width * 0.2292604,
        size.height * 0.6933125,
        size.width * 0.2292604,
        size.height * 1.306656,
        size.width * 0.1872222,
        size.height * 1.684969);
    path_5.cubicTo(
        size.width * 0.1451875,
        size.height * 2.063344,
        size.width * 0.07703472,
        size.height * 2.063344,
        size.width * 0.03500347,
        size.height * 1.684969);
    path_5.cubicTo(
        size.width * -0.007034722,
        size.height * 1.306687,
        size.width * -0.007034722,
        size.height * 0.6933437,
        size.width * 0.03500347,
        size.height * 0.3150312);
    path_5.cubicTo(
        size.width * 0.07703472,
        size.height * -0.06334375,
        size.width * 0.1451840,
        size.height * -0.06334375,
        size.width * 0.1872222,
        size.height * 0.3150312);
    path_5.close();

    Paint paint5Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01388889;
    paint5Stroke.color = Color(0xffF5DE55);
    canvas.drawPath(path_5, paint5Stroke);

    Paint paint6Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01388889;
    paint6Stroke.color = Color(0xffF5DE55);
    canvas.drawLine(Offset(size.width * 0.08333333, size.height * 1.500000),
        Offset(size.width * 0.08333333, size.height * 0.5000000), paint6Stroke);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.08333333, size.height * 0.5312500);
    path_7.lineTo(size.width * 0.1076389, size.height * 0.5312500);
    path_7.cubicTo(
        size.width * 0.1076389,
        size.height * 0.5312500,
        size.width * 0.1458333,
        size.height * 0.5000000,
        size.width * 0.1458333,
        size.height * 0.8125000);
    path_7.cubicTo(
        size.width * 0.1458333,
        size.height * 1.125000,
        size.width * 0.1076389,
        size.height * 1.093750,
        size.width * 0.1076389,
        size.height * 1.093750);
    path_7.lineTo(size.width * 0.08333333, size.height * 1.093750);

    Paint paint7Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01388889;
    paint7Stroke.color = Color(0xffF5DE55);
    canvas.drawPath(path_7, paint7Stroke);

    Paint paint8Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01388889;
    paint8Stroke.color = Color(0xffF5DE55);
    canvas.drawLine(Offset(size.width * 0.06597222, size.height * 0.7500000),
        Offset(size.width * 0.1631944, size.height * 0.7500000), paint8Stroke);

    Paint paint9Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.01388889;
    paint9Stroke.color = Color(0xffF5DE55);
    canvas.drawLine(Offset(size.width * 0.06597222, size.height * 0.8750000),
        Offset(size.width * 0.1631944, size.height * 0.8750000), paint9Stroke);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.08810764, size.height * 0.1247812);
    path_10.lineTo(size.width * 0.08488542, size.height * 0.1247812);
    path_10.cubicTo(
        size.width * 0.08335069,
        size.height * 0.1247812,
        size.width * 0.08210764,
        size.height * 0.1359687,
        size.width * 0.08210417,
        size.height * 0.1497813);
    path_10.lineTo(size.width * 0.08210417, size.height * 0.7329062);
    path_10.lineTo(size.width * 0.02849653, size.height * 0.1340938);
    path_10.cubicTo(
        size.width * 0.02798264,
        size.height * 0.1284062,
        size.width * 0.02720486,
        size.height * 0.1247813,
        size.width * 0.02633333,
        size.height * 0.1247813);
    path_10.lineTo(size.width * 0.02311111, size.height * 0.1247813);
    path_10.cubicTo(
        size.width * 0.02157639,
        size.height * 0.1247813,
        size.width * 0.02033333,
        size.height * 0.1359687,
        size.width * 0.02033333,
        size.height * 0.1497813);
    path_10.lineTo(size.width * 0.02033333, size.height * 0.8497812);
    path_10.cubicTo(
        size.width * 0.02033333,
        size.height * 0.8635937,
        size.width * 0.02157639,
        size.height * 0.8747812,
        size.width * 0.02311111,
        size.height * 0.8748125);
    path_10.lineTo(size.width * 0.02633333, size.height * 0.8748125);
    path_10.cubicTo(
        size.width * 0.02786806,
        size.height * 0.8747812,
        size.width * 0.02911111,
        size.height * 0.8635937,
        size.width * 0.02911111,
        size.height * 0.8497812);
    path_10.lineTo(size.width * 0.02911111, size.height * 0.8497812);
    path_10.lineTo(size.width * 0.02911111, size.height * 0.2666562);
    path_10.lineTo(size.width * 0.08272222, size.height * 0.8654687);
    path_10.cubicTo(
        size.width * 0.08323611,
        size.height * 0.8711562,
        size.width * 0.08401389,
        size.height * 0.8747812,
        size.width * 0.08488542,
        size.height * 0.8748125);
    path_10.lineTo(size.width * 0.08810764, size.height * 0.8748125);
    path_10.cubicTo(
        size.width * 0.08964236,
        size.height * 0.8747812,
        size.width * 0.09088542,
        size.height * 0.8635937,
        size.width * 0.09088889,
        size.height * 0.8497812);
    path_10.lineTo(size.width * 0.09088889, size.height * 0.1497812);
    path_10.cubicTo(
        size.width * 0.09088542,
        size.height * 0.1359687,
        size.width * 0.08964236,
        size.height * 0.1247812,
        size.width * 0.08810764,
        size.height * 0.1247812);
    path_10.lineTo(size.width * 0.08810764, size.height * 0.1247812);
    path_10.close();

    Paint paint10Fill = Paint()..style = PaintingStyle.fill;
    paint10Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_10, paint10Fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.08566667, size.height * 0.2037812);
    path_11.cubicTo(
        size.width * 0.08720139,
        size.height * 0.2037812,
        size.width * 0.08844444,
        size.height * 0.1925938,
        size.width * 0.08844792,
        size.height * 0.1787813);
    path_11.lineTo(size.width * 0.08844792, size.height * 0.1497500);
    path_11.cubicTo(
        size.width * 0.08844444,
        size.height * 0.1359375,
        size.width * 0.08720139,
        size.height * 0.1247500,
        size.width * 0.08566667,
        size.height * 0.1247500);
    path_11.lineTo(size.width * 0.03322222, size.height * 0.1247500);
    path_11.cubicTo(
        size.width * 0.03168750,
        size.height * 0.1247500,
        size.width * 0.03044444,
        size.height * 0.1359375,
        size.width * 0.03044444,
        size.height * 0.1497500);
    path_11.lineTo(size.width * 0.03044444, size.height * 0.8497500);
    path_11.cubicTo(
        size.width * 0.03044444,
        size.height * 0.8635625,
        size.width * 0.03168750,
        size.height * 0.8747500,
        size.width * 0.03322222,
        size.height * 0.8747812);
    path_11.lineTo(size.width * 0.08566667, size.height * 0.8747812);
    path_11.cubicTo(
        size.width * 0.08720139,
        size.height * 0.8747500,
        size.width * 0.08844444,
        size.height * 0.8635625,
        size.width * 0.08844792,
        size.height * 0.8497500);
    path_11.lineTo(size.width * 0.08844792, size.height * 0.8207500);
    path_11.cubicTo(
        size.width * 0.08844444,
        size.height * 0.8069375,
        size.width * 0.08720139,
        size.height * 0.7957500,
        size.width * 0.08566667,
        size.height * 0.7957188);
    path_11.lineTo(size.width * 0.03922222, size.height * 0.7957188);
    path_11.lineTo(size.width * 0.03922222, size.height * 0.5387188);
    path_11.lineTo(size.width * 0.07710764, size.height * 0.5387188);
    path_11.cubicTo(
        size.width * 0.07864236,
        size.height * 0.5387188,
        size.width * 0.07988542,
        size.height * 0.5275313,
        size.width * 0.07988889,
        size.height * 0.5137188);
    path_11.lineTo(size.width * 0.07988889, size.height * 0.4847187);
    path_11.cubicTo(
        size.width * 0.07988542,
        size.height * 0.4709062,
        size.width * 0.07864236,
        size.height * 0.4597187,
        size.width * 0.07710764,
        size.height * 0.4597187);
    path_11.lineTo(size.width * 0.03922222, size.height * 0.4597187);
    path_11.lineTo(size.width * 0.03922222, size.height * 0.2037187);
    path_11.close();

    Paint paint11Fill = Paint()..style = PaintingStyle.fill;
    paint11Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_11, paint11Fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.09613889, size.height * 0.1382812);
    path_12.cubicTo(
        size.width * 0.09566319,
        size.height * 0.1302187,
        size.width * 0.09473611,
        size.height * 0.1247812,
        size.width * 0.09367014,
        size.height * 0.1247812);
    path_12.lineTo(size.width * 0.08977778, size.height * 0.1247812);
    path_12.cubicTo(
        size.width * 0.08977778,
        size.height * 0.1247812,
        size.width * 0.08977431,
        size.height * 0.1247812,
        size.width * 0.08977431,
        size.height * 0.1247812);
    path_12.cubicTo(
        size.width * 0.08884375,
        size.height * 0.1247812,
        size.width * 0.08802083,
        size.height * 0.1289063,
        size.width * 0.08751736,
        size.height * 0.1352500);
    path_12.lineTo(size.width * 0.08751042, size.height * 0.1353125);
    path_12.lineTo(size.width * 0.05778125, size.height * 0.5134375);
    path_12.lineTo(size.width * 0.02816319, size.height * 0.1353437);
    path_12.cubicTo(
        size.width * 0.02765278,
        size.height * 0.1289062,
        size.width * 0.02682639,
        size.height * 0.1247500,
        size.width * 0.02589236,
        size.height * 0.1247500);
    path_12.cubicTo(
        size.width * 0.02589236,
        size.height * 0.1247500,
        size.width * 0.02589236,
        size.height * 0.1247500,
        size.width * 0.02589236,
        size.height * 0.1247500);
    path_12.lineTo(size.width * 0.02189236, size.height * 0.1247500);
    path_12.cubicTo(
        size.width * 0.02189236,
        size.height * 0.1247500,
        size.width * 0.02189236,
        size.height * 0.1247500,
        size.width * 0.02189236,
        size.height * 0.1247500);
    path_12.cubicTo(
        size.width * 0.02035764,
        size.height * 0.1247500,
        size.width * 0.01911458,
        size.height * 0.1359375,
        size.width * 0.01911458,
        size.height * 0.1497500);
    path_12.cubicTo(
        size.width * 0.01911458,
        size.height * 0.1551875,
        size.width * 0.01930556,
        size.height * 0.1601875,
        size.width * 0.01963194,
        size.height * 0.1643125);
    path_12.lineTo(size.width * 0.01962500, size.height * 0.1642500);
    path_12.lineTo(size.width * 0.05344097, size.height * 0.5936875);
    path_12.lineTo(size.width * 0.05344097, size.height * 0.8497813);
    path_12.cubicTo(
        size.width * 0.05344097,
        size.height * 0.8635938,
        size.width * 0.05468403,
        size.height * 0.8747813,
        size.width * 0.05621875,
        size.height * 0.8748125);
    path_12.lineTo(size.width * 0.05944792, size.height * 0.8748125);
    path_12.cubicTo(
        size.width * 0.06098264,
        size.height * 0.8747812,
        size.width * 0.06222569,
        size.height * 0.8635937,
        size.width * 0.06222569,
        size.height * 0.8497813);
    path_12.lineTo(size.width * 0.06222569, size.height * 0.8497813);
    path_12.lineTo(size.width * 0.06222569, size.height * 0.5936875);
    path_12.lineTo(size.width * 0.09594097, size.height * 0.1642188);
    path_12.cubicTo(
        size.width * 0.09625694,
        size.height * 0.1601875,
        size.width * 0.09644792,
        size.height * 0.1551875,
        size.width * 0.09644792,
        size.height * 0.1497813);
    path_12.cubicTo(
        size.width * 0.09644792,
        size.height * 0.1455938,
        size.width * 0.09633333,
        size.height * 0.1416250,
        size.width * 0.09613194,
        size.height * 0.1381250);
    path_12.lineTo(size.width * 0.09613889, size.height * 0.1382500);
    path_12.close();

    Paint paint12Fill = Paint()..style = PaintingStyle.fill;
    paint12Fill.color = Color(0xff68A58A);
    canvas.drawPath(path_12, paint12Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
