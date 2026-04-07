import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shinkaai/services/chat_web_service.dart';
import 'package:shinkaai/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AnswerSection extends StatefulWidget {
  const AnswerSection({super.key});

  @override
  State<AnswerSection> createState() => _AnswerSectionState();
}

class _AnswerSectionState extends State<AnswerSection> {
  bool isLoading = true;
  String fullResponse = '''
  ## Strongest Muscle in the Human Body

The **masseter muscle** is considered the strongest muscle in the human body.

### Location
- It is located in the **jaw**, on the sides of the face.

### Function
- The masseter is responsible for **chewing (mastication)**.
- It helps **close the jaw** when biting or grinding food.

### Strength
- It can exert a force of up to **200 pounds (≈90 kg) on the molars**.

### Interesting Fact
- Although the **gluteus maximus** is the largest muscle and the **heart** is the most hardworking muscle, the **masseter is the strongest relative to its size**.



''';
  Timer? _throttleTimer;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Check for existing content chunks
    if (ChatWebService().contentChunks.isNotEmpty) {
      setState(() {
        isLoading = false;
        fullResponse = ChatWebService().contentChunks.join('');
      });
    }
    
    _listenToContentStream();
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _listenToContentStream() {
    StringBuffer buffer = StringBuffer();
    // Add existing chunks to buffer
    if (ChatWebService().contentChunks.isNotEmpty) {
      buffer.write(ChatWebService().contentChunks.join(''));
    }

    ChatWebService().contentStream.listen((data) {
      if (mounted) {
        if (isLoading) {
          setState(() {
            isLoading = false;
            fullResponse = '';
          });
        }
        
        if (data['data'] != null) {
          buffer.write(data['data'].toString());
          // print('Received content chunk: ${data['data']}');
        }

        if (_throttleTimer == null || !_throttleTimer!.isActive) {
          _throttleTimer = Timer(const Duration(milliseconds: 100), () {
            if (mounted) {
              setState(() {
                fullResponse = buffer.toString();
              });
              // Auto-scroll to the bottom as content grows
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              }
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16.0 : isTablet ? 32.0 : 48.0,
        0,
        isMobile ? 16.0 : isTablet ? 32.0 : 48.0,
        isMobile ? 16.0 : 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'ShinkaAI',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 16.0 : 20.0),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.searchBarBorder.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Skeletonizer(
                enabled: isLoading,
                effect: const ShimmerEffect(
                  baseColor: AppColors.cardColor,
                  highlightColor: AppColors.searchBarBorder,
                  duration: Duration(milliseconds: 1000),
                ),
                child: Stack(
                  children: [
                    Markdown(
                      controller: _scrollController,
                      data: fullResponse,
                      physics: const BouncingScrollPhysics(),
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          height: 1.6,
                          color: AppColors.whiteColor.withOpacity(0.9),
                        ),
                        h1: TextStyle(
                          fontSize: isMobile ? 22 : 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                          height: 1.3,
                        ),
                        h2: TextStyle(
                          fontSize: isMobile ? 20 : 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor,
                          height: 1.3,
                        ),
                        h3: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whiteColor,
                          height: 1.3,
                        ),
                        listBullet: const TextStyle(color: AppColors.submitButton),
                        code: TextStyle(
                          backgroundColor: AppColors.background,
                          color: AppColors.submitButton,
                          fontSize: isMobile ? 13 : 14,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (!isLoading)
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: const TypingIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.submitButton.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Text(
          '▮',
          style: TextStyle(color: AppColors.submitButton, fontSize: 16),
        ),
      ),
    );
  }
}
