import 'package:flutter/material.dart';
import 'package:fili_money/theme/color.dart';

enum IconsList {
  facebook,
  google,
}

class CircularShadowButton extends StatefulWidget {
  final Offset offset;
  final double iconSize;
  final Widget icon;
  final VoidCallback onPressed;

  const CircularShadowButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.iconSize,
    required this.offset,
  });

  @override
  CircularShadowButtonState createState() => CircularShadowButtonState();
}

class CircularShadowButtonState extends State<CircularShadowButton>
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(70),
              offset: Offset(4, 4),
              blurRadius: 6,
            ),
          ],
        ),
        child: Material(
          shape: const CircleBorder(),
          child: InkWell(
            radius: widget.iconSize * 2,
            onTap: _handleTap,
            splashColor: AppPalette.teal, // Custom splash color
            highlightColor: AppPalette.teal, // Custom highlight color
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              width: widget.iconSize * 2,
              height: widget.iconSize * 2,
              child: Center(
                child: Transform.translate(
                    offset: widget.offset, child: widget.icon),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
