import 'package:chat_app_project_jieqing/login_screen.dart';
import 'package:chat_app_project_jieqing/registration_screen.dart';
import 'package:flutter/material.dart';

import 'contants.dart';

class WelcomeScreen extends StatefulWidget {
  /// static is to make id associate with this class
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Welcome to ChatApp',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
                onPressed: () {
                  // Go to Login Screen
                  Navigator.pushNamed(
                    context,
                    LoginScreen.id,
                  );
                },
                child: AuthButtonText(textContent: 'Login',)),
            TextButton(
                onPressed: () {
                  // Go to Register Screen
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: AuthButtonText(textContent: 'Register',)),
          ],
        ),
      ),
    );
  }
}
