import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UsersProvider with ChangeNotifier {
  final dynamic _user = {};
  dynamic get getUsersList => _user;

  Future<String> registerNewUser(dynamic userObj) async {
    // log('INSIDE PROVIDER');
    String response = '';
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: userObj["email"], password: userObj["password"]);
      // log('USER REGISTERED');
      // log(cred.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        response = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email:') {
        response = 'The email is invalid';
      }
    } catch (e) {
      // print(e);
    }
    if (response == '') {
      FirebaseAuth.instance.currentUser!.updateDisplayName(userObj["username"]);
      response = 'Created';
    }

    notifyListeners();
    return response;
  }

  Future<Type> signInUser(dynamic userObj) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userObj["email"], password: userObj["password"]);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
      }
    }
    return UserCredential;
  }
}
