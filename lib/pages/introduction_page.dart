import 'package:flutter/material.dart';
import 'login.dart'; // Make sure this import points to where StudentHome is defined

// This is a constant to determine if the user is a student or not
 bool isStudent = false;

class Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        child: Column(
          children:[
            ElevatedButton( // Button to navigate to the login screen for staff
            onPressed: () {
              isStudent = false; // Set the constant to false for staff login
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("Login as Staff"),
          ),
          ElevatedButton(// Button to navigate to the login screen for students
            onPressed: () {
              isStudent = true; // Set the constant to true for student login
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: Text("Login as Student"),
          ),
          ],
        ),
      ),
    );
  }
}