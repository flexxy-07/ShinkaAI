import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shinkaai/services/chat_web_service.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ShinkaAI',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Skeletonizer(enabled: isLoading,child: Markdown(data: fullResponse, shrinkWrap: true)),
      ],
    );
  }
}
