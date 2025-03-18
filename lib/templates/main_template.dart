import 'package:app_cybersoft/component/appBar.dart';
import 'package:app_cybersoft/component/bottomNav.dart';
import 'package:app_cybersoft/screen/Homepage/home_screen.dart';
import 'package:app_cybersoft/screen/Homepage/learning_screen.dart';
import 'package:app_cybersoft/screen/Homepage/profile_screen.dart';
import 'package:app_cybersoft/screen/Homepage/search_screen.dart';
import 'package:app_cybersoft/screen/Homepage/wishlist_screen.dart';
import 'package:flutter/material.dart';

class MainTemplate extends StatefulWidget {
  const MainTemplate({super.key});

  @override
  State<MainTemplate> createState() => _MainTemplateState();
}

class _MainTemplateState extends State<MainTemplate> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  static final List<Widget> _pages = <Widget>[
    HomeScreen(),
    SearchCoursesScreen(),
    LearningScreen(),
    WishlistScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
