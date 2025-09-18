import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motivation_grade_reports_student/pages/introduction_page.dart';
import 'package:motivation_grade_reports_student/pages/student_home.dart';
import 'package:motivation_grade_reports_student/pages/staff_home.dart';
import 'package:motivation_grade_reports_student/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  final bool isStudent;
  
  const AuthWrapper({super.key, required this.isStudent});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          // Navigate based on user type (you might want to store this in Firestore)
          return isStudent ? StudentHomePage() : StaffHomePage();
        }
        
        // If user is not logged in, show introduction page
        return Introduction();
      },
    );
  }
}
