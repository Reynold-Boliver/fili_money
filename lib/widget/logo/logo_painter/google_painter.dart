import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  final double size;
  final Color color;

  const GoogleLogo({super.key, this.size = 24.0, this.color = Colors.grey});

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
    path_0.moveTo(0, 0);
    path_0.cubicTo(
        size.width * 0.3300000, 0, size.width * 0.6600000, 0, size.width, 0);
    path_0.cubicTo(size.width, size.height * 0.3300000, size.width,
        size.height * 0.6600000, size.width, size.height);
    path_0.cubicTo(size.width * 0.6700000, size.height, size.width * 0.3400000,
        size.height, 0, size.height);
    path_0.cubicTo(
        0, size.height * 0.6700000, 0, size.height * 0.3400000, 0, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.transparent;
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(0, 0);
    path_1.cubicTo(
        size.width * 0.001493307,
        size.height * 5.810043e-7,
        size.width * 0.002986615,
        size.height * 0.000001162009,
        size.width * 0.004525174,
        size.height * 0.000001760620);
    path_1.cubicTo(
        size.width * 0.02687171,
        size.height * 0.00004173774,
        size.width * 0.04845924,
        size.height * 0.0009195949,
        size.width * 0.07050562,
        size.height * 0.004674145);
    path_1.cubicTo(
        size.width * 0.07300553,
        size.height * 0.005015692,
        size.width * 0.07550544,
        size.height * 0.005357238,
        size.width * 0.07808111,
        size.height * 0.005709135);
    path_1.cubicTo(
        size.width * 0.1359585,
        size.height * 0.01478927,
        size.width * 0.1931992,
        size.height * 0.03940700,
        size.width * 0.2412921,
        size.height * 0.07091346);
    path_1.cubicTo(
        size.width * 0.2453154,
        size.height * 0.07345509,
        size.width * 0.2493412,
        size.height * 0.07599304,
        size.width * 0.2533708,
        size.height * 0.07852564);
    path_1.cubicTo(
        size.width * 0.2560880,
        size.height * 0.08025907,
        size.width * 0.2588043,
        size.height * 0.08199398,
        size.width * 0.2615169,
        size.height * 0.08373397);
    path_1.cubicTo(
        size.width * 0.2576834,
        size.height * 0.09223209,
        size.width * 0.2516905,
        size.height * 0.09902901,
        size.width * 0.2456461,
        size.height * 0.1061699);
    path_1.cubicTo(
        size.width * 0.2377189,
        size.height * 0.1156384,
        size.width * 0.2299094,
        size.height * 0.1251564,
        size.width * 0.2223315,
        size.height * 0.1348825);
    path_1.cubicTo(
        size.width * 0.2135387,
        size.height * 0.1461147,
        size.width * 0.2043960,
        size.height * 0.1570419,
        size.width * 0.1951380,
        size.height * 0.1679275);
    path_1.cubicTo(
        size.width * 0.1860532,
        size.height * 0.1786485,
        size.width * 0.1774508,
        size.height * 0.1896446,
        size.width * 0.1690221,
        size.height * 0.2008380);
    path_1.cubicTo(
        size.width * 0.1648876,
        size.height * 0.2055288,
        size.width * 0.1648876,
        size.height * 0.2055288,
        size.width * 0.1581461,
        size.height * 0.2076656);
    path_1.cubicTo(
        size.width * 0.1519663,
        size.height * 0.2045857,
        size.width * 0.1519663,
        size.height * 0.2045857,
        size.width * 0.1446629,
        size.height * 0.2000534);
    path_1.cubicTo(
        size.width * 0.1420114,
        size.height * 0.1984528,
        size.width * 0.1393575,
        size.height * 0.1968558,
        size.width * 0.1367012,
        size.height * 0.1952624);
    path_1.cubicTo(
        size.width * 0.1353821,
        size.height * 0.1944643,
        size.width * 0.1340630,
        size.height * 0.1936662,
        size.width * 0.1327039,
        size.height * 0.1928440);
    path_1.cubicTo(
        size.width * 0.1143033,
        size.height * 0.1817567,
        size.width * 0.09627983,
        size.height * 0.1748742,
        size.width * 0.07547402,
        size.height * 0.1691623);
    path_1.cubicTo(
        size.width * 0.06825843,
        size.height * 0.1670673,
        size.width * 0.06825843,
        size.height * 0.1670673,
        size.width * 0.06601124,
        size.height * 0.1649306);
    path_1.cubicTo(
        size.width * -0.003164905,
        size.height * 0.1502374,
        size.width * -0.07516866,
        size.height * 0.1571922,
        size.width * -0.1362360,
        size.height * 0.1927083);
    path_1.cubicTo(
        size.width * -0.1549078,
        size.height * 0.2040925,
        size.width * -0.1718642,
        size.height * 0.2165599,
        size.width * -0.1879213,
        size.height * 0.2311699);
    path_1.cubicTo(
        size.width * -0.1894624,
        size.height * 0.2325003,
        size.width * -0.1910035,
        size.height * 0.2338306,
        size.width * -0.1925913,
        size.height * 0.2352013);
    path_1.cubicTo(
        size.width * -0.2060994,
        size.height * 0.2472617,
        size.width * -0.2160766,
        size.height * 0.2613650,
        size.width * -0.2261236,
        size.height * 0.2760417);
    path_1.cubicTo(
        size.width * -0.2273779,
        size.height * 0.2778513,
        size.width * -0.2286322,
        size.height * 0.2796610,
        size.width * -0.2299245,
        size.height * 0.2815254);
    path_1.cubicTo(
        size.width * -0.2459290,
        size.height * 0.3056437,
        size.width * -0.2554485,
        size.height * 0.3317505,
        size.width * -0.2620787,
        size.height * 0.3593750);
    path_1.cubicTo(
        size.width * -0.2626739,
        size.height * 0.3617424,
        size.width * -0.2626739,
        size.height * 0.3617424,
        size.width * -0.2632813,
        size.height * 0.3641577);
    path_1.cubicTo(
        size.width * -0.2747242,
        size.height * 0.4129247,
        size.width * -0.2669402,
        size.height * 0.4684032,
        size.width * -0.2441011,
        size.height * 0.5132212);
    path_1.cubicTo(
        size.width * -0.2430728,
        size.height * 0.5153696,
        size.width * -0.2420444,
        size.height * 0.5175180,
        size.width * -0.2409849,
        size.height * 0.5197316);
    path_1.cubicTo(
        size.width * -0.2279348,
        size.height * 0.5455179,
        size.width * -0.2109431,
        size.height * 0.5673641,
        size.width * -0.1901685,
        size.height * 0.5880075);
    path_1.cubicTo(
        size.width * -0.1887694,
        size.height * 0.5894728,
        size.width * -0.1873703,
        size.height * 0.5909382,
        size.width * -0.1859287,
        size.height * 0.5924479);
    path_1.cubicTo(
        size.width * -0.1732450,
        size.height * 0.6052921,
        size.width * -0.1584128,
        size.height * 0.6147791,
        size.width * -0.1429775,
        size.height * 0.6243323);
    path_1.cubicTo(
        size.width * -0.1410744,
        size.height * 0.6255249,
        size.width * -0.1391712,
        size.height * 0.6267176,
        size.width * -0.1372103,
        size.height * 0.6279464);
    path_1.cubicTo(
        size.width * -0.1118456,
        size.height * 0.6431643,
        size.width * -0.08438937,
        size.height * 0.6522160,
        size.width * -0.05533708,
        size.height * 0.6585203);
    path_1.cubicTo(
        size.width * -0.05282286,
        size.height * 0.6590910,
        size.width * -0.05282286,
        size.height * 0.6590910,
        size.width * -0.05025786,
        size.height * 0.6596732);
    path_1.cubicTo(
        size.width * -0.03550427,
        size.height * 0.6628009,
        size.width * -0.02127254,
        size.height * 0.6636164,
        size.width * -0.006179775,
        size.height * 0.6635951);
    path_1.cubicTo(
        size.width * -0.003741963,
        size.height * 0.6635932,
        size.width * -0.001304150,
        size.height * 0.6635913,
        size.width * 0.001207536,
        size.height * 0.6635893);
    path_1.cubicTo(
        size.width * 0.02430024,
        size.height * 0.6632726,
        size.width * 0.04595854,
        size.height * 0.6597451,
        size.width * 0.06825843,
        size.height * 0.6542468);
    path_1.cubicTo(
        size.width * 0.07058743,
        size.height * 0.6536877,
        size.width * 0.07291643,
        size.height * 0.6531285,
        size.width * 0.07531601,
        size.height * 0.6525524);
    path_1.cubicTo(
        size.width * 0.08775233,
        size.height * 0.6492697,
        size.width * 0.09933177,
        size.height * 0.6445823,
        size.width * 0.1109551,
        size.height * 0.6392895);
    path_1.cubicTo(
        size.width * 0.1130639,
        size.height * 0.6383668,
        size.width * 0.1151728,
        size.height * 0.6374441,
        size.width * 0.1173455,
        size.height * 0.6364934);
    path_1.cubicTo(
        size.width * 0.1432547,
        size.height * 0.6247786,
        size.width * 0.1643295,
        size.height * 0.6087803,
        size.width * 0.1851124,
        size.height * 0.5901442);
    path_1.cubicTo(
        size.width * 0.1866332,
        size.height * 0.5888359,
        size.width * 0.1881540,
        size.height * 0.5875275,
        size.width * 0.1897209,
        size.height * 0.5861796);
    path_1.cubicTo(
        size.width * 0.2187899,
        size.height * 0.5602009,
        size.width * 0.2389432,
        size.height * 0.5256518,
        size.width * 0.2502809,
        size.height * 0.4897169);
    path_1.cubicTo(
        size.width * 0.1672247,
        size.height * 0.4897169,
        size.width * 0.08416854,
        size.height * 0.4897169,
        size.width * -0.001404494,
        size.height * 0.4897169);
    path_1.cubicTo(
        size.width * -0.001404494,
        size.height * 0.4375374,
        size.width * -0.001404494,
        size.height * 0.3853579,
        size.width * -0.001404494,
        size.height * 0.3315972);
    path_1.cubicTo(
        size.width * 0.1409775,
        size.height * 0.3315972,
        size.width * 0.2833596,
        size.height * 0.3315972,
        size.width * 0.4300562,
        size.height * 0.3315972);
    path_1.cubicTo(
        size.width * 0.4300562,
        size.height * 0.4834644,
        size.width * 0.4108169,
        size.height * 0.5967509,
        size.width * 0.2994382,
        size.height * 0.7063301);
    path_1.cubicTo(
        size.width * 0.2513873,
        size.height * 0.7504966,
        size.width * 0.1919927,
        size.height * 0.7827422,
        size.width * 0.1287581,
        size.height * 0.8024600);
    path_1.cubicTo(
        size.width * 0.1248636,
        size.height * 0.8036856,
        size.width * 0.1209930,
        size.height * 0.8049796,
        size.width * 0.1171261,
        size.height * 0.8062817);
    path_1.cubicTo(
        size.width * 0.07917914,
        size.height * 0.8184934,
        size.width * 0.03715311,
        size.height * 0.8213424,
        size.width * -0.002668539,
        size.height * 0.8213141);
    path_1.cubicTo(
        size.width * -0.006478425,
        size.height * 0.8213115,
        size.width * -0.006478425,
        size.height * 0.8213115,
        size.width * -0.01036528,
        size.height * 0.8213089);
    path_1.cubicTo(
        size.width * -0.03716909,
        size.height * 0.8211245,
        size.width * -0.06325515,
        size.height * 0.8196853,
        size.width * -0.08904494,
        size.height * 0.8123665);
    path_1.cubicTo(
        size.width * -0.09231275,
        size.height * 0.8117418,
        size.width * -0.09558990,
        size.height * 0.8111589,
        size.width * -0.09887640,
        size.height * 0.8106303);
    path_1.cubicTo(
        size.width * -0.2063772,
        size.height * 0.7904335,
        size.width * -0.2993409,
        size.height * 0.7239465,
        size.width * -0.3604437,
        size.height * 0.6389317);
    path_1.cubicTo(
        size.width * -0.3834076,
        size.height * 0.6063351,
        size.width * -0.4006114,
        size.height * 0.5716716,
        size.width * -0.4134579,
        size.height * 0.5344228);
    path_1.cubicTo(
        size.width * -0.4147469,
        size.height * 0.5307196,
        size.width * -0.4161077,
        size.height * 0.5270393,
        size.width * -0.4174772,
        size.height * 0.5233624);
    path_1.cubicTo(
        size.width * -0.4303200,
        size.height * 0.4872804,
        size.width * -0.4333163,
        size.height * 0.4473197,
        size.width * -0.4332865,
        size.height * 0.4094551);
    path_1.cubicTo(
        size.width * -0.4332847,
        size.height * 0.4070400,
        size.width * -0.4332829,
        size.height * 0.4046249,
        size.width * -0.4332810,
        size.height * 0.4021366);
    path_1.cubicTo(
        size.width * -0.4330871,
        size.height * 0.3766501,
        size.width * -0.4315735,
        size.height * 0.3518461,
        size.width * -0.4238764,
        size.height * 0.3273237);
    path_1.cubicTo(
        size.width * -0.4232195,
        size.height * 0.3242165,
        size.width * -0.4226065,
        size.height * 0.3211004,
        size.width * -0.4220506,
        size.height * 0.3179754);
    path_1.cubicTo(
        size.width * -0.4001341,
        size.height * 0.2125060,
        size.width * -0.3270374,
        size.height * 0.1241122,
        size.width * -0.2351124,
        size.height * 0.06450321);
    path_1.cubicTo(
        size.width * -0.2338153,
        size.height * 0.06365485,
        size.width * -0.2325183,
        size.height * 0.06280649,
        size.width * -0.2311820,
        size.height * 0.06193243);
    path_1.cubicTo(
        size.width * -0.1988094,
        size.height * 0.04101986,
        size.width * -0.1618348,
        size.height * 0.02752907,
        size.width * -0.1246363,
        size.height * 0.01659426);
    path_1.cubicTo(
        size.width * -0.1208748,
        size.height * 0.01546840,
        size.width * -0.1171458,
        size.height * 0.01424551,
        size.width * -0.1134217,
        size.height * 0.01301249);
    path_1.cubicTo(
        size.width * -0.1070091,
        size.height * 0.01108038,
        size.width * -0.1008860,
        size.height * 0.009912995,
        size.width * -0.09424157,
        size.height * 0.008947650);
    path_1.cubicTo(
        size.width * -0.08344398,
        size.height * 0.007335905,
        size.width * -0.07271674,
        size.height * 0.005527490,
        size.width * -0.06199087,
        size.height * 0.003530649);
    path_1.cubicTo(size.width * -0.04134390, size.height * 0.0004485380,
        size.width * -0.02087901, size.height * -0.00001370282, 0, 0);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = color;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
