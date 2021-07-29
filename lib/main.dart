import 'package:chat_app_project_jieqing/login_screen.dart';
import 'package:chat_app_project_jieqing/registration_screen.dart';
import 'package:chat_app_project_jieqing/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'chat_screen.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
         WelcomeScreen.id: (context) => WelcomeScreen(),
         LoginScreen.id: (context) => LoginScreen(),
         RegistrationScreen.id: (context) => RegistrationScreen(),
         ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}


















