import 'package:flutter/material.dart';
import 'package:pinpoint/pages/main_page.dart';
import 'package:pinpoint/providers/users_provider.dart';
import 'package:provider/provider.dart';

class RegsiterPage extends StatefulWidget {
  const RegsiterPage({super.key});

  @override
  State<RegsiterPage> createState() => _RegsiterPageState();
}

class _RegsiterPageState extends State<RegsiterPage> {
  final usrController = TextEditingController();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final pwdConfirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String isValid = "";
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
                  onPressed: () async {
                    isValid = await _register(
                        usrController.text,
                        emailController.text,
                        pwdController.text,
                        pwdConfirmController.text);
                    setState(() {});
                    if (!mounted) return;
                    if (isValid == 'Created') {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    } else if (isValid ==
                        "The account already exists for that email.") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isValid),
                          action: SnackBarAction(
                            label: 'Ok',
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Please verify your information'),
                        action: SnackBarAction(
                          label: 'Ok',
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                          },
                        ),
                      ));
                    }
                  },
                  color: const Color(0xFF009fb7),
                  minWidth: (MediaQuery.of(context).size.width / 8) * 7,
                  child: const Text("Register",
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

  Future<String> _register(user, email, password, confPassword) async {
    if (password != confPassword ||
        user == '' ||
        email == '' ||
        password == '' ||
        confPassword == '') {
      return "";
    }
    dynamic userObj = {'username': user, 'email': email, 'password': password};

    String response =
        await context.read<UsersProvider>().registerNewUser(userObj);

    if (response == 'Created') {
      if (mounted) {
        await context.read<UsersProvider>().signInUser(userObj);
      }
    }
    return response;
  }
}
