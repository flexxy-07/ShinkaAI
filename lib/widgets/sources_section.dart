import 'package:flutter/material.dart';
import 'package:shinkaai/services/chat_web_service.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SourcesSection extends StatefulWidget {
  const SourcesSection({super.key});

  @override
  State<SourcesSection> createState() => _SourcesSectionState();
}

class _SourcesSectionState extends State<SourcesSection> {
  bool isLoading = true;
  List searchResults = [{
  'title': 'Example Source 1',
  'url': 'https://example.com/source1'
  },
  {
  'title': 'Example Source 2',  
  'url': 'https://example.com/source2'
  },
  {
  'title': 'Example Source 3',
  'url': 'https://example.com/source3'
  }
  ];

  @override
  void initState() {
    super.initState();
    // listen to the search results stream and update the UI when new results arrive
    ChatWebService().searchResultsStream.listen((data) {
      setState(() {
        searchResults = data['data'];
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    // Calculate responsive card width
    int crossAxisCount;
    double cardAspectRatio;
    
    if (isMobile) {
      crossAxisCount = 2;
      cardAspectRatio = 0.9;
    } else if (isTablet) {
      crossAxisCount = 3;
      cardAspectRatio = 1.0;
    } else {
      crossAxisCount = 4;
      cardAspectRatio = 1.1;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.source,
                color: AppColors.submitButton,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Sources',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Skeletonizer(
          enabled: isLoading,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: isMobile ? 8 : 12,
              mainAxisSpacing: isMobile ? 8 : 12,
              childAspectRatio: cardAspectRatio,
            ),
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final result = searchResults[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.searchBarBorder.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.submitButton.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.link,
                          color: AppColors.submitButton,
                          size: isMobile ? 20 : 24,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 12),
                      Text(
                        result['title']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result['url']?.toString() ?? '',
                        style: TextStyle(
                          fontSize: isMobile ? 10 : 11,
                          color: AppColors.textGrey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
