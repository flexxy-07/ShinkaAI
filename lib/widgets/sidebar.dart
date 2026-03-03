import 'package:flutter/material.dart';
import 'package:shinkaai/theme/colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isCollapsed = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: isCollapsed ? 64 : 128,
      height: double.infinity,
      color: const Color.fromRGBO(32, 34, 34, 1),
      child: Column(
        crossAxisAlignment: isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                child: Icon(
                  Icons.auto_awesome_mosaic,
                  color: AppColors.whiteColor,
                  size: 30,
                ),
              ),
              if(!isCollapsed)
              Text(
                "ShinkaAI",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              )

            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Icon(Icons.add, color: AppColors.iconGrey, size: 20),
              ),

              if(!isCollapsed)
              Text(
                "New Chat",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              )
            ],
          ),
          Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Icon(Icons.search, color: AppColors.iconGrey, size: 20),
              ),
              if(!isCollapsed)
              Text(
                "Search",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              )
            ],
          ),

          Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Icon(Icons.language, color: AppColors.iconGrey, size: 20),
              ),
              if(!isCollapsed)
              Text(
                "Language",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              )
            ],
          ),
          Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8  ),
                child: Icon(
                  Icons.auto_awesome,
                  color: AppColors.iconGrey,
                  size: 20,
                ),
              ),
              if(!isCollapsed)
              Text(
                "Settings",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              )
            ],
          ),

          Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Icon(
                  Icons.cloud_outlined,
                  color: AppColors.iconGrey,
                  size: 20,
                ),
              ),
              if(!isCollapsed)
              Text(
                "Cloud",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              )
            ],
          ),

          const Spacer(),
          GestureDetector(
            onTap: (){
              setState(() {
                isCollapsed = !isCollapsed;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Icon(
                isCollapsed? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
                color: AppColors.iconGrey,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),  
        ],
      ),
    );
  }
}
