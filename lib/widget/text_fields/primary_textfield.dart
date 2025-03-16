import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fili_money/theme/color.dart';

class PrimaryTextField extends StatefulWidget {
  final String fieldName;
  final TextEditingController controller;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const PrimaryTextField({
    super.key,
    required this.fieldName,
    required this.controller,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  State<PrimaryTextField> createState() => _PrimaryTextFieldState();
}

class _PrimaryTextFieldState extends State<PrimaryTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: widget.errorMessage != null
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
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              // Add a suffix icon if the field should be obscure
              suffixIcon: widget.obscureText
                  ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: AppPalette.teal,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
            ),
          ),
        ),
        if (widget.errorMessage != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              widget.errorMessage!,
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
