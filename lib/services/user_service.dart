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
  static const String _userRolesCollection = 'userRoles';
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Check if current user is a staff member
  /// Returns true if user has staff role, false otherwise
  Future<bool> isStaff() async {
    if (currentUser == null) return false;
    
    try {
      DocumentSnapshot roleDoc = await _firestore
          .collection(_userRolesCollection)
          .doc(currentUser!.uid)
          .get();
          
      if (roleDoc.exists) {
        Map<String, dynamic> data = roleDoc.data() as Map<String, dynamic>;
        return data['role'] == 'staff';
      }
      return false;
    } catch (e) {
      print('Error checking user role: $e');
      return false;
    }
  }

  /// Check if current user is a student
  /// Returns true if user has student role, false otherwise
  Future<bool> isStudent() async {
    if (currentUser == null) return false;
    
    try {
      DocumentSnapshot roleDoc = await _firestore
          .collection(_userRolesCollection)
          .doc(currentUser!.uid)
          .get();
          
      if (roleDoc.exists) {
        Map<String, dynamic> data = roleDoc.data() as Map<String, dynamic>;
        return data['role'] == 'student';
      }
      return false;
    } catch (e) {
      print('Error checking user role: $e');
      return false;
    }
  }

  /// Get user role as string ('staff', 'student', or 'unknown')
  Future<String> getUserRole() async {
    if (currentUser == null) return 'unknown';
    
    try {
      DocumentSnapshot roleDoc = await _firestore
          .collection(_userRolesCollection)
          .doc(currentUser!.uid)
          .get();
          
      if (roleDoc.exists) {
        Map<String, dynamic> data = roleDoc.data() as Map<String, dynamic>;
        return data['role'] ?? 'unknown';
      }
      return 'unknown';
    } catch (e) {
      print('Error getting user role: $e');
      return 'unknown';
    }
  }

  /// Set user role during registration
  /// Should be called after successful user creation
  Future<void> setUserRole(String userId, String role) async {
    try {
      await _firestore.collection(_userRolesCollection).doc(userId).set({
        'role': role,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error setting user role: $e');
      throw Exception('Failed to set user role');
    }
  }

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
    if (currentUser == null) return null;
    
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_studentsCollection)
          .doc(currentUser!.uid)
          .get();
          
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Student.fromMap(data);
      }
      return null;
    } catch (e) {
      print('Error fetching current student: $e');
      throw Exception('Failed to fetch student profile');
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
  Future<void> updateStudentMotivation(String studentId, Map<DateTime, int> motivationData) async {
    try {
      // Convert DateTime keys to ISO strings for Firestore
      Map<String, int> firestoreMotivationData = motivationData.map(
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
      await _firestore.collection(_userRolesCollection).doc(userId).delete();
    } catch (e) {
      print('Error deleting user profile: $e');
      throw Exception('Failed to delete user profile');
    }
  }

  /// Listen to real-time changes for current user
  Stream<dynamic> getCurrentUserStream() {
    if (currentUser == null) return Stream.empty();
    
    return _firestore
        .collection(_userRolesCollection)
        .doc(currentUser!.uid)
        .snapshots()
        .asyncMap((roleDoc) async {
          if (!roleDoc.exists) return null;
          
          Map<String, dynamic> roleData = roleDoc.data() as Map<String, dynamic>;
          String role = roleData['role'];
          
          if (role == 'staff') {
            return await getCurrentStaff();
          } else if (role == 'student') {
            return await getCurrentStudent();
          }
          return null;
        });
  }
}