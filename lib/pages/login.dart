import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hello, and welcome to the homepage",style: TextStyle(
          color: const Color.fromARGB(255, 68, 225, 36)
        ),),
      ),
    );
  }
}