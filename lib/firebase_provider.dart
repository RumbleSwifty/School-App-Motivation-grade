import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motivation_grade_reports_student/Models/staff_class.dart';
import 'package:motivation_grade_reports_student/Models/student_class.dart';

class FirebaseProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addStaff({required Staff newStaff}) async {
    try {
      await _firestore.collection('staff').doc(newStaff.id).set(newStaff.toMap());
      print('Staff added successfully');
    } catch (e) {
      print('Error adding staff: $e');
    }
  }
  Future<void> addStudent({required Student newStudent}) async {
    try {
      await _firestore.collection('students').doc(newStudent.id).set(newStudent.toMap());
      print('Student added successfully');
    } catch (e) {
      print('Error adding student: $e');
    }
  }
}