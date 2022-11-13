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
  int selectedIndex = 0;
  static const List<Widget> _widgetOptions = [
    Feed(), //INDEX 1
    NewPost(), //INDEX 2
    MyPosts() //INDEX 3
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
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
      appBar: AppBar(title: _appbarOptions.elementAt(selectedIndex), actions: [
        selectedIndex == 0
            ? Container()
            : selectedIndex == 1
                ? Container()
                : IconButton(
                    icon: const Icon(Icons.power_settings_new),
                    tooltip: 'Logout',
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (!mounted) return;
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                  ),
      ]),
      body: Align(
          alignment: Alignment.topCenter,
          child: _widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.place_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "New PinPoint",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "My Profile",
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(0xFF009fb7),
        onTap: onItemTapped,
      ),
    );
  }
}
