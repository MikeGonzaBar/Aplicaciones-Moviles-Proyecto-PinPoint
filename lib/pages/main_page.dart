import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pinpoint/pages/feed.dart';
import 'package:pinpoint/pages/my_posts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Feed(),
    // Text(
    //   //CHANGE ALL THESE STATES FOR THE NEW WIDGETS
    //   'Index 0: PinPoints',
    //   style: optionStyle,
    // ),
    Text(
      'Index 1: New PinPoint',
      style: optionStyle,
    ),
    MyPosts()
    // Text(
    //   'Index 2: My Posts',
    //   style: optionStyle,
    // ),
  ];

  void _onItemTapped(int index) {
    print("Datetime now: ${DateTime.now()}");
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _appbarOptions = <Widget>[
    Text("PinPoint"),
    Text("Nuevo PinPoint"),
    Text("Mis Pinpoints")
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
