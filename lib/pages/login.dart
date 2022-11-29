import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:pinpoint/pages/main_page.dart';
import 'package:pinpoint/pages/register.dart';

import '../keys/keys.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in to PinPoint'),
      ),
      body: SignInScreen(
        showAuthActionSwitch: false,
        headerBuilder: (context, constraints, _) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Icon(
                Icons.place_outlined,
                color: Color(0xFF009fb7),
                size: 120,
              ),
            ),
          );
        },
        sideBuilder: (context, constraints) {
          return const Icon(
            Icons.place_outlined,
            color: Color(0xFF009fb7),
            size: 120,
          );
        },
        footerBuilder: (context, constraints) {
          return MaterialButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegsiterPage(),
                ),
              );
            },
            color: const Color(0xFF009fb7),
            minWidth: (MediaQuery.of(context).size.width / 8) * 7,
            child:
                const Text("Register", style: TextStyle(color: Colors.white)),
          );
        },
        providerConfigs: const [
          EmailProviderConfiguration(),
        ],
        actions: [
          AuthStateChangeAction<SignedIn>(
            (context, state) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MainPage()));
            },
          ),
        ],
      ),
    );
  }
}
