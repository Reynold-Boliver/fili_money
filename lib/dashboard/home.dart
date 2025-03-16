import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fili_money/constants/finance_types.dart';
import 'package:fili_money/theme/color.dart';
import 'package:fili_money/theme/text_style.dart';
import 'package:fili_money/widget/charts/radial_bar_pie.dart';
import 'package:fili_money/widget/charts/horizontal_bar_chart.dart';
import 'package:fili_money/widget/text_fields/month_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Firebase Database reference.
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();
  // Hard-coded UID; update as needed.
  final String uid = "u23TowGWWzSYtpqDrFmfYMSRsuc2"; // must be the ui of the user currently logged in
  // The currently selected date (defaults to current date).
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Format year and month from the selected date.
    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0');
    // Build the database reference for the selected month and year.
    final DatabaseReference monthRef = _databaseRef.child('$uid/$year/$month');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Finances', style: AppTextStyles.heading),
        backgroundColor: AppPalette.teal.withAlpha(25),
      ),
      backgroundColor: AppPalette.teal.withAlpha(25),
      body: StreamBuilder(
        stream: monthRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          // Check for errors.
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          // While waiting for data, show a loader.
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract data from the snapshot.
          final data = snapshot.data!.snapshot.value as Map?;
          Map<String, dynamic> expenseMap = {};
          Map<String, dynamic> incomeMap = {};

          if (data != null) {
            if (data['expense'] != null) {
              expenseMap = Map<String, dynamic>.from(data['expense']);
            }
            if (data['income'] != null) {
              incomeMap = Map<String, dynamic>.from(data['income']);
            }
          }

          // Check if any financial data exists.
          final bool hasData = expenseMap.isNotEmpty || incomeMap.isNotEmpty;

          // Parse expense data.
          double totalExpense = 0;
          Map<String, double> expenseData = {};
          expenseMap.forEach((key, value) {
            double amount = (value as num).toDouble();
            expenseData[key] = amount;
            totalExpense += amount;
          });

          // Parse income data.
          double totalIncome = 0;
          Map<String, double> incomeData = {};
          incomeMap.forEach((key, value) {
            double amount = (value as num).toDouble();
            incomeData[key] = amount;
            totalIncome += amount;
          });

          // Data for the horizontal bar chart.
          final List<BarData> chartData = [
            BarData(label: 'Income', value: totalIncome, color: AppPalette.teal),
            BarData(label: 'Expense', value: totalExpense, color: Colors.red),
          ];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Month & Year picker.
                  MonthYearPickerField(
                    fieldName: "Select Month & Year",
                    controller: TextEditingController(),
                    onDateChange: (DateTime date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // If no data exists, display a message.
                  if (!hasData)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "No data available for the selected month and year.",
                        style: AppTextStyles.subheading,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else ...[
                    // Horizontal bar chart showing total income vs. expense.
                    SimpleHorizontalBarChart(
                      data: chartData,
                      title: 'Money Tracker',
                    ),
                    const SizedBox(height: 16.0),
                    // Radial chart for expense breakdown.
                    CustomRadialBarChart(
                      title: 'Expense Summary',
                      dataMap: expenseData,
                      colorMap: categoryExpenseColors,
                    ),
                    const SizedBox(height: 16.0),
                    // Radial chart for income breakdown.
                    CustomRadialBarChart(
                      title: 'Income Summary',
                      dataMap: incomeData,
                      colorMap: categoryIncomeColors,
                    ),
                    const SizedBox(height: 100.0),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
