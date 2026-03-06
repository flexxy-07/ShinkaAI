import 'package:flutter/material.dart';
import 'package:shinkaai/services/chat_web_service.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:shinkaai/widgets/search_section.dart';
import 'package:shinkaai/widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    ChatWebService().connect();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isMobile
          ? AppBar(
              backgroundColor: AppColors.sideNav,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: AppColors.whiteColor),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
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
          if (!isMobile)
            SideBar(isMobile: false),
          Expanded(
            child: Column(
              children: [
                Expanded(child: SearchSection()),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8.0 : 16.0,
                    vertical: isMobile ? 12.0 : 16.0,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isMobile ? 8 : 12,
                    runSpacing: isMobile ? 8 : 0,
                    children: [
                      _FooterLink(text: 'Pro'),
                      _FooterLink(text: 'Enterprise'),
                      _FooterLink(text: 'Store'),
                      _FooterLink(text: 'Blog'),
                      _FooterLink(text: 'Careers'),
                      _FooterLink(text: 'English'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;

  const _FooterLink({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: AppColors.footerGrey),
      ),
    );
  }
}
