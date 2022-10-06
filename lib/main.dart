import 'package:flutter/material.dart';
import 'package:pinpoint/pages/login.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xFF009fb7)),
      title: 'Material App',
      home: LoginPage(),
    );
  }
}
