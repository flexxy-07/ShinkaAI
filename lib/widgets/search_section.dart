import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shinkaai/pages/chat_page.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:shinkaai/widgets/search_bar_button.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Responsive width
    final searchBarWidth = isMobile
        ? screenWidth - 32
        : isTablet
        ? screenWidth * 0.8
        : 700.0;

    // Responsive font size
    final titleFontSize = isMobile
        ? 20.0
        : isTablet
        ? 22.0
        : 25.0;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16.0 : 24.0,
            vertical: isMobile ? 20.0 : 32.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Where do you want to start?',
                style: GoogleFonts.ibmPlexMono(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w400,
                  height: 1.3,
                  letterSpacing: -0.5,
                ),
                textAlign: isMobile ? TextAlign.center : TextAlign.left,
              ),
              SizedBox(height: isMobile ? 24 : 32),
              Container(
                width: searchBarWidth,
                constraints: const BoxConstraints(maxWidth: 700),
                decoration: BoxDecoration(
                  color: AppColors.searchBar,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.searchBarBorder,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 14.0 : 18.0),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 15,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Search anything',
                          hintStyle: TextStyle(
                            color: AppColors.textGrey,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        maxLines: null,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 10.0 : 12.0,
                        0,
                        isMobile ? 10.0 : 12.0,
                        isMobile ? 10.0 : 12.0,
                      ),
                      child: Row(
                        children: [
                          if (!isMobile) ...[
                            const SearchBarButton(
                              icon: Icons.auto_awesome_outlined,
                              text: "Focus",
                            ),
                            const SizedBox(width: 8),
                            const SearchBarButton(
                              icon: Icons.add_circle_outline,
                              text: "Attach",
                            ),
                          ],
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              final query = _controller.text.trim();
                              if (query.isNotEmpty) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatPage(question: query),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(isMobile ? 14 : 16),
                              decoration: BoxDecoration(
                                color: AppColors.submitButton,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.submitButton.withOpacity(
                                      0.3,
                                    ),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                color: AppColors.background,
                                size: isMobile ? 18 : 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
