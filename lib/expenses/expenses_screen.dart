import 'package:fili_money/constants/finance_types.dart'; // Ensure this file exports expenseCategories & incomeCategories maps.
import 'package:fili_money/theme/color.dart';
import 'package:fili_money/widget/buttons/primary_button.dart';
import 'package:fili_money/widget/drop_down/drop_down.dart';
import 'package:fili_money/widget/text_fields/primary_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as rtdb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../date_picker/date_field.dart';
import '../theme/text_style.dart';

class ExpensesScreen extends StatefulWidget {
  final double size;
  final Color color;
  final bool hasNotification;

  const ExpensesScreen({
    super.key,
    this.size = 24,
    this.color = Colors.white,
    this.hasNotification = false,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // Controllers for the text fields.
  final TextEditingController receiptNumberController = TextEditingController();
  final TextEditingController expenseNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController expenseTypeController = TextEditingController();
  final TextEditingController expenseDateController = TextEditingController();

  // Error messages for form validation.
  String? expenseNameError;
  String? amountError;
  String? expenseTypeError;
  String? expenseDateError;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  // Updated default structure using aggregated categories.
  final Map<String, dynamic> defaultData = {
    "income": {
      "Earned Income": 0.0,
      "Passive Income": 0.0,
      "Other Income": 0.0,
    },
    "expense": {
      "Essential": 0.0,
      "Necessary": 0.0,
      "Discretionary": 0.0,
      "Luxury": 0.0,
    }
  };

  /// Saves the expense data to the Realtime Database and Firestore.
  Future<void> saveExpense(Map<String, String> data) async {
    final currentUser = user;
    if (currentUser == null) {
      messageDialog("User not found", "Error");
      return;
    }
    final String uid = currentUser.uid;
    final String expenseType = data['expenseType'] ?? '';
    final double amount = double.tryParse(data['amount'] ?? '0') ?? 0;

    if (expenseType.isEmpty || amount <= 0) {
      messageDialog("Invalid expense type or amount", "Error");
      return;
    }

    // Parse the expense date to extract year and month.
    DateTime expenseDate;
    try {
      expenseDate = DateTime.parse(data['expenseDate']!);
    } catch (e) {
      messageDialog("Invalid expense date format", "Error");
      return;
    }
    final String year = expenseDate.year.toString();
    // Zero-pad month (e.g. "02" for February).
    final String month = expenseDate.month.toString().padLeft(2, '0');

    // ----- Node Existence Verification -----
    // Reference for the year node.
    final rtdb.DatabaseReference yearRef =
    rtdb.FirebaseDatabase.instance.ref("$uid/$year");
    final rtdb.DatabaseEvent yearEvent = await yearRef.once();
    if (yearEvent.snapshot.value == null) {
      // Year node doesn't exist—create it with the month node containing the default data.
      await yearRef.set({month: defaultData});
    } else {
      // Year exists; now verify the month node.
      final rtdb.DatabaseReference monthRef =
      rtdb.FirebaseDatabase.instance.ref("$uid/$year/$month");
      final rtdb.DatabaseEvent monthEvent = await monthRef.once();
      if (monthEvent.snapshot.value == null) {
        await monthRef.set(defaultData);
      }
    }

    // ----- Conditional Update -----
    // Look up the aggregated expense category from the expenseCategories map.
    // (For example, if expenseType is "Housing", expenseCategories["Housing"] should return "Essential".)
    final String? expenseCategory = expenseCategories[expenseType];
    if (expenseCategory == null) {
      messageDialog("Invalid expense type", "Error");
      return;
    }

    // Reference the month node.
    final rtdb.DatabaseReference monthRef =
    rtdb.FirebaseDatabase.instance.ref("$uid/$year/$month");

    try {
      await monthRef.runTransaction((mutableData) {
        Map<String, dynamic> currentData;
        if (mutableData == null) {
          // Node doesn't exist; initialize with default data.
          currentData = Map<String, dynamic>.from(defaultData);
        } else {
          currentData = Map<String, dynamic>.from(mutableData as Map);
        }
        // Update only the aggregated expense category.
        if (currentData["expense"].containsKey(expenseCategory)) {
          double currentVal = (currentData["expense"][expenseCategory] as num).toDouble();
          currentData["expense"][expenseCategory] = currentVal + amount;
        } else {
          throw Exception("Invalid expense category");
        }
        mutableData = currentData;
        return rtdb.Transaction.success(mutableData);
      });
      messageDialog("Expense updated successfully!", "Success");
    } catch (error) {
      debugPrint("Failed to update aggregated data: $error");
      messageDialog("Failed to update aggregated expense", "Error");
      return;
    }

    // ----- Save individual expense record in Firestore (optional) -----
    // Firestore structure: collection 'history' -> document: uid -> field: timestamp -> { "type": "expense", ... }
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final DocumentReference userDoc =
    FirebaseFirestore.instance.collection('history').doc(uid);

    // Create a typed map from the provided data and add the type.
    Map<String, dynamic> expenseRecord = Map<String, dynamic>.from(data);
    expenseRecord["type"] = "expense";

    try {
      await userDoc.set({timestamp: expenseRecord}, SetOptions(merge: true));
      debugPrint("Expense record saved in Firestore");
    } catch (error) {
      debugPrint("Failed to add expense in Firestore: $error");
      // Optionally, handle the Firestore error.
    }
  }

  /// Displays a dialog with a message and title.
  void messageDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.subheading),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                clearFields();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  /// Validates the form fields.
  void validate() {
    setState(() {
      expenseNameError = expenseNameController.text.isEmpty
          ? 'Purchase Item/Service is required'
          : null;
      amountError = amountController.text.isEmpty ? 'Amount is required' : null;
      expenseTypeError = expenseTypeController.text.isEmpty
          ? 'Expense Type is required'
          : null;
      expenseDateError = expenseDateController.text.isEmpty
          ? 'Expense Date is required'
          : null;
    });
  }

  /// Clears all form fields.
  void clearFields() {
    receiptNumberController.clear();
    expenseNameController.clear();
    amountController.clear();
    expenseTypeController.clear();
    expenseDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.teal.withAlpha(25),
        title: Text('Expenses', style: AppTextStyles.heading),
      ),
      backgroundColor: AppPalette.teal.withAlpha(25),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PrimaryTextField(
                fieldName: 'Receipt Number (if available)',
                controller: receiptNumberController,
              ),
              const SizedBox(height: 12),
              PrimaryTextField(
                fieldName: 'Purchase Item/Service',
                errorMessage: expenseNameError,
                controller: expenseNameController,
              ),
              const SizedBox(height: 12),
              PrimaryTextField(
                fieldName: 'Amount',
                controller: amountController,
                errorMessage: amountError,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              ),
              const SizedBox(height: 12),
              CustomDropdownSearch(
                categories: expenseCategories,
                categoryColors: categoryExpenseColors,
                controller: expenseTypeController,
                errorMessage: expenseTypeError,
              ),
              const SizedBox(height: 12),
              PrimaryDateTextField(
                fieldName: 'Date',
                controller: expenseDateController,
                errorMessage: expenseDateError,
              ),
              const SizedBox(height: 40),
              PrimaryButton.filled(
                onPressed: () {
                  validate();
                  if (expenseNameError == null &&
                      amountError == null &&
                      expenseTypeError == null &&
                      expenseDateError == null) {
                    saveExpense({
                      'receiptNumber': receiptNumberController.text,
                      'expenseName': expenseNameController.text,
                      'amount': amountController.text,
                      'expenseType': expenseTypeController.text,
                      'expenseDate': expenseDateController.text,
                    });
                  }
                },
                text: 'Add Expense',
                color: AppPalette.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
