import 'package:flutter/material.dart';

class AuthButtonText extends StatelessWidget {

  final String textContent;
  AuthButtonText({required this.textContent});

  @override
  Widget build(BuildContext context) {
    return Text(
      textContent,
      style: TextStyle(
        fontSize: 20.0,
      ),
    );
  }
}