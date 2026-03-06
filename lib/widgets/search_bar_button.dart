import 'package:flutter/material.dart';
import 'package:shinkaai/theme/colors.dart';

class SearchBarButton extends StatefulWidget {
  const SearchBarButton({super.key, required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  State<SearchBarButton> createState() => _SearchBarButtonState();
}

class _SearchBarButtonState extends State<SearchBarButton> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
        },
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: isPressed
                ? AppColors.proButton.withOpacity(0.8)
                : isHovered
                    ? AppColors.proButton
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: isHovered || isPressed
                    ? AppColors.whiteColor
                    : AppColors.iconGrey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  color: isHovered || isPressed
                      ? AppColors.whiteColor
                      : AppColors.textGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
