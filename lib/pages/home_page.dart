import 'package:flutter/material.dart';
import 'package:shinkaai/widgets/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          // side bar 
          SideBar()
,          // COls :
          Column(
            children: [
              //search section
              // footer
            ],
          ),
        ],
      ),
    );
  }
}
