import 'package:flutter/material.dart';
import 'package:motivation_grade_reports_student/pages/introduction_page.dart';
import 'pages/login.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      home: Introduction(),
    );
  }
}
