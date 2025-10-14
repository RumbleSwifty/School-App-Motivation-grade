import 'package:flutter/material.dart';
import 'package:motivation_grade_reports_student/services/auth_service.dart';
import 'package:motivation_grade_reports_student/services/user_service.dart';
import 'package:motivation_grade_reports_student/Models/student_class.dart';
import 'package:motivation_grade_reports_student/pages/introduction_page.dart';
import 'package:motivation_grade_reports_student/pages/view_announcements_page.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Student? currentStudent;
  double dailyMotivation = 0.5;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load current student data from Firebase
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      print('Loading user data...');
      print('Current user: ${_authService.currentUser?.uid}');
      currentStudent = await _userService.getCurrentStudent();
      print('Student loaded: ${currentStudent?.name ?? 'null'}');
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Introduction()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.purple))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Custom Profile Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple[200]!),
                      ),
                      child: Row(
                        children: [
                          // Profile Image
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: currentStudent?.profileImagePath != null
                                ? AssetImage(currentStudent!.profileImagePath!)
                                : AssetImage('assets/images/userprofile.png'),
                            backgroundColor: Colors.purple[100],
                          ),
                          SizedBox(width: 16),
                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentStudent != null 
                                      ? '${currentStudent!.name} ${currentStudent!.surname}'
                                      : 'Loading...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  currentStudent != null 
                                      ? 'Grade ${currentStudent!.grade}'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.purple[600],
                                  ),
                                ),
                                if (currentStudent != null && currentStudent!.subjects.isNotEmpty)
                                  Text(
                                    currentStudent!.subjects.join(', '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Notification button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewAnnouncementsPage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.purple[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.purple[800],
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Motivation Sliders Section
                    Text(
                      'Track Your Motivation',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    
                    // Daily Motivation
                    Text('Daily Motivation'),
                    Slider(
                      value: dailyMotivation,
                      onChanged: (value) => setState(() => dailyMotivation = value),
                      label: (dailyMotivation * 10).toString(),
                      divisions: 40,
                      activeColor: Colors.purple,
                      inactiveColor: Colors.purple[100],
                    ),
                    
                    
                    SizedBox(height: 32),
                    
                    // Action Buttons
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Implement add material functionality
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Add Material feature coming soon!')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            ),
                            child: Text(
                              '+ Add Material',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          
                          SizedBox(height: 16),
                          
                          ElevatedButton(
                            onPressed: _hasSubmittedToday() ? null : _submitMotivation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _hasSubmittedToday() ? Colors.grey : Colors.purple,
                              foregroundColor: Colors.white,
                              shape: StadiumBorder(),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                            ),
                            child: Text(
                              _hasSubmittedToday() ? 'Already Submitted Today' : 'Submit Motivation',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Settings and logout section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            // TODO: Navigate to profile page
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Profile page coming soon!')),
                            );
                          },
                          icon: Icon(Icons.person, color: Colors.purple),
                          label: Text('Profile', style: TextStyle(color: Colors.purple)),
                        ),
                        TextButton.icon(
                          onPressed: _signOut,
                          icon: Icon(Icons.logout, color: Colors.red),
                          label: Text('Sign Out', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  /// Check if user has already submitted motivation for today
  bool _hasSubmittedToday() {
    if (currentStudent == null) return false;
    
    DateTime today = DateTime.now();
    String todayDateOnly = "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
    
    // Check if there's any submission for today
    for (DateTime submissionDate in currentStudent!.studentMotivation.keys) {
      String submissionDateOnly = "${submissionDate.year}-${submissionDate.month.toString().padLeft(2, '0')}-${submissionDate.day.toString().padLeft(2, '0')}";
      if (submissionDateOnly == todayDateOnly) {
        return true;
      }
    }
    return false;
  }

  /// Submit current motivation levels to Firebase
  Future<void> _submitMotivation() async {
    if (currentStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Student profile not loaded')),
      );
      return;
    }

    // Check if user has already submitted today
    if (_hasSubmittedToday()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have already submitted your motivation for today!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Add to student motivation data
      Map<DateTime, double> updatedMotivation = Map.from(currentStudent!.studentMotivation);
      // Convert slider value (0-1) to motivation scale (0-10) with one decimal precision
      double motivationValue = double.parse((dailyMotivation * 10).toStringAsFixed(1));
      updatedMotivation[DateTime.now()] = motivationValue;

      await _userService.updateStudentMotivation(currentStudent!.id, updatedMotivation);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Motivation submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Reload user data to reflect changes
      await _loadUserData();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting motivation: ${e.toString()}')),
      );
    }
  }
}