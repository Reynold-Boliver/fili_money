import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart' as rtdb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// These should be defined in your project.
import 'package:fili_money/constants/finance_types.dart'; // Contains expenseCategories & incomeCategories maps.
import 'package:fili_money/theme/color.dart';
import 'package:fili_money/theme/text_style.dart';
import 'package:fili_money/widget/buttons/primary_button.dart';
import 'package:fili_money/widget/drop_down/drop_down.dart';
import 'package:fili_money/widget/text_fields/primary_textfield.dart';
import '../date_picker/date_field.dart';

class ExpensesScreen extends StatefulWidget {
  final double size;
  final Color color;
  final bool hasNotification;

  const ExpensesScreen({
    Key? key,
    this.size = 24,
    this.color = Colors.white,
    this.hasNotification = false,
  }) : super(key: key);

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

  /// Default data for a month node.
  /// Note that expense limits are now stored inside the month node (as decimals).
  /// Also, an initial "totalIncome" field is used to track available income.
  final Map<String, dynamic> defaultData = {
    "totalExpense": 0.0,
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
    },
    // Expense limits stored as decimals (e.g. 0.20 means 20%).
    "expenseLimits": {
      "Discretionary": 0.10,
      "Essential": 0.30,
      "Luxury": 0.10,
      "Necessary": 0.30,
    },
    "savings": 0.0,
    // "totalIncome" is the budgeted income available for spending.
    // It is typically set by the user or computed as the sum of the income map.
    "totalIncome": 0.0,
  };

  /// Displays a dialog with a message and title.
  void messageDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != "Error"
              ? Text(title, style: AppTextStyles.subheading)
              : Text(
                  title,
                  style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
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

  /// Displays a confirmation dialog and returns true if the user confirms.
  Future<bool> showConfirmationDialog(String title, String message) async {
    bool confirmed = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: AppTextStyles.subheading),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                confirmed = false;
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                confirmed = true;
                Navigator.of(context).pop();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
    return confirmed;
  }

  /// Saves the expense data to Firebase after performing budget and deduction checks.
  Future<void> saveExpense(Map<String, String> data) async {
    final currentUser = user;
    if (currentUser == null) {
      messageDialog("User not found", "Error");
      return;
    }
    final String uid = currentUser.uid;
    final String expenseType = data['expenseType'] ?? '';
    final double expenseAmount = double.tryParse(data['amount'] ?? '0') ?? 0;
    if (expenseType.isEmpty || expenseAmount <= 0) {
      messageDialog("Invalid expense type or amount", "Error");
      return;
    }

    // Parse the expense date.
    DateTime expenseDate;
    try {
      expenseDate = DateTime.parse(data['expenseDate']!);
    } catch (e) {
      messageDialog("Invalid expense date format", "Error");
      return;
    }
    final String year = expenseDate.year.toString();
    final String month = expenseDate.month.toString().padLeft(2, '0');

    // Reference for the current month node.
    final rtdb.DatabaseReference monthRef =
        rtdb.FirebaseDatabase.instance.ref("$uid/$year/$month");

    // Retrieve the month data.
    final rtdb.DatabaseEvent monthEvent = await monthRef.once();
    if (monthEvent.snapshot.value == null) {
      messageDialog(
          "No income data found. Please add income before recording expenses.",
          "Error");
      return;
    }
    Map<String, dynamic> monthData =
        Map<String, dynamic>.from(monthEvent.snapshot.value as Map);

    // Check for income.
    if (monthData["income"] == null) {
      messageDialog(
          "No income data found. Please add income before recording expenses.",
          "Error");
      return;
    }
    Map<String, dynamic> incomeMap =
        Map<String, dynamic>.from(monthData["income"]);
    double computedIncome = 0.0;
    incomeMap.forEach((key, value) {
      computedIncome += (value as num).toDouble();
    });
    // Use the totalIncome field if available; otherwise, use computed sum.
    double currentTotalIncome = (monthData["totalIncome"] != null
        ? (monthData["totalIncome"] as num).toDouble()
        : computedIncome);
    if (currentTotalIncome <= 0) {
      messageDialog(
          "No income data found. Please add income before recording expenses.",
          "Error");
      return;
    }

    // Ensure expenseLimits exist at the month node.
    if (monthData["expenseLimits"] == null) {
      messageDialog(
          "Expense limits for this month are not set. Please set the limits first.",
          "Error");
      return;
    }

    // Retrieve the expense category based on the provided expenseType.
    final String? expenseCategory = expenseCategories[expenseType];
    if (expenseCategory == null) {
      messageDialog("Invalid expense type", "Error");
      return;
    }

    // Get the month-level expense limits.
    final Map<String, dynamic> limitsData =
        Map<String, dynamic>.from(monthData["expenseLimits"]);
    if (limitsData[expenseCategory] == null ||
        (limitsData[expenseCategory] as num).toDouble() <= 0) {
      messageDialog(
          "Expense limit for $expenseCategory is not set. Please set the limits first.",
          "Error");
      return;
    }
    double typeLimitPercentage =
        (limitsData[expenseCategory] as num).toDouble();
    // Calculate the allowed amount from income for this expense sub-type.
    double typeLimitAmount = currentTotalIncome * typeLimitPercentage;

    // Get current expense spent for this expense category.
    double currentSpent = 0.0;
    if (monthData["expense"] != null &&
        monthData["expense"][expenseCategory] != null) {
      currentSpent = (monthData["expense"][expenseCategory] as num).toDouble();
    }

    // Initialize excessUsed to determine if any of the expense comes from savings.
    double excessUsed = 0.0;
    if (currentSpent + expenseAmount > typeLimitAmount) {
      excessUsed = currentSpent + expenseAmount - typeLimitAmount;
      double currentSavings = monthData["savings"] != null
          ? (monthData["savings"] as num).toDouble()
          : 0.0;
      if (currentSavings >= excessUsed) {
        bool userConfirmed = await showConfirmationDialog(
            "Expense Limit Reached",
            "You have exceeded your allocated limit for $expenseCategory by ${excessUsed.toStringAsFixed(2)}.\nThis excess will be deducted from your savings. Do you want to proceed?");
        if (!userConfirmed) {
          return;
        } else {
          // Deduct the excess from savings.
          monthData["savings"] = currentSavings - excessUsed;
        }
      } else {
        messageDialog(
            "You have reached your allocated budget for $expenseCategory and do not have sufficient savings to cover the extra ${excessUsed.toStringAsFixed(2)}.",
            "Error");
        return;
      }
    }
    // Determine how much of the expense will be deducted from income.
    // If no savings are used, the entire expense is deducted from income.
    // Otherwise, only (expenseAmount - excessUsed) is deducted from income.
    double deductFromIncome = expenseAmount - excessUsed;

    // Final overall funds check (after proposed deductions).
    if (currentTotalIncome - deductFromIncome < 0 &&
        (currentTotalIncome - deductFromIncome) +
                (monthData["savings"] as num).toDouble() <
            0) {
      messageDialog(
          "Insufficient funds: Your expense cannot be recorded because it exceeds your available income and savings.",
          "Error");
      return;
    }

    // ----- Update the month node with expense, income and savings changes in a transaction -----
    try {
      await monthRef.runTransaction((mutableData) {
        Map<String, dynamic> currentData;
        if (mutableData == null) {
          currentData = Map<String, dynamic>.from(defaultData);
          // In case of a new node, set totalIncome using the computed income.
          currentData["totalIncome"] = computedIncome;
        } else {
          currentData = Map<String, dynamic>.from(mutableData as Map);
        }
        // Update the expense for the given expense category.
        if (currentData["expense"].containsKey(expenseCategory)) {
          double currentVal =
              (currentData["expense"][expenseCategory] as num).toDouble();
          currentData["expense"][expenseCategory] = currentVal + expenseAmount;
        } else {
          throw Exception("Invalid expense category");
        }
        // Update total expense.
        double currentTotalExpense =
            (currentData["totalExpense"] as num?)?.toDouble() ?? 0.0;
        currentData["totalExpense"] = currentTotalExpense + expenseAmount;
        // Deduct the appropriate amount from totalIncome.
        double currTotalIncome = currentData["totalIncome"] != null
            ? (currentData["totalIncome"] as num).toDouble()
            : computedIncome;
        currentData["totalIncome"] = currTotalIncome - deductFromIncome;
        // Also update savings if they were used.
        if (currentData["savings"] != null) {
          currentData["savings"] = monthData["savings"];
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

    // ----- Save the individual expense record in Firestore -----
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final DocumentReference userDoc =
        FirebaseFirestore.instance.collection('history').doc(uid);
    Map<String, dynamic> expenseRecord = Map<String, dynamic>.from(data);
    expenseRecord["type"] = "expense";
    try {
      await userDoc.set({timestamp: expenseRecord}, SetOptions(merge: true));
      debugPrint("Expense record saved in Firestore");
    } catch (error) {
      debugPrint("Failed to add expense in Firestore: $error");
    }
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

  /// Displays a dialog to set expense limits for the month.
  /// The expense limits are stored in the month node.
  void showSetLimitsDialog() async {
    final currentUser = user;
    if (currentUser == null) {
      messageDialog("User not found", "Error");
      return;
    }
    final String uid = currentUser.uid;
    // Determine current month (using now).
    DateTime now = DateTime.now();
    final String year = now.year.toString();
    final String month = now.month.toString().padLeft(2, '0');

    final rtdb.DatabaseReference limitsRef =
        rtdb.FirebaseDatabase.instance.ref("$uid/$year/$month/expenseLimits");

    // Query current limits; if not available, use defaults.
    rtdb.DatabaseEvent event = await limitsRef.once();
    Map<String, dynamic> limitsMap = event.snapshot.value != null
        ? Map<String, dynamic>.from(event.snapshot.value as Map)
        : Map<String, dynamic>.from(defaultData["expenseLimits"]);
    // Convert stored decimals to percentages.
    Map<String, double> localLimits = {};
    limitsMap.forEach((key, value) {
      localLimits[key] = (value as num).toDouble() * 100;
    });

    // Create controllers for each expense type.
    Map<String, TextEditingController> controllers = {};
    localLimits.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toStringAsFixed(0));
    });

    bool autoAdjust = true; // default: dynamic adjustment enabled

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Set Expense Limits (Percentages)"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Editable percentage fields.
                  ...localLimits.keys.map((key) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(key),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: controllers[key],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d{0,3}$')),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (val) {
                                if (val.isEmpty) return;
                                double? newVal = double.tryParse(val);
                                // Disallow values below 1 or >= 100.
                                if (newVal == null ||
                                    newVal < 1 ||
                                    newVal >= 100) {
                                  controllers[key]?.text =
                                      localLimits[key]!.toStringAsFixed(0);
                                  return;
                                }
                                setStateDialog(() {
                                  localLimits[key] = newVal;
                                  if (autoAdjust) {
                                    double remaining = 100 - newVal;
                                    double sumOthers = 0;
                                    localLimits.forEach((k, v) {
                                      if (k != key &&
                                          controllers[k]?.text.isNotEmpty ==
                                              true) {
                                        sumOthers += v;
                                      }
                                    });
                                    if (sumOthers > 0) {
                                      localLimits.forEach((k, v) {
                                        if (k != key) {
                                          double adjusted =
                                              (v / sumOthers) * remaining;
                                          localLimits[k] = adjusted;
                                          controllers[k]?.text =
                                              adjusted.toStringAsFixed(0);
                                        }
                                      });
                                    } else {
                                      int countOthers =
                                          localLimits.keys.length - 1;
                                      if (countOthers > 0) {
                                        localLimits.forEach((k, v) {
                                          if (k != key) {
                                            double evenShare =
                                                remaining / countOthers;
                                            localLimits[k] = evenShare;
                                            controllers[k]?.text =
                                                evenShare.toStringAsFixed(0);
                                          }
                                        });
                                      }
                                    }
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  // Auto Adjust checkbox.
                  Row(
                    children: [
                      Checkbox(
                        value: autoAdjust,
                        onChanged: (val) {
                          setStateDialog(() {
                            autoAdjust = val ?? true;
                          });
                        },
                      ),
                      const Text("Auto Adjust"),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  // Validate: no field should be empty.
                  for (var key in localLimits.keys) {
                    if (controllers[key]?.text.isEmpty ?? true) {
                      messageDialog("Please fill in all limits.", "Error");
                      return;
                    }
                  }
                  // When Auto Adjust is off, total must equal 100.
                  double total =
                      localLimits.values.fold(0, (sum, val) => sum + val);
                  if (!autoAdjust && total != 100) {
                    messageDialog(
                        "Total percentage must equal 100. Currently: ${total.toStringAsFixed(0)}",
                        "Error");
                    return;
                  }
                  // Convert percentages to decimals.
                  Map<String, double> finalLimits = {};
                  localLimits.forEach((key, value) {
                    finalLimits[key] = value / 100;
                  });
                  try {
                    await limitsRef.set(finalLimits);
                    Navigator.of(context).pop();
                    messageDialog(
                        "Expense limits updated successfully!", "Success");
                  } catch (error) {
                    debugPrint("Failed to update expense limits: $error");
                    messageDialog("Failed to update expense limits", "Error");
                  }
                },
                child: const Text("Save"),
              ),
            ],
          );
        });
      },
    );
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 12),
              CustomDropdownSearch(
                hint: 'Expense Type',
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
              const SizedBox(height: 20),
              PrimaryButton.outline(
                onPressed: () {
                  showSetLimitsDialog();
                },
                text: 'Set limits',
                color: AppPalette.teal,
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
