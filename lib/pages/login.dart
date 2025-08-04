import 'package:flutter/material.dart';
import 'package:motivation_grade_reports_student/pages/register_account.dart';
import 'package:motivation_grade_reports_student/pages/staff_home.dart';
import 'package:motivation_grade_reports_student/pages/student_home.dart';
class LoginScreen extends StatelessWidget {

// Initialize variable
  bool isStudent;
  // Call the constructor for the LoginScreen
  LoginScreen({super.key, required this.isStudent}); // LoginScreen(isStudent = false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),
                
                SizedBox(height: 48),
                Center(
                  child: Text(
                    "LampEye",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 48),
                Text(
                  "Sign in your account",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                Text(
                  "Enter your Account to login for this app.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                SizedBox(height: 32),
                TextField(
                  decoration: InputDecoration(
                    hintText: "email@domain.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Check if it is a student or a staff memeber
                      if (isStudent == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentHomePage(),
                          ),
                        );
                      } else if (isStudent == false) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StaffHomePage(),
                          ),
                        );
                      }
                    },
                    child: Text("Continue", style: TextStyle(fontSize: 16)),
                    
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("or", style: TextStyle(color: Colors.black54)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "By clicking continue, you agree to our ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Terms of Service",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(" and ", style: TextStyle(fontSize: 13)),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Privacy Policy",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.check, color: Colors.black54),
                    label: Text(
                      "Create Account",
                      style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE8DDFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterAccountScreen(isStudent: isStudent)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ); 
  }
}
