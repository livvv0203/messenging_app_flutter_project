import 'package:chat_app_project_jieqing/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'contants.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  hintText: 'Register with your email address',
                  contentPadding: EdgeInsets.all(10.0),
                ),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Create a password',
                  contentPadding: EdgeInsets.all(10.0),
                ),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              TextButton(
                  onPressed: () async {
                    setState(() { });
                    // Go to Login Screen
                    try {
                      final newUser = await _auth.createUserWithEmailAndPassword(
                          email: email, password: password);
                      Navigator.pushNamed(context, ChatScreen.id);
                      // Set Loading Spinner to STOP
                      // setState(() {
                      //   showSpinner = false;
                      // });
                    } catch (e) {
                      print(e);
                    }
                    // print(email);
                    // print(password);
                  },
                  child: AuthButtonText(textContent: 'Register',)),
              TextButton(
                  onPressed: () {
                    // Go to Login Screen
                    _auth.signOut();
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  child: AuthButtonText(textContent: 'Cancel',)),
            ],
          ),
        ),
    );
  }
}
