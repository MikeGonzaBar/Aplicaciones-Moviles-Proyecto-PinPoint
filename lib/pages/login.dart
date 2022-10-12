import 'package:flutter/material.dart';
import 'package:pinpoint/pages/main_page.dart';
import 'package:pinpoint/pages/register.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usrController = TextEditingController();
    final pwdController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in to PinPoint'),
        backgroundColor: const Color(0xFF009fb7),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Icon(
                  Icons.place_outlined,
                  color: Color(0xFF009fb7),
                  size: 120,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                child: TextField(
                  controller: usrController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: UnderlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 20, right: 20, bottom: 10.0),
                child: TextField(
                  controller: pwdController,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: UnderlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    );
                },
                color: const Color(0xFF009fb7),
                minWidth: (MediaQuery.of(context).size.width / 8) * 7,
                child: const Text(
                  "LOG IN",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Divider(
                  thickness: 1,
                  indent: (MediaQuery.of(context).size.width / 20),
                  endIndent: (MediaQuery.of(context).size.width / 20),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context)
                    ..pop()
                    ..push(
                      MaterialPageRoute(
                        builder: (context) => const RegsiterPage(),
                      ),
                    );
                },
                color: const Color(0xFF009fb7),
                minWidth: (MediaQuery.of(context).size.width / 8) * 7,
                child: const Text("REGISTER",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
