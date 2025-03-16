
import 'package:flutter/material.dart';

import '../../theme/color.dart';
import '../../theme/text_style.dart';

/// Data model for each bar.
class BarData {
  final String label;
  final double value;
  final Color color;

  BarData({required this.label, required this.value, required this.color});
}

/// A custom horizontal bar chart widget wrapped in a card container
/// that includes a title at the top.
class SimpleHorizontalBarChart extends StatelessWidget {
  final List<BarData> data;
  final String title;

  const SimpleHorizontalBarChart({
    super.key,
    required this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the maximum value among all bars.
    final double maxValue =
    data.map((bar) => bar.value).reduce((a, b) => a > b ? a : b);

    return Container(
      height: 150, // Fixed height for the card container.
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title of the card.
          Text(
            title,
            style: AppTextStyles.subheading,
          ),
          const SizedBox(height: 8),
          // The horizontal bar chart.
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Reserve space for the labels on the left.
                final double maxBarWidth = constraints.maxWidth - 100;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((bar) {
                    // Calculate the target bar width proportionally.
                    final double targetBarWidth =
                        (bar.value / maxValue) * maxBarWidth;
                    return Padding(
                      // Reduced vertical padding for closer bars.
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          // Label on the left with text color matching the bar.
                          SizedBox(
                            width: 80,
                            child: Text(
                              bar.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: bar.color,
                              ),
                            ),
                          ),
                          // Animated bar using TweenAnimationBuilder.
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: targetBarWidth),
                            duration: const Duration(seconds: 1),
                            builder: (context, animatedWidth, child) {
                              return Container(
                                width: animatedWidth,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: bar.color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    bar.value.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}