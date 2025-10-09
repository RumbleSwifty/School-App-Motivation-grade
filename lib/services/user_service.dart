import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/staff_class.dart';
import '../Models/student_class.dart';

/// Firebase service for managing user data (Staff and Students)
/// This service handles CRUD operations for both staff and student profiles
/// in Firestore, with role-based data access
class UserService {
  static const String _staffCollection = 'staff';
  static const String _studentsCollection = 'students';
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  // ========== STAFF METHODS ==========

  /// Fetch current logged-in staff member's profile
  /// Returns null if user is not staff or profile doesn't exist
  Future<Staff?> getCurrentStaff() async {
    if (currentUser == null) return null;
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_staffCollection)
          .doc(currentUser!.uid)
          .get();
          
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Staff.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error fetching current staff: $e');
      throw Exception('Failed to fetch staff profile');
    }
  }

  /// Create or update staff profile
  Future<void> saveStaffProfile(Staff staff) async {
    try {
      await _firestore
          .collection(_staffCollection)
          .doc(staff.id)
          .set(staff.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving staff profile: $e');
      throw Exception('Failed to save staff profile');
    }
  }

  /// Get staff member by ID
  Future<Staff?> getStaffById(String staffId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_staffCollection)
          .doc(staffId)
          .get();
          
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Staff.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error fetching staff by ID: $e');
      throw Exception('Failed to fetch staff profile');
    }
  }

  /// Get all staff members (admin function)
  Future<List<Staff>> getAllStaff() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_staffCollection)
          .get();
          
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Staff.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching all staff: $e');
      throw Exception('Failed to fetch staff list');
    }
  }

  // ========== STUDENT METHODS ==========

  /// Fetch current logged-in student's profile
  /// Returns null if user is not student or profile doesn't exist
  Future<Student?> getCurrentStudent() async {
    print('getCurrentStudent called');
    if (currentUser == null) {
      print('No current user found');
      return null;
    }
    
    print('Current user UID: ${currentUser!.uid}');
    
    try {
      print('Fetching document from students collection...');
      DocumentSnapshot doc = await _firestore
          .collection(_studentsCollection)
          .doc(currentUser!.uid)
          .get();
          
      print('Document exists: ${doc.exists}');
      if (doc.exists) {
        print('Document data: ${doc.data()}');
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Student student = Student.fromMap(data);
        print('Student created successfully: ${student.name}');
        return student;
      } else {
        print('No document found for UID: ${currentUser!.uid}');
        return null;
      }
    } catch (e) {
      print('Error fetching current student: $e');
      print('Error type: ${e.runtimeType}');
      throw Exception('Failed to fetch student profile: $e');
    }
  }

  /// Create or update student profile
  Future<void> saveStudentProfile(Student student) async {
    try {
      await _firestore
          .collection(_studentsCollection)
          .doc(student.id)
          .set(student.toMap(), SetOptions(merge: true));
    } catch (e) {
      print('Error saving student profile: $e');
      throw Exception('Failed to save student profile');
    }
  }

  /// Get student by ID
  Future<Student?> getStudentById(String studentId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_studentsCollection)
          .doc(studentId)
          .get();
          
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Student.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error fetching student by ID: $e');
      throw Exception('Failed to fetch student profile');
    }
  }

  /// Get all students in a specific grade (staff function)
  Future<List<Student>> getStudentsByGrade(String grade) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_studentsCollection)
          .where('grade', isEqualTo: grade)
          .get();
          
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Student.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching students by grade: $e');
      throw Exception('Failed to fetch students');
    }
  }

  /// Get all students (admin function)
  Future<List<Student>> getAllStudents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(_studentsCollection)
          .get();
          
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Student.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching all students: $e');
      throw Exception('Failed to fetch students list');
    }
  }

  // ========== UTILITY METHODS ==========

  /// Update student motivation data
  Future<void> updateStudentMotivation(String studentId, Map<DateTime, double> motivationData) async {
    try {
      // Convert DateTime keys to ISO strings for Firestore
      Map<String, double> firestoreMotivationData = motivationData.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      );

      await _firestore
          .collection(_studentsCollection)
          .doc(studentId)
          .update({'studentMotivation': firestoreMotivationData});
    } catch (e) {
      print('Error updating student motivation: $e');
      throw Exception('Failed to update motivation data');
    }
  }

  /// Update staff profile image
  Future<void> updateStaffProfileImage(String staffId, String? imagePath) async {
    try {
      await _firestore
          .collection(_staffCollection)
          .doc(staffId)
          .update({'profileImagePath': imagePath});
    } catch (e) {
      print('Error updating staff profile image: $e');
      throw Exception('Failed to update profile image');
    }
  }

  /// Update student profile image
  Future<void> updateStudentProfileImage(String studentId, String? imagePath) async {
    try {
      await _firestore
          .collection(_studentsCollection)
          .doc(studentId)
          .update({'profileImagePath': imagePath});
    } catch (e) {
      print('Error updating student profile image: $e');
      throw Exception('Failed to update profile image');
    }
  }

  /// Search students by name (for staff)
  Future<List<Student>> searchStudentsByName(String searchTerm) async {
    try {
      // Note: This is a simple search. For more complex search, consider using Algolia
      QuerySnapshot querySnapshot = await _firestore
          .collection(_studentsCollection)
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff')
          .get();
          
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Student.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error searching students: $e');
      throw Exception('Failed to search students');
    }
  }

  /// Delete user profile (admin function)
  Future<void> deleteUserProfile(String userId, String userType) async {
    try {
      String collection = userType == 'staff' ? _staffCollection : _studentsCollection;
      
      await _firestore.collection(collection).doc(userId).delete();
    } catch (e) {
      print('Error deleting user profile: $e');
      throw Exception('Failed to delete user profile');
    }
  }

}