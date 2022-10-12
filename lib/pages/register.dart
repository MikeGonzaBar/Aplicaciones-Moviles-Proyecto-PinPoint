import 'package:flutter/material.dart';
import 'package:pinpoint/pages/main_page.dart';

class RegsiterPage extends StatelessWidget {
  const RegsiterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usrController = TextEditingController();
    final emailController = TextEditingController();
    final pwdController = TextEditingController();
    final pwdConfirmController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register to PinPoint'),
        backgroundColor: const Color(0xFF009fb7),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(
            top: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              informationField(emailController, "Email"),
              informationField(usrController, "Your name"),
              passwordField(pwdController, "Password"),
              passwordField(pwdConfirmController, "Confirm your password"),
              const Padding(
                padding: EdgeInsets.only(left: 22.0),
                child: Text("None of this information can be modified later.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                        fontStyle: FontStyle.italic)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: MaterialButton(
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
                  child: const Text("REGISTER & LOGIN",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding passwordField(TextEditingController pwdController, String labelText) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 10.0),
      child: TextField(
        controller: pwdController,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: labelText,
          border: const UnderlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(8),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF009fb7),
          ),
        ),
      ),
    );
  }

  Padding informationField(
      TextEditingController usrController, String labelText) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, left: 20, right: 20, bottom: 10.0),
      child: TextField(
        controller: usrController,
        decoration: InputDecoration(
          labelText: labelText,
          border: const UnderlineInputBorder(),
          focusedBorder: const OutlineInputBorder(),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF009fb7),
          ),
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
