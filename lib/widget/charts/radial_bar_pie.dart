import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../theme/color.dart';
import '../../theme/text_style.dart';

class CustomDoughnutChart extends StatelessWidget {
  final Map<String, double> dataMapPercentage;
  final Map<String, double> dataMapAmount;
  final Map<String, Color> colorMap;
  final String title;
  final double total;
  final bool showDataDetails;

  const CustomDoughnutChart({
    Key? key,
    required this.dataMapPercentage,
    required this.dataMapAmount,
    required this.colorMap,
    required this.title,
    required this.total,
    this.showDataDetails = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NumberFormat phpCurrencyFormat = NumberFormat.currency(
      locale: 'fil_PH',
      symbol: '₱',
      decimalDigits: 2,
    );

    final List<ChartData> chartData = dataMapPercentage.entries.map((entry) {
      final Color pointColor = colorMap[entry.key] ?? Colors.blue;
      return ChartData(entry.key, entry.value, pointColor);
    }).toList();

    return Container(
      width: double.infinity,
      height: showDataDetails ? 400 : 350,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white10,
            offset: const Offset(-6, -6),
            blurRadius: 6,
          ),
          BoxShadow(
            color: AppPalette.teal.withAlpha(80),
            offset: const Offset(6, 6),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SfCircularChart(
              title:
                  ChartTitle(text: title, textStyle: AppTextStyles.subheading),
              legend: Legend(isVisible: true),
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Text(
                    phpCurrencyFormat.format(total),
                    style: AppTextStyles.body
                        .copyWith(fontSize: 18, color: AppPalette.teal),
                  ),
                  radius: '0%',
                ),
              ],
              series: <CircularSeries>[
                DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  pointColorMapper: (ChartData data, _) => data.color,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    useSeriesColor: true,
                    connectorLineSettings: ConnectorLineSettings(
                      type: ConnectorType.curve,
                      length: '10%',
                    ),
                  ),
                  dataLabelMapper: (ChartData data, int index) =>
                      '${data.y.toStringAsFixed(2)}%',
                  innerRadius: '80%',
                ),
              ],
            ),
          ),
          if (showDataDetails)
            Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amounts",
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: dataMapAmount.entries.map((entry) {
                          final Color indicatorColor =
                              colorMap[entry.key] ?? Colors.blue;
                          return Container(
                            margin: const EdgeInsets.only(right: 16.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: indicatorColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${entry.key}: ${phpCurrencyFormat.format(entry.value)}',
                                  style: AppTextStyles.body,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}
