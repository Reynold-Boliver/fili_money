import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fili_money/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';

import '../theme/text_style.dart';
import '../widget/text_fields/month_textfield.dart';

class AsyncPaginatedTableScreen extends StatefulWidget {
  const AsyncPaginatedTableScreen({super.key});

  @override
  AsyncPaginatedTableScreenState createState() => AsyncPaginatedTableScreenState();
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

    // Initialize data sources for the current month/year.
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

  // New PDF generation method.
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    // Fetch records from Firestore for both expense and income.
    final List<Map<String, dynamic>> expenseRecords = await _expenseDataSource.getAllRecords();
    final List<Map<String, dynamic>> incomeRecords = await _incomeDataSource.getAllRecords();

    // Prepare Income Table Data.
    final incomeTableHeaders = ['Date', 'Type', 'Amount'];
    final incomeTableData = incomeRecords.map((income) {
      final DateTime date = income['recordDate'] as DateTime;
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final String type = income['recordTypeField'] ?? '';
      final String amount = income['amount'].toString();
      return [formattedDate, type, amount];
    }).toList();

    // Prepare Expense Table Data.
    final expenseTableHeaders = ['Date', 'Name', 'Type', 'Amount', 'Receipt'];
    final expenseTableData = expenseRecords.map((expense) {
      final DateTime date = expense['recordDate'] as DateTime;
      final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      final String name = expense['recordName'] ?? '';
      final String type = expense['recordTypeField'] ?? '';
      final String amount = expense['amount'].toString();
      final String receipt = (expense['receiptNumber']?.toString().trim() ?? '').isEmpty
          ? 'N/A'
          : expense['receiptNumber'].toString();
      return [formattedDate, name, type, amount, receipt];
    }).toList();

    // Create the PDF pages.
    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text('Income Table', style: pw.TextStyle(fontSize: 18)),
          pw.TableHelper.fromTextArray(
            headers: incomeTableHeaders,
            data: incomeTableData,
          ),
          pw.SizedBox(height: 20),
          pw.Text('Expense Table', style: pw.TextStyle(fontSize: 18)),
          pw.TableHelper.fromTextArray(
            headers: expenseTableHeaders,
            data: expenseTableData,
          ),
        ],
      ),
    );

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
                  header: const Text('Expense History', style: AppTextStyles.subheading),
                  rowsPerPage: 10,
                  loading: Center(child: CircularProgressIndicator(color: AppPalette.teal)),
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
                  header: const Text('Income History', style: AppTextStyles.subheading),
                  rowsPerPage: 10,
                  loading: Center(child: CircularProgressIndicator(color: AppPalette.teal)),
                  empty: Center(child: Text('No Data Available')),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // PDF Generation Button.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf, color: AppPalette.teal,),
                label: const Text("Download PDF" , style: AppTextStyles.subheading),
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
    DocumentSnapshot userDoc = await firestore.collection('history').doc(userId).get();
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
            recordDate = DateTime.tryParse(rawDateValue?.toString() ?? '') ?? DateTime(0);
          }
          if (recordDate.month == filterMonth && recordDate.year == filterYear) {
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
            recordDate = DateTime.tryParse(rawDateValue?.toString() ?? '') ?? DateTime(0);
          }
          if (recordDate.month == filterMonth && recordDate.year == filterYear) {
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
        final String receiptValue = (record['receiptNumber']?.toString().trim() ?? '').isEmpty
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
