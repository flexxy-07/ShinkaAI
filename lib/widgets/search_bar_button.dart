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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Container(
          decoration: BoxDecoration(
            color: isHovered ? AppColors.proButton :  Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: AppColors.iconGrey, size: 20),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(color: AppColors.textGrey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
