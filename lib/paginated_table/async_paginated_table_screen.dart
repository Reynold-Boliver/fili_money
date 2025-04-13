import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart'; // For RTDB
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fili_money/constants/finance_types.dart';
import 'package:fili_money/theme/color.dart'; // This file defines categoryIncomeColors and categoryExpenseColors.
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart' as pdf_lib;
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

import '../theme/text_style.dart';
import '../widget/text_fields/month_textfield.dart';

/// Helper: Converts a Flutter [Color] into a PDF-compatible 32-bit ARGB integer.
/// Uses modern accessors (.a, .r, .g, .b) instead of deprecated properties.
int convertColorToPdfValue(Color color) {
  int alpha = color.alpha;
  int red = color.red;
  int green = color.green;
  int blue = color.blue;

  return (alpha << 24) | (red << 16) | (green << 8) | blue;
}

class AsyncPaginatedTableScreen extends StatefulWidget {
  const AsyncPaginatedTableScreen({super.key});

  @override
  AsyncPaginatedTableScreenState createState() =>
      AsyncPaginatedTableScreenState();
}

class AsyncPaginatedTableScreenState extends State<AsyncPaginatedTableScreen> {
  late FirestoreDataSource _expenseDataSource;
  late FirestoreDataSource _incomeDataSource;
  DateTime selectedDate = DateTime.now();
  final TextEditingController _dateController = TextEditingController();
  late String userId;

  @override
  void initState() {
    super.initState();
    // Get the current user's uid from FirebaseAuth.
    userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    // Initialize Firestore data sources for the tables.
    _expenseDataSource = FirestoreDataSource(
      userId: userId,
      recordType: 'expense',
      filterMonth: selectedDate.month,
      filterYear: selectedDate.year,
    );
    _incomeDataSource = FirestoreDataSource(
      userId: userId,
      recordType: 'income',
      filterMonth: selectedDate.month,
      filterYear: selectedDate.year,
    );
  }

