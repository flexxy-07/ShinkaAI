import 'package:flutter/material.dart';
import 'package:shinkaai/pages/home_page.dart';
import 'package:shinkaai/theme/colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.isMobile});
  final bool isMobile;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  bool isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    // On mobile, always show expanded view in drawer
    final shouldShowExpanded = widget.isMobile ? true : !isCollapsed;
    final sidebarWidth = widget.isMobile
        ? MediaQuery.of(context).size.width * 0.75
        : (isCollapsed ? 64.0 : 220.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarWidth,
      height: double.infinity,
      color: AppColors.sideNav,
      child: Column(
        crossAxisAlignment: shouldShowExpanded
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(height: widget.isMobile ? 8 : 20),
          _buildHeader(shouldShowExpanded),
          SizedBox(height: widget.isMobile ? 16 : 24),
          _buildMenuItem(
            icon: Icons.add,
            text: "New Chat",
            showText: shouldShowExpanded,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.search,
            text: "Search",
            showText: shouldShowExpanded,
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.language,
            text: "Language",
            showText: shouldShowExpanded,
          ),
          _buildMenuItem(
            icon: Icons.auto_awesome,
            text: "Settings",
            showText: shouldShowExpanded,
          ),
          _buildMenuItem(
            icon: Icons.cloud_outlined,
            text: "Cloud",
            showText: shouldShowExpanded,
          ),
          const Spacer(),
          if (!widget.isMobile) _buildCollapseButton(shouldShowExpanded),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader(bool showText) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: showText ? 16 : 0,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: showText
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.submitButton.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.auto_awesome_mosaic,
              color: AppColors.submitButton,
              size: 24,
            ),
          ),
          if (showText) ...[
            const SizedBox(width: 12),
            const Text(
              "ShinkaAI",
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required bool showText,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: showText ? 12 : 0, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: showText ? 12 : 8,
              vertical: 12,
            ),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: showText
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.iconGrey, size: 22),
                if (showText) ...[
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.whiteColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapseButton(bool showText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              isCollapsed = !isCollapsed;
            });
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: showText
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(
                  isCollapsed
                      ? Icons.keyboard_arrow_right
                      : Icons.keyboard_arrow_left,
                  color: AppColors.iconGrey,
                  size: 22,
                ),
                if (showText) ...[
                  const SizedBox(width: 12),
                  const Text(
                    "Collapse",
                    style: TextStyle(color: AppColors.whiteColor, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
