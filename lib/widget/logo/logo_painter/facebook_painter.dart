import 'package:flutter/material.dart';

class FacebookLogo extends StatelessWidget {
  final double size;
  final Color color;

  const FacebookLogo({super.key, this.size = 0, this.color = Colors.grey});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: RPSCustomPainter(color: color),
    );
  }
}

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  final Color color;

  RPSCustomPainter({required this.color});
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
        size.width * 0.004206358,
        size.height * -0.00002273732,
        size.width * 0.008412715,
        size.height * -0.00004547462,
        size.width * 0.01274654,
        size.height * -0.00006890096);
    path_1.cubicTo(
        size.width * 0.02159520,
        size.height * -0.0001076976,
        size.width * 0.03044393,
        size.height * -0.0001379857,
        size.width * 0.03929269,
        size.height * -0.0001602388);
    path_1.cubicTo(
        size.width * 0.04835400,
        size.height * -0.0001928837,
        size.width * 0.05741521,
        size.height * -0.0002507958,
        size.width * 0.06647600,
        size.height * -0.0003335442);
    path_1.cubicTo(
        size.width * 0.07958579,
        size.height * -0.0004531720,
        size.width * 0.09269302,
        size.height * -0.0004992058,
        size.width * 0.1058036,
        size.height * -0.0005281690);
    path_1.cubicTo(
        size.width * 0.1118863,
        size.height * -0.0006021468,
        size.width * 0.1118863,
        size.height * -0.0006021468,
        size.width * 0.1180919,
        size.height * -0.0006776192);
    path_1.cubicTo(
        size.width * 0.1237437,
        size.height * -0.0006652576,
        size.width * 0.1237437,
        size.height * -0.0006652576,
        size.width * 0.1295096,
        size.height * -0.0006526463);
    path_1.cubicTo(
        size.width * 0.1344719,
        size.height * -0.0006774333,
        size.width * 0.1344719,
        size.height * -0.0006774333,
        size.width * 0.1395344,
        size.height * -0.0007027210);
    path_1.cubicTo(
        size.width * 0.1513592,
        size.height * 0.001133609,
        size.width * 0.1555142,
        size.height * 0.004382641,
        size.width * 0.1626674,
        size.height * 0.01193882);
    path_1.cubicTo(
        size.width * 0.1645055,
        size.height * 0.01854605,
        size.width * 0.1645055,
        size.height * 0.01854605,
        size.width * 0.1645726,
        size.height * 0.02592361);
    path_1.cubicTo(
        size.width * 0.1646574,
        size.height * 0.03008388,
        size.width * 0.1646574,
        size.height * 0.03008388,
        size.width * 0.1647440,
        size.height * 0.03432819);
    path_1.cubicTo(
        size.width * 0.1647263,
        size.height * 0.03730667,
        size.width * 0.1647085,
        size.height * 0.04028514,
        size.width * 0.1646903,
        size.height * 0.04335387);
    path_1.cubicTo(
        size.width * 0.1647124,
        size.height * 0.04643073,
        size.width * 0.1647346,
        size.height * 0.04950759,
        size.width * 0.1647574,
        size.height * 0.05267768);
    path_1.cubicTo(
        size.width * 0.1647827,
        size.height * 0.05918198,
        size.width * 0.1647714,
        size.height * 0.06568643,
        size.width * 0.1647260,
        size.height * 0.07219066);
    path_1.cubicTo(
        size.width * 0.1646766,
        size.height * 0.08213986,
        size.width * 0.1647981,
        size.height * 0.09208158,
        size.width * 0.1649344,
        size.height * 0.1020301);
    path_1.cubicTo(
        size.width * 0.1649378,
        size.height * 0.1083517,
        size.width * 0.1649312,
        size.height * 0.1146732,
        size.width * 0.1649135,
        size.height * 0.1209947);
    path_1.cubicTo(
        size.width * 0.1649609,
        size.height * 0.1239675,
        size.width * 0.1650082,
        size.height * 0.1269403,
        size.width * 0.1650570,
        size.height * 0.1300031);
    path_1.cubicTo(
        size.width * 0.1648491,
        size.height * 0.1429285,
        size.width * 0.1644052,
        size.height * 0.1506007,
        size.width * 0.1555647,
        size.height * 0.1617071);
    path_1.cubicTo(
        size.width * 0.1410444,
        size.height * 0.1686758,
        size.width * 0.1300464,
        size.height * 0.1687803,
        size.width * 0.1133510,
        size.height * 0.1685629);
    path_1.cubicTo(
        size.width * 0.1103355,
        size.height * 0.1685855,
        size.width * 0.1073200,
        size.height * 0.1686080,
        size.width * 0.1042131,
        size.height * 0.1686313);
    path_1.cubicTo(
        size.width * 0.09460386,
        size.height * 0.1686961,
        size.width * 0.08500002,
        size.height * 0.1686697,
        size.width * 0.07539063,
        size.height * 0.1686290);
    path_1.cubicTo(
        size.width * 0.06579500,
        size.height * 0.1686181,
        size.width * 0.05620175,
        size.height * 0.1686280,
        size.width * 0.04660639,
        size.height * 0.1686870);
    path_1.cubicTo(
        size.width * 0.04064794,
        size.height * 0.1687209,
        size.width * 0.03468882,
        size.height * 0.1687138,
        size.width * 0.02873061,
        size.height * 0.1686597);
    path_1.cubicTo(
        size.width * 0.006760120,
        size.height * 0.1687425,
        size.width * -0.007441785,
        size.height * 0.1721874,
        size.width * -0.02425014,
        size.height * 0.1840029);
    path_1.cubicTo(
        size.width * -0.03277163,
        size.height * 0.1957926,
        size.width * -0.03234276,
        size.height * 0.2061137,
        size.width * -0.03236607,
        size.height * 0.2194762);
    path_1.cubicTo(
        size.width * -0.03242513,
        size.height * 0.2220823,
        size.width * -0.03248419,
        size.height * 0.2246884,
        size.width * -0.03254504,
        size.height * 0.2273735);
    path_1.cubicTo(
        size.width * -0.03271805,
        size.height * 0.2356677,
        size.width * -0.03279448,
        size.height * 0.2439606,
        size.width * -0.03286830,
        size.height * 0.2522557);
    path_1.cubicTo(
        size.width * -0.03296888,
        size.height * 0.2578914,
        size.width * -0.03307577,
        size.height * 0.2635271,
        size.width * -0.03318917,
        size.height * 0.2691626);
    path_1.cubicTo(
        size.width * -0.03345290,
        size.height * 0.2829518,
        size.width * -0.03363003,
        size.height * 0.2967401,
        size.width * -0.03376116,
        size.height * 0.3105304);
    path_1.cubicTo(
        size.width * -0.03154780,
        size.height * 0.3105053,
        size.width * -0.02933443,
        size.height * 0.3104803,
        size.width * -0.02705400,
        size.height * 0.3104545);
    path_1.cubicTo(
        size.width * -0.004054922,
        size.height * 0.3102056,
        size.width * 0.01894354,
        size.height * 0.3100355,
        size.width * 0.04194423,
        size.height * 0.3099114);
    path_1.cubicTo(
        size.width * 0.05053242,
        size.height * 0.3098547,
        size.width * 0.05912044,
        size.height * 0.3097778,
        size.width * 0.06770804,
        size.height * 0.3096803);
    path_1.cubicTo(
        size.width * 0.08003962,
        size.height * 0.3095440,
        size.width * 0.09236889,
        size.height * 0.3094798,
        size.width * 0.1047015,
        size.height * 0.3094300);
    path_1.cubicTo(
        size.width * 0.1085522,
        size.height * 0.3093719,
        size.width * 0.1124029,
        size.height * 0.3093137,
        size.width * 0.1163703,
        size.height * 0.3092538);
    path_1.cubicTo(
        size.width * 0.1217318,
        size.height * 0.3092525,
        size.width * 0.1217318,
        size.height * 0.3092525,
        size.width * 0.1272016,
        size.height * 0.3092512);
    path_1.cubicTo(
        size.width * 0.1303501,
        size.height * 0.3092262,
        size.width * 0.1334986,
        size.height * 0.3092012,
        size.width * 0.1367426,
        size.height * 0.3091754);
    path_1.cubicTo(
        size.width * 0.1448103,
        size.height * 0.3105304,
        size.width * 0.1448103,
        size.height * 0.3105304,
        size.width * 0.1511813,
        size.height * 0.3152837);
    path_1.cubicTo(
        size.width * 0.1564206,
        size.height * 0.3231419,
        size.width * 0.1568830,
        size.height * 0.3283037,
        size.width * 0.1569109,
        size.height * 0.3371651);
    path_1.cubicTo(
        size.width * 0.1569447,
        size.height * 0.3402388,
        size.width * 0.1569785,
        size.height * 0.3433124,
        size.width * 0.1570133,
        size.height * 0.3464793);
    path_1.cubicTo(
        size.width * 0.1569807,
        size.height * 0.3514356,
        size.width * 0.1569807,
        size.height * 0.3514356,
        size.width * 0.1569475,
        size.height * 0.3564921);
    path_1.cubicTo(
        size.width * 0.1569629,
        size.height * 0.3615963,
        size.width * 0.1569629,
        size.height * 0.3615963,
        size.width * 0.1569786,
        size.height * 0.3668037);
    path_1.cubicTo(
        size.width * 0.1569859,
        size.height * 0.3739948,
        size.width * 0.1569661,
        size.height * 0.3811859,
        size.width * 0.1569214,
        size.height * 0.3883768);
    path_1.cubicTo(
        size.width * 0.1568640,
        size.height * 0.3994063,
        size.width * 0.1569209,
        size.height * 0.4104330,
        size.width * 0.1569894,
        size.height * 0.4214624);
    path_1.cubicTo(
        size.width * 0.1569823,
        size.height * 0.4284441,
        size.width * 0.1569686,
        size.height * 0.4354258,
        size.width * 0.1569475,
        size.height * 0.4424076);
    path_1.cubicTo(
        size.width * 0.1569692,
        size.height * 0.4457175,
        size.width * 0.1569909,
        size.height * 0.4490274,
        size.width * 0.1570133,
        size.height * 0.4524377);
    path_1.cubicTo(
        size.width * 0.1569626,
        size.height * 0.4570349,
        size.width * 0.1569626,
        size.height * 0.4570349,
        size.width * 0.1569109,
        size.height * 0.4617249);
    path_1.cubicTo(
        size.width * 0.1569024,
        size.height * 0.4644245,
        size.width * 0.1568939,
        size.height * 0.4671241,
        size.width * 0.1568851,
        size.height * 0.4699054);
    path_1.cubicTo(
        size.width * 0.1552371,
        size.height * 0.4781689,
        size.width * 0.1531283,
        size.height * 0.4801413,
        size.width * 0.1448103,
        size.height * 0.4851783);
    path_1.cubicTo(
        size.width * 0.1367426,
        size.height * 0.4861945,
        size.width * 0.1367426,
        size.height * 0.4861945,
        size.width * 0.1272016,
        size.height * 0.4861376);
    path_1.cubicTo(
        size.width * 0.1218401,
        size.height * 0.4861367,
        size.width * 0.1218401,
        size.height * 0.4861367,
        size.width * 0.1163703,
        size.height * 0.4861357);
    path_1.cubicTo(
        size.width * 0.1125196,
        size.height * 0.4860921,
        size.width * 0.1086689,
        size.height * 0.4860485,
        size.width * 0.1047015,
        size.height * 0.4860035);
    path_1.cubicTo(
        size.width * 0.1007530,
        size.height * 0.4859916,
        size.width * 0.09680461,
        size.height * 0.4859796,
        size.width * 0.09273654,
        size.height * 0.4859673);
    path_1.cubicTo(
        size.width * 0.08010845,
        size.height * 0.4859199,
        size.width * 0.06748239,
        size.height * 0.4858139,
        size.width * 0.05485491,
        size.height * 0.4857064);
    path_1.cubicTo(
        size.width * 0.04630072,
        size.height * 0.4856640,
        size.width * 0.03774649,
        size.height * 0.4856255,
        size.width * 0.02919224,
        size.height * 0.4855909);
    path_1.cubicTo(
        size.width * 0.008207083,
        size.height * 0.4854976,
        size.width * -0.01277689,
        size.height * 0.4853562,
        size.width * -0.03376116,
        size.height * 0.4851783);
    path_1.cubicTo(
        size.width * -0.03375128,
        size.height * 0.4870552,
        size.width * -0.03374141,
        size.height * 0.4889320,
        size.width * -0.03373123,
        size.height * 0.4908658);
    path_1.cubicTo(
        size.width * -0.03349468,
        size.height * 0.5365215,
        size.width * -0.03331735,
        size.height * 0.5821770,
        size.width * -0.03320603,
        size.height * 0.6278330);
    path_1.cubicTo(
        size.width * -0.03315077,
        size.height * 0.6499118,
        size.width * -0.03307542,
        size.height * 0.6719904,
        size.width * -0.03295288,
        size.height * 0.6940691);
    path_1.cubicTo(
        size.width * -0.03284613,
        size.height * 0.7133115,
        size.width * -0.03277698,
        size.height * 0.7325536,
        size.width * -0.03275307,
        size.height * 0.7517962);
    path_1.cubicTo(
        size.width * -0.03273909,
        size.height * 0.7619863,
        size.width * -0.03270622,
        size.height * 0.7721759,
        size.width * -0.03262834,
        size.height * 0.7823659);
    path_1.cubicTo(
        size.width * -0.03254213,
        size.height * 0.7937377,
        size.width * -0.03253984,
        size.height * 0.8051085,
        size.width * -0.03254482,
        size.height * 0.8164805);
    path_1.cubicTo(
        size.width * -0.03250630,
        size.height * 0.8198642,
        size.width * -0.03246778,
        size.height * 0.8232479,
        size.width * -0.03242809,
        size.height * 0.8267342);
    path_1.cubicTo(
        size.width * -0.03244282,
        size.height * 0.8298309,
        size.width * -0.03245754,
        size.height * 0.8329276,
        size.width * -0.03247272,
        size.height * 0.8361182);
    path_1.cubicTo(
        size.width * -0.03246284,
        size.height * 0.8388083,
        size.width * -0.03245297,
        size.height * 0.8414984,
        size.width * -0.03244279,
        size.height * 0.8442699);
    path_1.cubicTo(
        size.width * -0.03401243,
        size.height * 0.8527297,
        size.width * -0.03698973,
        size.height * 0.8565295,
        size.width * -0.04447545,
        size.height * 0.8626430);
    path_1.cubicTo(
        size.width * -0.05520113,
        size.height * 0.8654629,
        size.width * -0.06260689,
        size.height * 0.8658819,
        size.width * -0.07382638,
        size.height * 0.8660032);
    path_1.cubicTo(
        size.width * -0.07953043,
        size.height * 0.8660711,
        size.width * -0.07953043,
        size.height * 0.8660711,
        size.width * -0.08534971,
        size.height * 0.8661404);
    path_1.cubicTo(
        size.width * -0.1027046,
        size.height * 0.8662656,
        size.width * -0.1200591,
        size.height * 0.8663812,
        size.width * -0.1374146,
        size.height * 0.8664461);
    path_1.cubicTo(
        size.width * -0.1465736,
        size.height * 0.8664928,
        size.width * -0.1557326,
        size.height * 0.8665698,
        size.width * -0.1648908,
        size.height * 0.8666772);
    path_1.cubicTo(
        size.width * -0.1780922,
        size.height * 0.8668313,
        size.width * -0.1912896,
        size.height * 0.8668931,
        size.width * -0.2044922,
        size.height * 0.8669344);
    path_1.cubicTo(
        size.width * -0.2106313,
        size.height * 0.8670302,
        size.width * -0.2106313,
        size.height * 0.8670302,
        size.width * -0.2168944,
        size.height * 0.8671279);
    path_1.cubicTo(
        size.width * -0.2226322,
        size.height * 0.8671159,
        size.width * -0.2226322,
        size.height * 0.8671159,
        size.width * -0.2284860,
        size.height * 0.8671036);
    path_1.cubicTo(
        size.width * -0.2318401,
        size.height * 0.8671264,
        size.width * -0.2351942,
        size.height * 0.8671492,
        size.width * -0.2386500,
        size.height * 0.8671726);
    path_1.cubicTo(
        size.width * -0.2530864,
        size.height * 0.8645414,
        size.width * -0.2575514,
        size.height * 0.8611054,
        size.width * -0.2659040,
        size.height * 0.8513754);
    path_1.cubicTo(
        size.width * -0.2684827,
        size.height * 0.8397226,
        size.width * -0.2681576,
        size.height * 0.8282202,
        size.width * -0.2679313,
        size.height * 0.8164193);
    path_1.cubicTo(
        size.width * -0.2679339,
        size.height * 0.8128730,
        size.width * -0.2679365,
        size.height * 0.8093267,
        size.width * -0.2679392,
        size.height * 0.8056729);
    path_1.cubicTo(
        size.width * -0.2679443,
        size.height * 0.7959710,
        size.width * -0.2678394,
        size.height * 0.7862716,
        size.width * -0.2677146,
        size.height * 0.7765703);
    path_1.cubicTo(
        size.width * -0.2676029,
        size.height * 0.7664236,
        size.width * -0.2675925,
        size.height * 0.7562768,
        size.width * -0.2675713,
        size.height * 0.7461297);
    path_1.cubicTo(
        size.width * -0.2675158,
        size.height * 0.7269252,
        size.width * -0.2673694,
        size.height * 0.7077218,
        size.width * -0.2671901,
        size.height * 0.6885178);
    path_1.cubicTo(
        size.width * -0.2669904,
        size.height * 0.6666505,
        size.width * -0.2668923,
        size.height * 0.6447831,
        size.width * -0.2668027,
        size.height * 0.6229153);
    path_1.cubicTo(
        size.width * -0.2666161,
        size.height * 0.5779413,
        size.width * -0.2663021,
        size.height * 0.5329684,
        size.width * -0.2659040,
        size.height * 0.4879952);
    path_1.cubicTo(
        size.width * -0.2727981,
        size.height * 0.4880615,
        size.width * -0.2727981,
        size.height * 0.4880615,
        size.width * -0.2798314,
        size.height * 0.4881293);
    path_1.cubicTo(
        size.width * -0.2968634,
        size.height * 0.4882821,
        size.width * -0.3138954,
        size.height * 0.4883792,
        size.width * -0.3309283,
        size.height * 0.4884594);
    path_1.cubicTo(
        size.width * -0.3383038,
        size.height * 0.4885019,
        size.width * -0.3456792,
        size.height * 0.4885596,
        size.width * -0.3530544,
        size.height * 0.4886327);
    path_1.cubicTo(
        size.width * -0.3636483,
        size.height * 0.4887350,
        size.width * -0.3742408,
        size.height * 0.4887831,
        size.width * -0.3848354,
        size.height * 0.4888204);
    path_1.cubicTo(
        size.width * -0.3897912,
        size.height * 0.4888858,
        size.width * -0.3897912,
        size.height * 0.4888858,
        size.width * -0.3948472,
        size.height * 0.4889526);
    path_1.cubicTo(
        size.width * -0.3979210,
        size.height * 0.4889532,
        size.width * -0.4009948,
        size.height * 0.4889539,
        size.width * -0.4041617,
        size.height * 0.4889545);
    path_1.cubicTo(
        size.width * -0.4068661,
        size.height * 0.4889733,
        size.width * -0.4095705,
        size.height * 0.4889921,
        size.width * -0.4123568,
        size.height * 0.4890114);
    path_1.cubicTo(
        size.width * -0.4214671,
        size.height * 0.4877108,
        size.width * -0.4246048,
        size.height * 0.4852687,
        size.width * -0.4301897,
        size.height * 0.4795445);
    path_1.cubicTo(
        size.width * -0.4315743,
        size.height * 0.4726154,
        size.width * -0.4315743,
        size.height * 0.4726154,
        size.width * -0.4316328,
        size.height * 0.4642833);
    path_1.cubicTo(
        size.width * -0.4316781,
        size.height * 0.4611621,
        size.width * -0.4317234,
        size.height * 0.4580409,
        size.width * -0.4317701,
        size.height * 0.4548251);
    path_1.cubicTo(
        size.width * -0.4317596,
        size.height * 0.4514535,
        size.width * -0.4317491,
        size.height * 0.4480820,
        size.width * -0.4317383,
        size.height * 0.4446083);
    path_1.cubicTo(
        size.width * -0.4317570,
        size.height * 0.4411456,
        size.width * -0.4317757,
        size.height * 0.4376829,
        size.width * -0.4317950,
        size.height * 0.4341153);
    path_1.cubicTo(
        size.width * -0.4318239,
        size.height * 0.4249084,
        size.width * -0.4317984,
        size.height * 0.4157026,
        size.width * -0.4317581,
        size.height * 0.4064957);
    path_1.cubicTo(
        size.width * -0.4317484,
        size.height * 0.3971466,
        size.width * -0.4318740,
        size.height * 0.3877983,
        size.width * -0.4319685,
        size.height * 0.3784496);
    path_1.cubicTo(
        size.width * -0.4319742,
        size.height * 0.3713358,
        size.width * -0.4319722,
        size.height * 0.3642220,
        size.width * -0.4319615,
        size.height * 0.3571083);
    path_1.cubicTo(
        size.width * -0.4320016,
        size.height * 0.3537424,
        size.width * -0.4320417,
        size.height * 0.3503766,
        size.width * -0.4320831,
        size.height * 0.3469087);
    path_1.cubicTo(
        size.width * -0.4320496,
        size.height * 0.3437787,
        size.width * -0.4320161,
        size.height * 0.3406486,
        size.width * -0.4319815,
        size.height * 0.3374237);
    path_1.cubicTo(
        size.width * -0.4319807,
        size.height * 0.3332959,
        size.width * -0.4319807,
        size.height * 0.3332959,
        size.width * -0.4319798,
        size.height * 0.3290848);
    path_1.cubicTo(
        size.width * -0.4296515,
        size.height * 0.3196070,
        size.width * -0.4256059,
        size.height * 0.3162805,
        size.width * -0.4159040,
        size.height * 0.3105304);
    path_1.cubicTo(
        size.width * -0.4084915,
        size.height * 0.3091754,
        size.width * -0.4084915,
        size.height * 0.3091754,
        size.width * -0.4005127,
        size.height * 0.3092512);
    path_1.cubicTo(
        size.width * -0.3975107,
        size.height * 0.3092521,
        size.width * -0.3945086,
        size.height * 0.3092529,
        size.width * -0.3914156,
        size.height * 0.3092538);
    path_1.cubicTo(
        size.width * -0.3866046,
        size.height * 0.3093410,
        size.width * -0.3866046,
        size.height * 0.3093410,
        size.width * -0.3816964,
        size.height * 0.3094300);
    path_1.cubicTo(
        size.width * -0.3783872,
        size.height * 0.3094460,
        size.width * -0.3750780,
        size.height * 0.3094619,
        size.width * -0.3716686,
        size.height * 0.3094783);
    path_1.cubicTo(
        size.width * -0.3611142,
        size.height * 0.3095413,
        size.width * -0.3505642,
        size.height * 0.3096827,
        size.width * -0.3400112,
        size.height * 0.3098261);
    path_1.cubicTo(
        size.width * -0.3328498,
        size.height * 0.3098827,
        size.width * -0.3256883,
        size.height * 0.3099341,
        size.width * -0.3185268,
        size.height * 0.3099802);
    path_1.cubicTo(
        size.width * -0.3009842,
        size.height * 0.3101043,
        size.width * -0.2834448,
        size.height * 0.3102988,
        size.width * -0.2659040,
        size.height * 0.3105304);
    path_1.cubicTo(
        size.width * -0.2659601,
        size.height * 0.3068264,
        size.width * -0.2660162,
        size.height * 0.3031223,
        size.width * -0.2660740,
        size.height * 0.2993061);
    path_1.cubicTo(
        size.width * -0.2662702,
        size.height * 0.2853676,
        size.width * -0.2663918,
        size.height * 0.2714291,
        size.width * -0.2664926,
        size.height * 0.2574900);
    path_1.cubicTo(
        size.width * -0.2665460,
        size.height * 0.2514938,
        size.width * -0.2666187,
        size.height * 0.2454978,
        size.width * -0.2667123,
        size.height * 0.2395020);
    path_1.cubicTo(
        size.width * -0.2677789,
        size.height * 0.1693501,
        size.width * -0.2558328,
        size.height * 0.1079893,
        size.width * -0.1926200,
        size.height * 0.05511664);
    path_1.cubicTo(
        size.width * -0.1652818,
        size.height * 0.03487847,
        size.width * -0.1359323,
        size.height * 0.02161633,
        size.width * -0.1011719,
        size.height * 0.01105854);
    path_1.cubicTo(
        size.width * -0.09765256,
        size.height * 0.009981786,
        size.width * -0.09765256,
        size.height * 0.009981786,
        size.width * -0.09406215,
        size.height * 0.008883280);
    path_1.cubicTo(
        size.width * -0.09175853,
        size.height * 0.008217643,
        size.width * -0.08945490,
        size.height * 0.007552005,
        size.width * -0.08708147,
        size.height * 0.006866197);
    path_1.cubicTo(
        size.width * -0.08405592,
        size.height * 0.005987569,
        size.width * -0.08405592,
        size.height * 0.005987569,
        size.width * -0.08096924,
        size.height * 0.005091192);
    path_1.cubicTo(size.width * -0.05446092, size.height * -0.0002727174,
        size.width * -0.02717510, size.height * 0.0001404455, 0, 0);
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
