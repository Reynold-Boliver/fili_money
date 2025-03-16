import 'package:fili_money/theme/color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool isFilled;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.isFilled = false,
  });

  factory PrimaryButton.outline({
    required String text,
    required VoidCallback onPressed,
    Color color = Colors.blue,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      color: color,
      isFilled: false,
    );
  }

  factory PrimaryButton.filled({
    required String text,
    required VoidCallback onPressed,
    Color color = AppPalette.teal,
  }) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      color: color,
      isFilled: true,
    );
  }

  @override
  PrimaryButtonState createState() => PrimaryButtonState();
}

class PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onPressed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.scale(
          scale: _animation.value,
          child: child,
        );
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: widget.isFilled ? widget.color : Colors.transparent,
          border: Border.all(color: widget.color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: _handleTap,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                color: widget.isFilled ? Colors.white : widget.color,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
