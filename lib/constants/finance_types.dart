import 'package:flutter/material.dart';

const Map<String, Color> categoryExpenseColors = {
  'Essential': Colors.green,
  'Necessary': Colors.orange,
  'Discretionary': Colors.redAccent,
  'Luxury': Colors.blueAccent,
};

final Map<String, String> expenseCategories = const {
  'Housing': 'Essential',
  'Utilities': 'Essential',
  'Food & Groceries': 'Essential',
  'Healthcare': 'Essential',
  'Childcare': 'Essential',
  'Transportation': 'Necessary',
  'Debt Payments': 'Necessary',
  'Savings & Investments': 'Necessary',
  'Insurance (Beyond Home & Auto)': 'Necessary',
  'Personal Care & Well-being': 'Discretionary',
  'Clothing': 'Discretionary',
  'Household Supplies & Maintenance': 'Discretionary',
  'Education & Professional Development': 'Discretionary',
  'Pet Care': 'Discretionary',
  'Entertainment & Recreation': 'Luxury',
  'Gifts & Donations': 'Luxury',
  'Miscellaneous-Personal Spending': 'Luxury',
};

const Map<String, String> incomeCategories = {
  'Salary': 'Earned Income',
  'Freelance': 'Earned Income',
  'Business Income': 'Earned Income',
  'Rental Income': 'Passive Income',
  'Investment Income': 'Passive Income',
  'Royalties': 'Passive Income',
  'Gifts': 'Other Income',
  'Refunds': 'Other Income',
  'Allowance': 'Other Income',
  'Sold Items': 'Other Income',
  'Government Benefits': 'Other Income',
  'Other': 'Other Income',
};

const Map<String, Color> categoryIncomeColors = {
  'Earned Income': Colors.green,
  'Passive Income': Colors.blue,
  'Other Income': Colors.orange,
};

Map<String, Map<String, double>> defaultData = {
  "income": {
    "Salary": 0.0,
    "Freelance": 0.0,
    "Business Income": 0.0,
    "Rental Income": 0.0,
    "Investment Income": 0.0,
    "Royalties": 0.0,
    "Gifts": 0.0,
    "Refunds": 0.0,
    "Allowance": 0.0,
    "Sold Items": 0.0,
    "Government Benefits": 0.0,
    "Other": 0.0
  },
  "expense": {
    "Housing": 0.0,
    "Utilities": 0.0,
    "Food & Groceries": 0.0,
    "Healthcare": 0.0,
    "Childcare": 0.0,
    "Transportation": 0.0,
    "Debt Payments": 0.0,
    "Savings & Investments": 0.0,
    "Insurance (Beyond Home & Auto)": 0.0,
    "Personal Care & Well-being": 0.0,
    "Clothing": 0.0,
    "Household Supplies & Maintenance": 0.0,
    "Education & Professional Development": 0.0,
    "Pet Care": 0.0,
    "Entertainment & Recreation": 0.0,
    "Gifts & Donations": 0.0,
    "Miscellaneous-Personal Spending": 0.0
  }
};