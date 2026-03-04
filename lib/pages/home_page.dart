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

  @override
  void initState() {
    super.initState();
    ChatWebService().connect();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Row(
        children: [
          // side bar
          SideBar(), // COls :
          Expanded(
            child: Column(
              children: [
                Expanded(child: SearchSection()),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Pro', style: TextStyle(fontSize: 14, color: AppColors.footerGrey)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Enterprise', style: TextStyle(fontSize: 14, color: AppColors.footerGrey)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Store', style: TextStyle(fontSize: 14, color: AppColors.footerGrey)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Blog', style: TextStyle(fontSize: 14, color: AppColors.footerGrey)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('Careers', style: TextStyle(fontSize: 14, color: AppColors.footerGrey)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('English', style: TextStyle(fontSize: 14, color: AppColors.footerGrey)),
                      ),
                    ],
                  ),
                ), // footer
                //search section
                // footer
              ],
            ),
          ),
        ],
      ),
    );
  }
}
