import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fili_money/constants/finance_types.dart';
import 'package:fili_money/theme/color.dart';
import 'package:fili_money/theme/text_style.dart';
import 'package:fili_money/widget/charts/horizontal_bar_chart.dart';
import 'package:fili_money/widget/charts/radial_bar_pie.dart';
import 'package:fili_money/widget/text_fields/month_textfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Firebase Database reference.
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  // Variable to hold the current user's UID.
  String? uid;

  // The currently selected date (defaults to current date).
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Retrieve the current user's UID from FirebaseAuth.
    uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      // Handle the not-logged in case appropriately.
      // For example, navigate to a login screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    // If the UID is not available, display a message.
    if (uid == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Finances', style: AppTextStyles.heading),
          backgroundColor: AppPalette.teal.withAlpha(25),
        ),
        body: Center(child: Text("Please log in to view your finances.")),
      );
    }

    // Format year and month from the selected date.
    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0');

    // Build the database reference for the selected month and year.
    // Expected structure:
    // {
    //   "expense": { <subtype>: value, ... },
    //   "income": { <subtype>: value, ... },
    //   "savings": <value>,
    //   "totalExpense": <value>,   // Expense after all adjustments
    //   "totalIncome": <value>     // Income after 20% deduction for savings
    // }
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
          // Error handling.
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          // Loading indicator.
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract data from snapshot.
          final data = snapshot.data!.snapshot.value as Map?;
          double totalIncome = 0;
          double totalExpense = 0;
          double savings = 0;

          // Maps for income and expense subtypes.
          Map<String, double> expenseSubtypesData = {};
          Map<String, double> incomeSubtypesData = {};

          if (data != null) {
            // Retrieve stored totals.
            if (data.containsKey('totalIncome')) {
              totalIncome = (data['totalIncome'] as num).toDouble();
            }
            if (data.containsKey('totalExpense')) {
              totalExpense = (data['totalExpense'] as num).toDouble();
            }
            if (data.containsKey('savings')) {
              savings = (data['savings'] as num).toDouble();
            }
            // Retrieve expense subtypes.
            if (data.containsKey('expense')) {
              final expenseMap = Map<String, dynamic>.from(data['expense']);
              expenseMap.forEach((key, value) {
                expenseSubtypesData[key] = (value as num).toDouble();
              });
            }
            // Retrieve income subtypes.
            if (data.containsKey('income')) {
              final incomeMap = Map<String, dynamic>.from(data['income']);
              incomeMap.forEach((key, value) {
                incomeSubtypesData[key] = (value as num).toDouble();
              });
            }
          }

          // Compute totals from subtypes.
          final double computedExpenseTotal = expenseSubtypesData.values
              .fold(0, (sum, element) => sum + element);
          final double computedIncomeTotal = incomeSubtypesData.values
              .fold(0, (sum, element) => sum + element);

          // For doughnut charts, percentages will be based on these computed totals.
          final Map<String, double> expensePercentageData = {};
          expenseSubtypesData.forEach((key, value) {
            final percentage = computedExpenseTotal > 0
                ? (value / computedExpenseTotal * 100)
                : 0;
            expensePercentageData[key] =
                double.parse(percentage.toStringAsFixed(2));
          });

          final Map<String, double> incomePercentageData = {};
          incomeSubtypesData.forEach((key, value) {
            final percentage = computedIncomeTotal > 0
                ? (value / computedIncomeTotal * 100)
                : 0;
            incomePercentageData[key] =
                double.parse(percentage.toStringAsFixed(2));
          });

          // Data for the horizontal bar chart.
          final List<BarData> chartData = [
            BarData(
                label: 'Income', value: totalIncome, color: AppPalette.teal),
            BarData(label: 'Expense', value: totalExpense, color: Colors.red),
            BarData(label: 'Savings', value: savings, color: Colors.blueAccent),
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
                  // Display message if no data available.
                  if (totalIncome == 0 && totalExpense == 0 && savings == 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "No data available for the selected month and year.",
                        style: AppTextStyles.subheading,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else ...[
                    // Horizontal bar chart displaying totals.
                    SimpleHorizontalBarChart(
                      data: chartData,
                      title: 'Money Tracker',
                    ),
                    const SizedBox(height: 16.0),
                    // Doughnut chart for expense subtype breakdown using computedExpenseTotal.
                    CustomDoughnutChart(
                      total: computedExpenseTotal,
                      title: 'Expense Breakdown',
                      dataMapAmount: expenseSubtypesData,
                      dataMapPercentage: expensePercentageData,
                      colorMap: categoryExpenseColors,
                    ),
                    const SizedBox(height: 16.0),
                    // Doughnut chart for income subtype breakdown using computedIncomeTotal.
                    CustomDoughnutChart(
                      total: computedIncomeTotal,
                      title: 'Income Breakdown',
                      dataMapAmount: incomeSubtypesData,
                      dataMapPercentage: incomePercentageData,
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
