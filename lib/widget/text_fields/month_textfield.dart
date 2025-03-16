import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fili_money/theme/color.dart';

class MonthYearPickerField extends StatefulWidget {
  final String fieldName;
  final TextEditingController controller;
  final Function(DateTime) onDateChange;

  const MonthYearPickerField({
    super.key,
    required this.fieldName,
    required this.controller,
    required this.onDateChange,
  });

  @override
  MonthYearPickerFieldState createState() => MonthYearPickerFieldState();
}

class MonthYearPickerFieldState extends State<MonthYearPickerField> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Set the initial value to the current month and year if empty.
    if (widget.controller.text.isEmpty) {
      widget.controller.text = DateFormat('MMMM yyyy').format(now);
    }
  }

  void _openMonthYearPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return MonthYearPickerDialog(initialValue: widget.controller.text);
      },
    ).then((selectedDate) {
      if (selectedDate != null && selectedDate is DateTime) {
        setState(() {
          widget.controller.text =
              DateFormat('MMMM yyyy').format(selectedDate);
        });
        widget.onDateChange(selectedDate);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            widget.fieldName,
            style: TextStyle(
              color: AppPalette.teal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 4),
        // Container styled like PrimaryTextField
        Container(
          decoration: BoxDecoration(
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
          child: TextField(
            controller: widget.controller,
            readOnly: true,
            onTap: _openMonthYearPicker,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              // Calendar icon made clickable with GestureDetector
              suffixIcon: GestureDetector(
                onTap: _openMonthYearPicker,
                child: Icon(Icons.calendar_today, color: AppPalette.teal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MonthYearPickerDialog extends StatefulWidget {
  final String initialValue;
  const MonthYearPickerDialog({super.key, required this.initialValue});

  @override
  MonthYearPickerDialogState createState() => MonthYearPickerDialogState();
}

class MonthYearPickerDialogState extends State<MonthYearPickerDialog> {
  // Provide default values to avoid late initialization issues.
  int selectedMonth = 1;
  int selectedYear = 2000;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    // Try to parse the provided initialValue.
    if (widget.initialValue.isNotEmpty) {
      List<String> parts;
      if (widget.initialValue.contains('/')) {
        parts = widget.initialValue.split('/');
      } else if (widget.initialValue.contains(' ')) {
        parts = widget.initialValue.split(' ');
      } else {
        parts = [widget.initialValue];
      }
      if (parts.length == 2) {
        // Try parsing the month part as a number.
        int? m = int.tryParse(parts[0]);
        if (m != null) {
          selectedMonth = m;
        } else {
          // If not a number, try parsing the month name.
          try {
            DateTime dt = DateFormat('MMMM').parse(parts[0]);
            selectedMonth = dt.month;
          } catch (e) {
            selectedMonth = now.month;
          }
        }
        selectedYear = int.tryParse(parts[1]) ?? now.year;
      } else {
        selectedMonth = now.month;
        selectedYear = now.year;
      }
    } else {
      selectedMonth = now.month;
      selectedYear = now.year;
    }
  }

  void _confirmSelection() {
    DateTime selectedDate = DateTime(selectedYear, selectedMonth);
    Navigator.pop(context, selectedDate);
  }

  // A helper widget to wrap a ListWheelScrollView and overlay an indicator.
  Widget _buildWheelPicker({
    required Widget child,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        // Overlay a container with top and bottom borders as indicator.
        Container(
          height: 40, // same as the itemExtent
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppPalette.teal, width: 2),
              bottom: BorderSide(color: AppPalette.teal, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text(
            "Select Month & Year",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppPalette.teal,
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              children: [
                // Month picker wheel with overlay indicator.
                Expanded(
                  child: _buildWheelPicker(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      physics: FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                          initialItem: selectedMonth - 1),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = index + 1;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          if (index < 0 || index > 11) return null;
                          return Center(
                            child: Text(
                              DateFormat('MMMM').format(DateTime(0, index + 1)),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                        childCount: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Year picker wheel with overlay indicator.
                Expanded(
                  child: _buildWheelPicker(
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 40,
                      physics: FixedExtentScrollPhysics(),
                      controller: FixedExtentScrollController(
                          initialItem: selectedYear - 2000),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = 2000 + index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          int year = 2000 + index;
                          return Center(
                            child: Text(
                              '$year',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                        childCount: 101, // For years 2000 to 2100
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _confirmSelection,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.teal,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              "Confirm",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
