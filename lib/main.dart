import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:pinpoint/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pinpoint/pages/main_page.dart';
import 'package:pinpoint/providers/comments_provider.dart';
import 'package:pinpoint/providers/images_provider.dart';
import 'package:pinpoint/providers/posts_provider.dart';
import 'package:pinpoint/providers/users_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UsersProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PostsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ImagesProvider(),
        )
      ],
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
      title: 'PinPoint',
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const MainPage(),
    );
  }
}
