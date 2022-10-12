import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinpoint/pages/feed.dart';
import 'package:pinpoint/pages/my_posts.dart';
import 'package:pinpoint/pages/new_post.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = [
    Feed(), //INDEX 1
    NewPost(), //INDEX 2
    MyPosts() //INDEX 3
  ];

  void _onItemTapped(int index) {
    print("Datetime now: ${DateTime.now()}");
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _appbarOptions = [
    Text("PinPoint"),
    Text("New PinPoint"),
    Text("My Pinpoints")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appbarOptions.elementAt(_selectedIndex),
        backgroundColor: const Color(0xFF009fb7),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            label: "PinPoints",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "My Posts",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF009fb7),
        onTap: _onItemTapped,
      ),
    );
  }
}
