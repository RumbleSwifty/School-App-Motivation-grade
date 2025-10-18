import 'package:flutter/material.dart';
import 'login.dart'; // Make sure this import points to where StudentHome is defined

// This is a constant to determine if the user is a student or not
 bool isStudent = false;

class Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon/Logo Placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: Colors.orange[300]!,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.lightbulb,
                  size: 64,
                  color: Colors.orange[800],
                ),
              ),
              
              SizedBox(height: 32),
              
              // App Title
              Text(
                'LampEye',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                  letterSpacing: 1.5,
                ),
              ),
              
              SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Motivation Tracking System',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange[600],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              
              SizedBox(height: 48),
              
              // Welcome Message
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 32,
                      color: Colors.orange[700],
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Welcome to LampEye!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Track student motivation, create announcements, and build a better learning environment together.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Login Buttons
              Column(
                children: [
                  // Staff Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        isStudent = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen(isStudent: false)),
                        );
                      },
                      icon: Icon(Icons.admin_panel_settings, color: Colors.white),
                      label: Text(
                        'Login as Staff',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Student Login Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        isStudent = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen(isStudent: true)),
                        );
                      },
                      icon: Icon(Icons.school, color: Colors.orange[800]),
                      label: Text(
                        'Login as Student',
                        style: TextStyle(
                          fontSize: 16, 
                          fontWeight: FontWeight.w600,
                          color: Colors.orange[800],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.orange[800],
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.orange[300]!, width: 2),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // Footer Text
              Text(
                'Choose your role to continue',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}