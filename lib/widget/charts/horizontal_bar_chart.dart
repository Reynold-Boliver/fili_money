import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
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
    // Currency formatter for Philippine Peso.
    final NumberFormat currencyFormatter =
    NumberFormat.currency(locale: 'en_PH', symbol: '₱', decimalDigits: 0);

    // Determine the maximum value among all bars.
    final double maxValue =
    data.map((bar) => bar.value).reduce((a, b) => a > b ? a : b);

    // Extract income and expense from the data list.
    final double income = data
        .firstWhere((bar) => bar.label.toLowerCase() == 'income')
        .value;
    final double expense = data
        .firstWhere((bar) => bar.label.toLowerCase() == 'expense')
        .value;
    final double net = income - expense;

    // Determine the color based on the net value.
    final Color netColor = net < 0 ? Colors.red : Colors.green;

    // Build a note or warning based on the comparison.
    String note = '';
    Color noteColor = Colors.orange;
    if (expense > income) {
      note = 'Warning: Expenses have exceeded income.';
      noteColor = Colors.red;
    } else if (expense >= 0.9 * income) {
      note = 'Warning: Expenses are close to exceeding income.';
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.5,
      ),
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
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
            LayoutBuilder(
              builder: (context, constraints) {
                // Reserve space for the labels on the left.
                final double maxBarWidth = constraints.maxWidth - 100;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.map((bar) {
                    final String amountText =
                    currencyFormatter.format(bar.value);
                    // Calculate the width of the amount text using TextPainter.
                    final TextPainter textPainter = TextPainter(
                      text: TextSpan(
                        text: amountText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      maxLines: 1,
                      textDirection: ui.TextDirection.ltr,
                    )..layout();
                    final double textWidth = textPainter.size.width;

                    // Calculate the proportional width for the bar.
                    final double proportionalWidth =
                        (bar.value / maxValue) * maxBarWidth;

                    // Ensure the bar is at least as wide as the text plus some extra padding.
                    final double finalBarWidth = proportionalWidth < (textWidth + 8)
                        ? textWidth + 8
                        : proportionalWidth;

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
                            tween: Tween(begin: 0, end: finalBarWidth),
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
                                    amountText,
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
            const SizedBox(height: 8),
            if (note.isNotEmpty)
              Text(
                note,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: noteColor,
                ),
              ),
            // Additional note regarding savings.
            const SizedBox(height: 4),
            const Text(
              'Note: 20% is automatically deducted for savings but you can still use that money.',
              style: TextStyle(color: Colors.blueGrey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
