import 'package:flutter/material.dart';
import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:fili_money/theme/color.dart';

class PrimaryDateTextField extends StatelessWidget {
  final String fieldName;
  final TextEditingController controller;
  final String? errorMessage;
  final DateTime? initialDate;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String dateFormat;

  const PrimaryDateTextField({
    super.key,
    required this.fieldName,
    required this.controller,
    this.errorMessage,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.dateFormat = 'yyyy-MM-dd',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field label
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            fieldName,
            style: const TextStyle(
              color: AppPalette.teal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        // Container with custom box decoration
        Container(
          decoration: BoxDecoration(
            border: errorMessage != null
                ? Border.all(color: Colors.red, width: 1.5)
                : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              const BoxShadow(
                color: Colors.white10,
                offset: Offset(-6, -6),
                blurRadius: 6,
              ),
              BoxShadow(
                color: AppPalette.teal.withAlpha(80),
                offset: const Offset(6, 6),
                blurRadius: 6,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            readOnly: true, // Prevent manual editing
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onTap: () async {
              // Show the date picker provided by board_datetime_picker
              final DateTime? pickedDate = await showBoardDateTimePicker(
                context: context,
                pickerType: DateTimePickerType.date,
                initialDate: initialDate ?? DateTime.now(),
                minimumDate: minimumDate ?? DateTime(1970, 1, 1),
                maximumDate: maximumDate ?? DateTime(2050, 12, 31),
              );
              if (pickedDate != null) {
                // Format the selected date using BoardDateFormat and update the text field
                controller.text =
                    BoardDateFormat(dateFormat).format(pickedDate);
              }
            },
          ),
        ),
        // Display error message if available
        if (errorMessage != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
