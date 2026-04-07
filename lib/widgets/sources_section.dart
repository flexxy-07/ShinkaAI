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
  List searchResults = [
    {'title': 'Example Source 1', 'url': 'https://example.com/source1'},
    {'title': 'Example Source 2', 'url': 'https://example.com/source2'},
    {'title': 'Example Source 3', 'url': 'https://example.com/source3'},
  ];

  @override
  void initState() {
    super.initState();
    
    // Check if results already exist (e.g. if navigation was slow)
    if (ChatWebService().lastSearchResults != null) {
      setState(() {
        searchResults = ChatWebService().lastSearchResults!['data'];
        isLoading = false;
      });
    }

    // listen to the search results stream and update the UI when new results arrive
    ChatWebService().searchResultsStream.listen((data) {
      if (mounted) {
        setState(() {
          searchResults = data['data'];
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

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
        const SizedBox(height: 16),
        SizedBox(
          height: isMobile ? 100 : 120,
          child: Skeletonizer(
            enabled: isLoading,
            effect: const ShimmerEffect(
              baseColor: AppColors.cardColor,
              highlightColor: AppColors.searchBarBorder,
              duration: Duration(milliseconds: 800),
            ),
            containersColor: AppColors.background.withOpacity(0.1),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: isMobile ? 150 : 200,
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.searchBarBorder.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AppColors.submitButton.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.link,
                                  color: AppColors.submitButton,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  Uri.tryParse(result['url']?.toString() ?? '')?.host ?? result['url']?.toString() ?? '',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.textGrey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            result['title']?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.whiteColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
