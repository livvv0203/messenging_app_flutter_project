import 'package:chat_app_project_jieqing/chat_screen.dart';
import 'package:chat_app_project_jieqing/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'contants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  // bool showSpinner = false;

  @override
  void initState() {
    // implement initState
    super.initState();
  }

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
                  hintText: 'Enter email',
                  contentPadding: EdgeInsets.all(10.0),
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  contentPadding: EdgeInsets.all(10.0),
                ),
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
              ),
              TextButton(
                  onPressed: () async {
                    setState(() { });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      // if (user != null)
                      // Go to Login Screen
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        // showSpinner = false;
                      });
                    }
                    catch (e) {
                      print(e);
                    }
                  },
                  child: AuthButtonText(textContent: 'Login',)),
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

