import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/pages/feed.dart';
import 'package:pinpoint/pages/login.dart';
import 'package:pinpoint/pages/my_posts.dart';
import 'package:pinpoint/pages/new_post.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    Feed(), //INDEX 1
    NewPost(), //INDEX 2
    MyPosts() //INDEX 3
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _appbarOptions = [
    Text("PinPoint"),
    Text("New PinPoint"),
    Text("My Profile")
  ];

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {}
    return Scaffold(
      appBar: AppBar(title: _appbarOptions.elementAt(_selectedIndex), actions: [
        _selectedIndex == 0
            ? IconButton(
                icon: const Icon(Icons.replay_outlined),
                tooltip: 'Refresh feed',
                onPressed: () {
                  print("BUTTON PRESSED REFRESH");
                },
              )
            : _selectedIndex == 1
                ? Container()
                : IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    tooltip: 'Logout',
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
      ]),
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
            label: "My Profile",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF009fb7),
        onTap: _onItemTapped,
      ),
    );
  }
}
