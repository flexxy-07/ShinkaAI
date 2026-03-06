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
  @override
  void initState() {
    super.initState();
    // listen to the content stream and update the fullResponse when new data arrives
    ChatWebService().contentStream.listen((data) {
      if(isLoading){
        fullResponse = '';
      }
      setState(() {
        fullResponse += data['data'] ?? '';
        isLoading = false;
      });
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
        Container(
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
            child: Markdown(
              data: fullResponse,
              shrinkWrap: true,
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
                listBullet: const TextStyle(
                  color: AppColors.submitButton,
                ),
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
          ),
        ),
      ],
    );
  }
}
