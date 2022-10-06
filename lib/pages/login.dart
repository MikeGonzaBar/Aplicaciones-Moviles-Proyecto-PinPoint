import 'package:flutter/material.dart';

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
              Padding(
                padding: const EdgeInsets.all(25.0),
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
                  decoration: InputDecoration(
                    labelText: "Username or Email",
                    border: const UnderlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
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
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const UnderlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {},
                color: Color(0xFF009fb7),
                minWidth: (MediaQuery.of(context).size.width / 8) * 7,
                child: Text("LOG IN"),
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
                onPressed: () {},
                color: Color(0xFF009fb7),
                minWidth: (MediaQuery.of(context).size.width / 8) * 7,
                child: Text("REGISTER"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
