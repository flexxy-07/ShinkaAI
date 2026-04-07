import 'package:flutter/material.dart';
import 'package:shinkaai/pages/home_page.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:shinkaai/widgets/answer_section.dart';
import 'package:shinkaai/widgets/sidebar.dart';
import 'package:shinkaai/widgets/sources_section.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.question});
  final String question;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.sideNav,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_mosaic,
                    color: AppColors.whiteColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "ShinkaAI",
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: AppColors.whiteColor),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false,
                    );
                  },
                ),
              ],
            )
          : null,
      drawer: isMobile
          ? Drawer(
              backgroundColor: AppColors.sideNav,
              child: const SideBar(isMobile: true),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile) SideBar(isMobile: false),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    isMobile ? 16.0 : isTablet ? 32.0 : 48.0,
                    isMobile ? 16.0 : 32.0,
                    isMobile ? 16.0 : isTablet ? 32.0 : 48.0,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              question,
                              style: TextStyle(
                                fontSize: isMobile ? 24 : isTablet ? 28 : 32,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                          ),
                          if (!isMobile)
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                  (route) => false,
                                );
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text("New Chat"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.submitButton,
                                foregroundColor: AppColors.whiteColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const SourcesSection(),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Expanded(child: AnswerSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
