import 'package:fili_money/constants/finance_types.dart'; // Exports incomeCategories and categoryIncomeColors.
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

class IncomeScreen extends StatefulWidget {
  final double size;
  final Color color;
  final bool hasNotification; // controls notification state

  const IncomeScreen({
    super.key,
    this.size = 24,
    this.color = Colors.white,
    this.hasNotification = false,
  });

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  // Controllers for the text fields.
  final TextEditingController amountController = TextEditingController();
  final TextEditingController incomeTypeController = TextEditingController();
  final TextEditingController incomeDateController = TextEditingController();

  // Error messages for form validation.
  String? amountError;
  String? incomeTypeError;
  String? incomeDateError;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  // Default structure for RTDB.
  // Both income and expense are defined so the overall structure is consistent.
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

  /// Validates the form fields.
  void validate() {
    setState(() {
      amountError = amountController.text.isEmpty ? 'Amount is required' : null;
      incomeTypeError =
      incomeTypeController.text.isEmpty ? 'Income type is required' : null;
      incomeDateError =
      incomeDateController.text.isEmpty ? 'Income date is required' : null;
    });
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

  /// Clears all form fields.
  void clearFields() {
    amountController.clear();
    incomeTypeController.clear();
    incomeDateController.clear();
  }

  /// Saves the income data to both the Realtime Database and Firestore.
  Future<void> saveIncome(Map<String, String> data) async {
    final currentUser = user;
    if (currentUser == null) {
      messageDialog("User not found", "Error");
      return;
    }
    final String uid = currentUser.uid;
    final String incomeType = data['incomeType'] ?? '';
    final double amount = double.tryParse(data['amount'] ?? '0') ?? 0;

    if (incomeType.isEmpty || amount <= 0) {
      messageDialog("Invalid income type or amount", "Error");
      return;
    }

    // Parse the income date to extract year and month.
    DateTime incomeDate;
    try {
      incomeDate = DateTime.parse(data['incomeDate']!);
    } catch (e) {
      messageDialog("Invalid income date format", "Error");
      return;
    }
    final String year = incomeDate.year.toString();
    // Zero-pad month (e.g. "02" for February).
    final String month = incomeDate.month.toString().padLeft(2, '0');

    // ----- Node Existence Verification in RTDB -----
    final rtdb.DatabaseReference yearRef =
    rtdb.FirebaseDatabase.instance.ref("$uid/$year");
    final rtdb.DatabaseEvent yearEvent = await yearRef.once();
    if (yearEvent.snapshot.value == null) {
      // Create year node with the month sub-node initialized with defaultData.
      await yearRef.set({month: defaultData});
    } else {
      final rtdb.DatabaseReference monthRef =
      rtdb.FirebaseDatabase.instance.ref("$uid/$year/$month");
      final rtdb.DatabaseEvent monthEvent = await monthRef.once();
      if (monthEvent.snapshot.value == null) {
        await monthRef.set(defaultData);
      }
    }

    // ----- Conditional Update for Income -----
    // Look up the aggregated income category using your incomeCategories map.
    // For example, if incomeType is "Salary", incomeCategories["Salary"] should return "Earned Income".
    final String? incomeCategory = incomeCategories[incomeType];
    if (incomeCategory == null) {
      messageDialog("Invalid income type", "Error");
      return;
    }

    final rtdb.DatabaseReference monthRef =
    rtdb.FirebaseDatabase.instance.ref("$uid/$year/$month");
    try {
      await monthRef.runTransaction((mutableData) {
        Map<String, dynamic> currentData;
        if (mutableData == null) {
          currentData = Map<String, dynamic>.from(defaultData);
        } else {
          currentData = Map<String, dynamic>.from(mutableData as Map);
        }
        if (currentData["income"].containsKey(incomeCategory)) {
          double currentVal = (currentData["income"][incomeCategory] as num).toDouble();
          currentData["income"][incomeCategory] = currentVal + amount;
        } else {
          throw Exception("Invalid income category");
        }
        mutableData = currentData;
        return rtdb.Transaction.success(mutableData);
      });
      messageDialog("Income updated successfully!", "Success");
    } catch (error) {
      debugPrint("Failed to update aggregated income: $error");
      messageDialog("Failed to update aggregated income", "Error");
      return;
    }

    // ----- Save Income Record in Firestore -----
    // Structure: history → document: uid → field: timestamp → { "type": "income", ... }
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final DocumentReference userDoc =
    FirebaseFirestore.instance.collection('history').doc(uid);
    Map<String, dynamic> incomeRecord = Map<String, dynamic>.from(data);
    incomeRecord["type"] = "income";

    try {
      await userDoc.set({timestamp: incomeRecord}, SetOptions(merge: true));
      debugPrint("Income record saved in Firestore");
    } catch (error) {
      debugPrint("Failed to add income in Firestore: $error");
      messageDialog("Failed to add income", "Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.teal.withAlpha(25),
        title: Text('Income', style: AppTextStyles.heading),
      ),
      backgroundColor: AppPalette.teal.withAlpha(25),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PrimaryTextField(
                fieldName: 'Amount',
                controller: amountController,
                errorMessage: amountError,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              ),
              const SizedBox(height: 12),
              CustomDropdownSearch(
                categories: incomeCategories,
                categoryColors: categoryIncomeColors,
                controller: incomeTypeController,
                errorMessage: incomeTypeError,
              ),
              const SizedBox(height: 12),
              PrimaryDateTextField(
                fieldName: 'Date',
                controller: incomeDateController,
                errorMessage: incomeDateError,
              ),
              const SizedBox(height: 40),
              PrimaryButton.filled(
                onPressed: () {
                  validate();
                  if (amountError == null &&
                      incomeTypeError == null &&
                      incomeDateError == null) {
                    saveIncome({
                      'amount': amountController.text,
                      'incomeType': incomeTypeController.text,
                      'incomeDate': incomeDateController.text,
                    });
                  }
                },
                text: 'Add Income',
                color: AppPalette.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
