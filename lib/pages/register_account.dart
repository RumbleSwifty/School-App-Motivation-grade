import 'package:flutter/material.dart';

class RegisterAccountScreen extends StatelessWidget {
  final bool isStudent; 
  const RegisterAccountScreen({super.key, required this.isStudent});
// LoginScreen({super.key, required this.isStudent}); 

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Color(0xFFD1C7E0)),
    );

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
                // Status bar mimic
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('register account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),

                SizedBox(height: 32),
                // Create Username
                TextField(
                  decoration: InputDecoration(
                    labelText: "Create Username",
                    hintText: "Type in your Username",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color(0xFFD1C7E0), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                SizedBox(height: 20),
                // New Password
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    hintText: "type password",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color(0xFFD1C7E0), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                SizedBox(height: 20),
                // Confirm New Password
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    hintText: "type password",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color(0xFFD1C7E0), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                
                // Continue Button
                SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.star, color: Colors.white),
                      label: Text(
                        "Continue",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {},
                    ),
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