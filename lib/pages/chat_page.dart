import 'package:flutter/material.dart';
import 'package:shinkaai/services/chat_web_service.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:shinkaai/widgets/answer_section.dart';
import 'package:shinkaai/widgets/sidebar.dart';
import 'package:shinkaai/widgets/sources_section.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.question});
  final String question;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    ChatWebService().chat(widget.question);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
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
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: isTablet ? 900 : 1100),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile
                        ? 16.0
                        : isTablet
                        ? 32.0
                        : 48.0,
                    vertical: isMobile ? 16.0 : 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.question,
                        style: TextStyle(
                          fontSize: isMobile
                              ? 24
                              : isTablet
                              ? 28
                              : 32,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 32),
                      const SourcesSection(),
                      SizedBox(height: isMobile ? 20 : 32),
                      const AnswerSection(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
