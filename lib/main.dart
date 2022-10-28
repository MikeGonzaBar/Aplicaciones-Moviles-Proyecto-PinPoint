import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinpoint/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pinpoint/pages/main_page.dart';
import 'package:pinpoint/providers/users_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UsersProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009fb7),
          primary: const Color(0xFF009fb7),
        ),
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Material App',
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const MainPage(),
    );
  }
}
