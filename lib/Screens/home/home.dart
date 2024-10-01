import 'package:flutter/material.dart';
import 'package:healwiz/Screens/history/records.dart';

import '../trending-news/news.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List pages = [
    const HomeScreen(),
    ArticleListScreen(),
    const PredictionHistoryScreen(),
  ];

  int cIndex = 0;
  void onTap(int index) {
    setState(() {
      cIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          backgroundColor: Colors.deepPurple,
          currentIndex: cIndex,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.withOpacity(0.8),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              label: ("Home"),
              icon: Icon(Icons.document_scanner_outlined),
            ),
            BottomNavigationBarItem(
              label: ("News"),
              icon: Icon(Icons.newspaper_sharp),
            ),
            BottomNavigationBarItem(
                label: ("History"), icon: Icon(Icons.history)),
          ],
        ),
        body: pages[cIndex]);
  }
}