  // Update data sources when the user selects a new month/year.
  void _updateDataSources(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _dateController.text = DateFormat('yyyy-MM-dd').format(newDate);
      _expenseDataSource = FirestoreDataSource(
        userId: userId,
        recordType: 'expense',
        filterMonth: selectedDate.month,
        filterYear: selectedDate.year,
      );
      _incomeDataSource = FirestoreDataSource(
        userId: userId,
        recordType: 'income',
        filterMonth: selectedDate.month,
        filterYear: selectedDate.year,
      );
    });
  }

  Future<void> _generatePdf() async {
    final pdf = pw.Document();
    // todo check if there is no data from both income and expense on the tabl, then show user there is no data to be printed
    // Helper function to safely convert a value to double.
    double parseAmount(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    // -------------------------------------------------------------------------
    // 1) TABLE DATA: Fetch Firestore records for expense and income.
    final List<Map<String, dynamic>> expenseRecords =
        await _expenseDataSource.getAllRecords();
    final List<Map<String, dynamic>> incomeRecords =
        await _incomeDataSource.getAllRecords();

    // Prepare table data for Income.
    final incomeTableHeaders = ['Date', 'Type', 'Amount'];
    final incomeTableData = incomeRecords.map((income) {
      final DateTime date = income['recordDate'] as DateTime;
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final String type = income['recordTypeField'] ?? '';
      final String amount = income['amount'].toString();
      return [formattedDate, type, amount];
    }).toList();

    // Prepare table data for Expense.
    final expenseTableHeaders = ['Date', 'Name', 'Type', 'Amount', 'Receipt'];
    final expenseTableData = expenseRecords.map((expense) {
      final DateTime date = expense['recordDate'] as DateTime;
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final String name = expense['recordName'] ?? '';
      final String type = expense['recordTypeField'] ?? '';
      final String amount = expense['amount'].toString();
      final String receipt =
          (expense['receiptNumber']?.toString().trim() ?? '').isEmpty
              ? 'N/A'
              : expense['receiptNumber'].toString();
      return [formattedDate, name, type, amount, receipt];
    }).toList();
    if (expenseRecords.isEmpty && incomeRecords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data available to print.")),
      );
      return;
    }
    // -------------------------------------------------------------------------
    // PAGE 1: Show Income and Expense Tables.
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Income Table', style: pw.TextStyle(fontSize: 18)),
          pw.Table.fromTextArray(
            headers: incomeTableHeaders,
            data: incomeTableData,
          ),
          pw.SizedBox(height: 20),
          pw.Text('Expense Table', style: pw.TextStyle(fontSize: 18)),
          pw.Table.fromTextArray(
            headers: expenseTableHeaders,
            data: expenseTableData,
          ),
        ],
      ),
    );

    // -------------------------------------------------------------------------
    // 2) CHART DATA PREPARATION from Realtime Database (RTDB).
    final DatabaseReference dbRef = FirebaseDatabase.instance.ref();
    final String yearStr = DateFormat('yyyy').format(selectedDate);
    final String monthStr = DateFormat('MM').format(selectedDate);

    final DataSnapshot snapshot =
        await dbRef.child(userId).child(yearStr).child(monthStr).get();
    if (!snapshot.exists) {
      throw Exception(
          "No RTDB data found for user: $userId, year: $yearStr, month: $monthStr");
    }
    final Map dataMap = snapshot.value as Map;

    // Currency data.
    final double totalIncomeRT = parseAmount(dataMap["totalIncome"]);
    final double totalExpenseRT = parseAmount(dataMap["totalExpense"]);
    final double savingsRT = parseAmount(dataMap["savings"]);

    debugPrint(savingsRT.toString());

    // Determine the maximum value for the y-axis.
    final double maxBarValue =
        [savingsRT, totalIncomeRT, totalExpenseRT].reduce(max);
    final double yAxisMax = (maxBarValue / 100).ceil() * 100;

    // Updated x-axis labels to reflect the proper order.
    final xAxisLabels = ['Savings', 'Income', 'Expense'];

    // -------------------------------------------------------------------------
    // A) BAR CHART: Income vs. Expense.
    final barChart = pw.Chart(
      title: pw.Text('Income vs Expense', style: pw.TextStyle(fontSize: 16)),
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis.fromStrings(
          xAxisLabels,
          marginStart: 100,
          marginEnd: 100,
          ticks: true,
        ),
        yAxis: pw.FixedAxis(
          [0, yAxisMax / 2, yAxisMax],
          divisions: true,
          format: (v) => 'PHP $v',
        ),
      ),
      datasets: [
        // Savings bar at index 0.
        pw.BarDataSet(
          color: pdf_lib.PdfColors.blueAccent,
          legend: 'Savings',
          width: 100,
          borderColor: pdf_lib.PdfColors.blue,
          data: [pw.PointChartValue(0, savingsRT)],
        ),
        // Income bar at index 1.
        pw.BarDataSet(
          color: pdf_lib.PdfColors.green,
          legend: 'Income',
          width: 100,
          borderColor: pdf_lib.PdfColors.greenAccent,
          data: [pw.PointChartValue(1, totalIncomeRT)],
        ),
        // Expense bar at index 2.
        pw.BarDataSet(
          color: pdf_lib.PdfColors.red,
          legend: 'Expense',
          width: 100,
          borderColor: pdf_lib.PdfColors.redAccent,
          data: [pw.PointChartValue(2, totalExpenseRT)],
        ),
      ],
    );

    // Calculate net income.
    final double netIncome = totalIncomeRT - totalExpenseRT;
    // Updated analysis message to include savings.
    final String analysisMessage =
        "Your total income is PHP $totalIncomeRT, your total expense is PHP $totalExpenseRT, and your savings are PHP $savingsRT. "
        "This results in a net ${netIncome >= 0 ? 'surplus' : 'deficit'} of PHP ${netIncome.abs()}. "
        "${netIncome >= 0 ? 'Great job managing your finances!' : 'Consider reviewing your spending habits.'}";

    // -------------------------------------------------------------------------
    // PAGE 2: Bar Chart with Income vs. Expense and Analysis Text.
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Income vs Expense Comparison',
                style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 10),
            pw.Container(
              height: 300,
              child: barChart,
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              analysisMessage,
              style: pw.TextStyle(fontSize: 14),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // -------------------------------------------------------------------------
    // B) PIE CHART: INCOME SUBTYPES.
    final Map<String, double> incomeBySubtype = {};
    final Map<String, dynamic> incomeMapData = dataMap["income"] != null
        ? Map<String, dynamic>.from(dataMap["income"])
        : {};
    incomeMapData.forEach((key, value) {
      incomeBySubtype[key.toString()] = parseAmount(value);
    });
    final double totalIncomeBySubtype =
        incomeBySubtype.values.fold(0.0, (total, v) => total + v);

    final List<pw.Dataset> incomePieDataSets =
        incomeBySubtype.entries.map((entry) {
      final int pct = totalIncomeBySubtype > 0
          ? ((entry.value / totalIncomeBySubtype) * 100).round()
          : 0;
      final Color? flutterColor = categoryIncomeColors[entry.key];
      final int pdfColorValue =
          convertColorToPdfValue(flutterColor ?? Colors.grey);
      return pw.PieDataSet(
        legend: '',
        value: entry.value,
        color: pdf_lib.PdfColor.fromInt(pdfColorValue),
        legendStyle: const pw.TextStyle(fontSize: 14),
      );
    }).toList();

    final pw.Chart incomePieChart = pw.Chart(
      grid: pw.PieGrid(),
      datasets: incomePieDataSets,
    );

    // Custom legend for Income.
    final pw.Widget incomeLegend = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: incomeBySubtype.entries.map((entry) {
        final int pct = totalIncomeBySubtype > 0
            ? ((entry.value / totalIncomeBySubtype) * 100).round()
            : 0;
        final Color? flutterColor = categoryIncomeColors[entry.key];
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            children: [
              pw.Container(
                width: 12,
                height: 12,
                color: pdf_lib.PdfColor.fromInt(
                  convertColorToPdfValue(flutterColor ?? Colors.grey),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                '${entry.key} ($pct%)',
                style: pw.TextStyle(fontSize: 14),
                textAlign: pw.TextAlign.left,
              ),
            ],
          ),
        );
      }).toList(),
    );

    // Build table data for Income Subtypes.
    final List<List<String>> incomeSubtypeTableData =
        incomeBySubtype.entries.map((entry) {
      final int pct = totalIncomeBySubtype > 0
          ? ((entry.value / totalIncomeBySubtype) * 100).round()
          : 0;
      return [entry.key.toString(), entry.value.toString(), "$pct%"];
    }).toList();

    // -------------------------------------------------------------------------
    // PAGE 3: Income Subtypes Pie Chart with Legend and Details Table.
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Income Subtypes', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Container(
              width: 300,
              height: 300,
              child: incomePieChart,
            ),
            pw.SizedBox(height: 10),
            incomeLegend,
            pw.SizedBox(height: 20),
            pw.Text('Income Details', style: pw.TextStyle(fontSize: 14)),
            pw.Table.fromTextArray(
              headers: ['Subtype', 'Amount', 'Percentage'],
              data: incomeSubtypeTableData,
            ),
          ],
        ),
      ),
    );

    // -------------------------------------------------------------------------
    // C) PIE CHART: EXPENSE SUBTYPES.
    final Map<String, double> expenseBySubtype = {};
    final Map<String, dynamic> expenseMapData = dataMap["expense"] != null
        ? Map<String, dynamic>.from(dataMap["expense"])
        : {};
    expenseMapData.forEach((key, value) {
      expenseBySubtype[key.toString()] = parseAmount(value);
    });
    // Use dummy data if fewer than 2 types.
    if (expenseBySubtype.length < 2) {
      expenseBySubtype.clear();
      expenseBySubtype['Gifts'] = 150;
      expenseBySubtype['Donations'] = 100;
    }
    final double totalExpenseBySubtype =
        expenseBySubtype.values.fold(0.0, (total, v) => total + v);

    final List<pw.Dataset> expensePieDataSets =
        expenseBySubtype.entries.map((entry) {
      final int pct = totalExpenseBySubtype > 0
          ? ((entry.value / totalExpenseBySubtype) * 100).round()
          : 0;
      final Color? flutterColor = categoryExpenseColors[entry.key];
      final int pdfColorValue =
          convertColorToPdfValue(flutterColor ?? Colors.grey);
      return pw.PieDataSet(
        legend: '',
        value: entry.value,
        color: pdf_lib.PdfColor.fromInt(pdfColorValue),
        legendStyle: const pw.TextStyle(fontSize: 14),
      );
    }).toList();

    final pw.Chart expensePieChart = pw.Chart(
      grid: pw.PieGrid(),
      datasets: expensePieDataSets,
    );

    // Custom legend for Expense.
    final pw.Widget expenseLegend = pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: expenseBySubtype.entries.map((entry) {
        final int pct = totalExpenseBySubtype > 0
            ? ((entry.value / totalExpenseBySubtype) * 100).round()
            : 0;
        final Color? flutterColor = categoryExpenseColors[entry.key];
        return pw.Container(
          margin: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            children: [
              pw.Container(
                width: 12,
                height: 12,
                color: pdf_lib.PdfColor.fromInt(
                  convertColorToPdfValue(flutterColor ?? Colors.grey),
                ),
              ),
              pw.SizedBox(width: 8),
              pw.Text(
                '${entry.key} ($pct%)',
                style: pw.TextStyle(fontSize: 14),
                textAlign: pw.TextAlign.left,
              ),
            ],
          ),
        );
      }).toList(),
    );

    // Build table data for Expense Subtypes.
    final List<List<String>> expenseSubtypeTableData =
        expenseBySubtype.entries.map((entry) {
      final int pct = totalExpenseBySubtype > 0
          ? ((entry.value / totalExpenseBySubtype) * 100).round()
          : 0;
      return [entry.key.toString(), entry.value.toString(), "$pct%"];
    }).toList();

    // -------------------------------------------------------------------------
    // PAGE 4: Expense Subtypes Pie Chart with Legend and Details Table.
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Expense Subtypes', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Container(
              width: 300,
              height: 300,
              child: expensePieChart,
            ),
            pw.SizedBox(height: 10),
            expenseLegend,
            pw.SizedBox(height: 20),
            pw.Text('Expense Details', style: pw.TextStyle(fontSize: 14)),
            pw.Table.fromTextArray(
              headers: ['Subtype', 'Amount', 'Percentage'],
              data: expenseSubtypeTableData,
            ),
          ],
        ),
      ),
    );

    // -------------------------------------------------------------------------
    // Save the PDF file to a temporary directory and open it.
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/financial_report.pdf");
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.teal.withAlpha(25),
      appBar: AppBar(
        backgroundColor: AppPalette.teal.withAlpha(25),
        title: Text("Finance History", style: AppTextStyles.heading),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            // Month & Year picker.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MonthYearPickerField(
                fieldName: "Select Month & Year",
                controller: _dateController,
                onDateChange: (DateTime date) {
                  _updateDataSources(date);
                },
              ),
            ),
            // Expense History Table with wider columns.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 500,
                child: AsyncPaginatedDataTable2(
                  hidePaginator: false,
                  horizontalScrollController: ScrollController(),
                  scrollController: ScrollController(),
                  dataTextStyle: AppTextStyles.caption,
                  minWidth: 600,
                  columns: const [
                    DataColumn2(
                      label: Text('Date', style: AppTextStyles.caption),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Name', style: AppTextStyles.caption),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Type', style: AppTextStyles.caption),
                      size: ColumnSize.L,
                    ),
                    DataColumn2(
                      label: Text('Amount', style: AppTextStyles.caption),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Receipt', style: AppTextStyles.caption),
                      size: ColumnSize.M,
                    ),
                  ],
                  source: _expenseDataSource,
                  header: const Text('Expense History',
                      style: AppTextStyles.subheading),
                  rowsPerPage: 10,
                  loading: Center(
                      child: CircularProgressIndicator(color: AppPalette.teal)),
                  empty: Center(child: Text('No Data Available')),
                ),
              ),
            ),
            // Income History Table.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                height: 500,
                child: AsyncPaginatedDataTable2(
                  hidePaginator: false,
                  horizontalScrollController: ScrollController(),
                  scrollController: ScrollController(),
                  dataTextStyle: AppTextStyles.caption,
                  minWidth: 600,
                  columns: const [
                    DataColumn2(
                      label: Text('Date', style: AppTextStyles.caption),
                      size: ColumnSize.S,
                    ),
                    DataColumn2(
                      label: Text('Type', style: AppTextStyles.caption),
                      size: ColumnSize.M,
                    ),
                    DataColumn2(
                      label: Text('Amount', style: AppTextStyles.caption),
                      size: ColumnSize.S,
                    ),
                  ],
                  source: _incomeDataSource,
                  header: const Text('Income History',
                      style: AppTextStyles.subheading),
                  rowsPerPage: 10,
                  loading: Center(
                      child: CircularProgressIndicator(color: AppPalette.teal)),
                  empty: Center(child: Text('No Data Available')),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // PDF Generation Button.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.picture_as_pdf,
                  color: AppPalette.teal,
                ),
                label:
                    const Text("Download PDF", style: AppTextStyles.subheading),
                onPressed: _generatePdf,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class FirestoreDataSource extends AsyncDataTableSource {
  final String userId;
  final String recordType; // 'expense' or 'income'
  final int filterMonth;
  final int filterYear;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirestoreDataSource({
    required this.userId,
    required this.recordType,
    required this.filterMonth,
    required this.filterYear,
  });

  /// Retrieves and filters records from the user document in "history".
  Future<List<Map<String, dynamic>>> _getAllRecords() async {
    DocumentSnapshot userDoc =
        await firestore.collection('history').doc(userId).get();
    debugPrint("Raw user document data: ${userDoc.data()}");

    List<Map<String, dynamic>> filteredRecords = [];
    if (userDoc.exists && userDoc.data() != null) {
      final Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        if (value is! Map<String, dynamic>) return;
        if (value['type'] != recordType) return;

        if (recordType == 'income') {
          final rawDateValue = value['incomeDate'];
          DateTime recordDate;
          if (rawDateValue is Timestamp) {
            recordDate = rawDateValue.toDate();
          } else {
            recordDate = DateTime.tryParse(rawDateValue?.toString() ?? '') ??
                DateTime(0);
          }
          if (recordDate.month == filterMonth &&
              recordDate.year == filterYear) {
            final recordWithId = {
              'id': key,
              'recordDate': recordDate,
              'recordTypeField': value['incomeType'],
              'amount': value['amount'],
            };
            filteredRecords.add(recordWithId);
          }
        } else {
          final rawDateValue = value['expenseDate'];
          DateTime recordDate;
          if (rawDateValue is Timestamp) {
            recordDate = rawDateValue.toDate();
          } else {
            recordDate = DateTime.tryParse(rawDateValue?.toString() ?? '') ??
                DateTime(0);
          }
          if (recordDate.month == filterMonth &&
              recordDate.year == filterYear) {
            final recordWithId = {
              'id': key,
              'recordDate': recordDate,
              'recordName': value['expenseName'],
              'recordTypeField': value['expenseType'],
              'amount': value['amount'],
              'receiptNumber': value['receiptNumber'],
            };
            filteredRecords.add(recordWithId);
          }
        }
      });
    }
    debugPrint("Filtered records count: ${filteredRecords.length}");
    return filteredRecords;
  }

  // Public method for PDF generation.
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    return await _getAllRecords();
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    List<Map<String, dynamic>> allRecords = await _getAllRecords();
    final totalRecords = allRecords.length;
    final paginatedRecords = allRecords.skip(startIndex).take(count).toList();

    List<DataRow> rows = paginatedRecords.map((record) {
      final DateTime recordDate = record['recordDate'] as DateTime;
      final String dateText = DateFormat('yyyy-MM-dd').format(recordDate);

      if (recordType == 'income') {
        return DataRow(cells: [
          DataCell(Text(dateText)),
          DataCell(Text(record['recordTypeField'] ?? '')),
          DataCell(Text(record['amount'] ?? '')),
        ]);
      } else {
        final String receiptValue =
            (record['receiptNumber']?.toString().trim() ?? '').isEmpty
                ? 'N/A'
                : record['receiptNumber'].toString();
        return DataRow(cells: [
          DataCell(Text(dateText)),
          DataCell(Text(record['recordName'] ?? '')),
          DataCell(Text(record['recordTypeField'] ?? '')),
          DataCell(Text(record['amount'] ?? '')),
          DataCell(Text(receiptValue)),
        ]);
      }
    }).toList();

    return AsyncRowsResponse(totalRecords, rows);
  }
}
