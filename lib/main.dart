import 'package:flutter/material.dart';
import 'package:motivation_grade_reports_student/pages/introduction_page.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp ({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      home: Introduction(),
    );
  }
}

