import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:motivation_grade_reports_student/Models/staff_class.dart';
import 'package:motivation_grade_reports_student/Models/student_class.dart';
import 'package:motivation_grade_reports_student/Models/constants.dart';
import 'package:motivation_grade_reports_student/services/auth_service.dart';
import 'package:motivation_grade_reports_student/pages/student_home.dart';
import 'package:motivation_grade_reports_student/pages/staff_home.dart';
import 'package:motivation_grade_reports_student/firebase_provider.dart';

class RegisterAccountScreen extends StatefulWidget {
  final bool isStudent; 
  const RegisterAccountScreen({super.key, required this.isStudent});

  @override
  _RegisterAccountScreenState createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final AuthService _authService = AuthService();
  final FirebaseProvider _firebaseProvider = FirebaseProvider();
  DateTime? _selectedBirthdate;
  bool _isLoading = false;
  
  // Selected subjects and grades
  List<String> _selectedSubjects = [];
  String? _selectedGrade;
  List<String> _selectedGrades = []; // For staff - can teach multiple grades
  
  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _saveAccount() async {
    print('_saveAccount function called!'); // Debug print
    // Validation
    if (_nameController.text.isEmpty ||
        _surnameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedBirthdate == null ||
        _selectedSubjects.isEmpty ||
        (widget.isStudent && _selectedGrade == null) ||
        (!widget.isStudent && _selectedGrades.isEmpty)) {
      print('Validation failed - missing fields'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields including birthdate, subjects, and ${widget.isStudent ? 'grade' : 'grades'}')),
      );
      print('Validation failed');
      return;
    }
    print('Hello');
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Starting Firebase Auth registration...');
      // Create Firebase user with email and password
      UserCredential? userCredential = await _authService.signUpWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );
      print('Firebase Auth registration successful!');

      // Get the Firebase Auth UID for the newly created user
      String firebaseUID = userCredential!.user!.uid;

      // Create user data objects (you can save these to Firestore later)
      if (widget.isStudent == true) {
        print('Creating student object...');
        Student newStudent = Student(
          id: firebaseUID, // Use Firebase UID instead of username
          name: _nameController.text,
          surname: _surnameController.text,
          dateOfBirth: _selectedBirthdate ?? DateTime.now(),
          email: _emailController.text,
          phone: _phoneController.text,
          subjects: _selectedSubjects,
          grade: _selectedGrade!,
          age: DateTime.now().year - (_selectedBirthdate?.year ?? 0),
          studentMotivation: {},
          profileImagePath: 'assets/images/userprofile.png', // Default profile image
        );
        print('Student object created successfully!');
        // Save newStudent to Firestore
        print('Saving student to Firestore...');
        await _firebaseProvider.addStudent(newStudent: newStudent);
        print('Student saved to Firestore successfully!');
        
        // Navigate to student home
        print('Navigating to student home...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StudentHomePage()),
        );
      } else {
        print('Creating staff object...');
        // Handle staff registration
        Staff newStaff = Staff(
          id: firebaseUID, // Use Firebase UID instead of username
          name: _nameController.text,
          surname: _surnameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          subjects: _selectedSubjects,
          grades: _selectedGrades,
          dateOfBirth: _selectedBirthdate ?? DateTime.now(),
          profileImagePath: 'assets/images/userprofile.png', // Default profile image
        );
        print('Staff object created successfully!');
        // Save newStaff to Firestore
        print('Saving staff to Firestore...');
        await _firebaseProvider.addStaff(newStaff: newStaff);
        print('Staff saved to Firestore successfully!');
        
        // Navigate to staff home
        print('Navigating to staff home...');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => StaffHomePage()),
        );
      }
      
      print('Registration process completed!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account created successfully!')),
      );
    } catch (e) {
      print('Registration error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      print('Setting loading to false...');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
                // Name
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Type your first name",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color.fromARGB(255, 168, 128, 230), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                SizedBox(height: 20),
                // Surname
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: "Surname",
                    hintText: "Type your surname",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color.fromARGB(255, 168, 128, 230), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                SizedBox(height: 20),
                // Phone number
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone number",
                    hintText: "Type your phone number",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color.fromARGB(255, 168, 128, 230), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                SizedBox(height: 20),
                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Type your email address",
                    suffixIcon: Icon(Icons.close, color: Colors.black54),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: BorderSide(color: Color.fromARGB(255, 168, 128, 230), width: 2),
                    ),
                    labelStyle: TextStyle(color: Color(0xFFD1C7E0)),
                  ),
                ),
                SizedBox(height: 20),
                // Birthdate (DatePicker)
                Text("Birthdate", style: TextStyle(color: Color(0xFFD1C7E0))),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedBirthdate = pickedDate;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD1C7E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, color: Color(0xFFD1C7E0)),
                        SizedBox(width: 12),
                        Text(
                          _selectedBirthdate != null
                              ? "${_selectedBirthdate!.day}/${_selectedBirthdate!.month}/${_selectedBirthdate!.year}"
                              : "Select Birthdate",
                          style: TextStyle(
                            color: _selectedBirthdate != null ? Colors.black : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                // Grade Selection (for students) or Grades Teaching (for staff)
                Text(
                  widget.isStudent ? "Select Grade" : "Select Grades Teaching",
                  style: TextStyle(color: Color(0xFFD1C7E0), fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                if (widget.isStudent)
                  // Single grade selection for students
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD1C7E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGrade,
                        hint: Text("Select your grade"),
                        isExpanded: true,
                        items: grades.map((String grade) {
                          return DropdownMenuItem<String>(
                            value: grade,
                            child: Text("Grade $grade"),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGrade = newValue;
                          });
                        },
                      ),
                    ),
                  )
                else
                  // Multiple grades selection for staff
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD1C7E0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: grades.map((String grade) {
                        final bool isSelected = _selectedGrades.contains(grade);
                        return FilterChip(
                          label: Text("Grade $grade"),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedGrades.add(grade);
                              } else {
                                _selectedGrades.remove(grade);
                              }
                            });
                          },
                          selectedColor: Color.fromARGB(255, 168, 128, 230),
                          backgroundColor: Colors.grey[200],
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(height: 20),
                
                // Subjects Selection
                Text(
                  "Select Subjects",
                  style: TextStyle(color: Color(0xFFD1C7E0), fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFD1C7E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: subjects.map((String subject) {
                      final bool isSelected = _selectedSubjects.contains(subject);
                      return FilterChip(
                        label: Text(subject),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedSubjects.add(subject);
                            } else {
                              _selectedSubjects.remove(subject);
                            }
                          });
                        },
                        selectedColor: Color.fromARGB(255, 168, 128, 230),
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                // Create Username
                TextField(
                  controller: _usernameController,
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
                  controller: _passwordController,
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
                  controller: _confirmPasswordController,
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
                
                // Save Button
                SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 220,
                    height: 60,
                    child: ElevatedButton.icon(
                      icon: _isLoading ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      ) : Icon(Icons.star, color: Colors.white),
                      label: Text(
                        _isLoading ? "Creating Account..." : "Save",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 242, 17, 17),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isLoading ? null : () {
                        print('Button pressed!'); // Debug print
                        _saveAccount();
                      },
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