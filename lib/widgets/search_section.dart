import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:shinkaai/widgets/search_bar_button.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Where do you want to start ?',
          style: GoogleFonts.ibmPlexMono(
            fontSize: 25  ,
            fontWeight: FontWeight.w400,
            height: 1.2,
            letterSpacing: -0.5,
          )
        ),
        const SizedBox(height: 20), 
        Container(
          width: 700,
          decoration: BoxDecoration(
            color: AppColors.searchBar,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.searchBarBorder)
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search anything',
                    hintStyle: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    SearchBarButton(
                      icon: Icons.auto_awesome_outlined,
                      text: "Focus"
                    ),
                    const SizedBox(width: 8),
                    SearchBarButton(
                      icon: Icons.add_circle_outline,
                      text: "Attach"
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.submitButton,
                        borderRadius: BorderRadius.circular(40)
                      ),
                      child: const Icon(Icons.arrow_forward, color: AppColors.background, size: 16),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}