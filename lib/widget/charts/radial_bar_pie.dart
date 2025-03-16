import 'package:fili_money/theme/text_style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../theme/color.dart';

class CustomRadialBarChart extends StatelessWidget {
  final Map<String, double> dataMap;
  final Map<String, Color> colorMap;
  final String title;

  const CustomRadialBarChart({
    super.key,
    required this.dataMap,
    required this.colorMap, required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Convert the data map into a list of ChartData objects, pairing each key with its color.
    final List<ChartData> chartData = dataMap.entries.map((entry) {
      // Use the color from the colorMap; if not provided, default to blue.
      final Color pointColor = colorMap[entry.key] ?? Colors.blue;
      return ChartData(entry.key, entry.value, pointColor);
    }).toList();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white10,
            offset: Offset(-6, -6),
            blurRadius: 6,
          ),
          BoxShadow(
            color: AppPalette.teal.withAlpha(80),
            offset: Offset(6, 6),
            blurRadius: 6,
          ),
        ],
      ),
      height: 300, // Adjust the height as needed// Adjust the width as needed
      padding: const EdgeInsets.all(8.0),
      child: SfCircularChart(
        title: ChartTitle(text: title, textStyle: AppTextStyles.subheading),
        legend: Legend(isVisible: true),
        series: <CircularSeries>[
          // Render the radial bar chart using the chartData list.
          RadialBarSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            pointColorMapper: (ChartData data, _) => data.color,
            dataLabelSettings: DataLabelSettings(isVisible: true),
          )
        ],
      ),
    );
  }
}

// A simple model class for the chart data.
class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}
