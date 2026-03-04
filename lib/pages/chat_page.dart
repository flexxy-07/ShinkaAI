import 'package:flutter/material.dart';
import 'package:shinkaai/widgets/answer_section.dart';
import 'package:shinkaai/widgets/sidebar.dart';
import 'package:shinkaai/widgets/sources_section.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key, required this.question});
  final String question ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        SideBar(),
        const SizedBox(width: 100 ,),
         Expanded(
           child: SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(24.0),
               child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24,),
                  SourcesSection(),
                  const SizedBox(height: 24,),
                  AnswerSection()
                  // sources
                  // answer section
             
                ],
               ),
             ),
           ),
         )

      ],),
    );
  }
}