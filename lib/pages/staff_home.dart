import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:motivation_grade_reports_student/services/auth_service.dart';
import 'package:motivation_grade_reports_student/services/user_service.dart';
import 'package:motivation_grade_reports_student/Models/staff_class.dart';
import 'package:motivation_grade_reports_student/Models/student_class.dart';
import 'package:motivation_grade_reports_student/pages/introduction_page.dart';
import 'package:motivation_grade_reports_student/pages/announcement_page.dart';
import 'package:motivation_grade_reports_student/pages/view_announcements_page.dart';
import 'package:motivation_grade_reports_student/widgets/student_listview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class StaffHomePage extends StatefulWidget {
  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  Staff? currentStaff;
  bool isLoading = true;
  List<Map<String, dynamic>> motivationSummary = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadMotivationSummary();
  }

  /// Load current staff data from Firebase
  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      currentStaff = await _userService.getCurrentStaff();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Load and aggregate student motivation data for the last 7 days
  Future<void> _loadMotivationSummary() async {
    try {
      print('Loading motivation summary...');
      // Get all students (you might want to filter by grades that this staff teaches)
      List<Student> students = await _userService.getAllStudents();
      print('Found ${students.length} students');
      
      // Get the last 7 days
      DateTime now = DateTime.now();
      Map<String, List<double>> dailyMotivations = {};
      
      for (int i = 6; i >= 0; i--) {
        DateTime date = now.subtract(Duration(days: i));
        String dateKey = "${date.day}/${date.month}";
        dailyMotivations[dateKey] = [];
      }
      print('Created date keys: ${dailyMotivations.keys.toList()}');
      
      // Aggregate motivation data from all students
      for (Student student in students) {
        print('Processing student: ${student.name}, motivation entries: ${student.studentMotivation.length}');
        student.studentMotivation.forEach((date, motivation) {
          // Extract only the date part (ignore time) for comparison
          DateTime dateOnly = DateTime(date.year, date.month, date.day);
          String dateKey = "${dateOnly.day}/${dateOnly.month}";
          print('Student motivation: $dateKey = $motivation (original date: $date)');
          if (dailyMotivations.containsKey(dateKey)) {
            // Motivation values are already on 0-10 scale as doubles, just add them directly
            dailyMotivations[dateKey]!.add(motivation);
            print('Added motivation $motivation for date $dateKey');
          }
        });
      }
      
      // Calculate average motivation per day
      motivationSummary = dailyMotivations.entries.map((entry) {
        double average = entry.value.isEmpty 
            ? 0 
            : entry.value.reduce((a, b) => a + b) / entry.value.length;
        print('Date ${entry.key}: ${entry.value.length} submissions, average: $average');
        return {
          'date': entry.key,
          'averageMotivation': average,
          'studentCount': entry.value.length,
        };
      }).toList();
      
      print('Final motivation summary: $motivationSummary');
      setState(() {});
    } catch (e) {
      print('Error loading motivation summary: $e');
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

  /// Show image picker dialog to change profile image
  Future<void> _changeProfileImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Camera option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.orange[800],
                            size: 32,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Camera',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gallery option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: Colors.orange[800],
                            size: 32,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Gallery',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Remove option
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _removeProfileImage();
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: Colors.red[800],
                            size: 32,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Remove',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image != null && currentStaff != null) {
        // Show loading
        setState(() {
          isLoading = true;
        });

        // Save image to app documents directory
        final String imagePath = await _saveImageToLocal(image);
        
        // Update profile in Firebase
        await _userService.updateStaffProfileImage(currentStaff!.id, imagePath);
        
        // Reload user data to reflect changes
        await _loadUserData();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating profile picture: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Remove profile image
  Future<void> _removeProfileImage() async {
    if (currentStaff == null) return;

    try {
      setState(() {
        isLoading = true;
      });

      // Update profile in Firebase (set to null)
      await _userService.updateStaffProfileImage(currentStaff!.id, null);
      
      // Reload user data to reflect changes
      await _loadUserData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile picture removed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error removing profile picture: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Save image to local app directory
  Future<String> _saveImageToLocal(XFile image) async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String profileImagesDir = '${appDocDir.path}/profile_images';
    
    // Create directory if it doesn't exist
    await Directory(profileImagesDir).create(recursive: true);
    
    // Generate unique filename
    final String fileName = 'staff_${currentStaff!.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String newPath = '$profileImagesDir/$fileName';
    
    // Copy image to new location
    final Uint8List imageBytes = await image.readAsBytes();
    final File newImage = File(newPath);
    await newImage.writeAsBytes(imageBytes);
    
    return newPath;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.orange))
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                    // Custom Profile Header
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          // Profile Image
                          GestureDetector(
                            onTap: _changeProfileImage,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: currentStaff?.profileImagePath != null
                                  ? FileImage(File(currentStaff!.profileImagePath!))
                                  : AssetImage('assets/images/userprofile.png') as ImageProvider,
                              backgroundColor: Colors.orange[100],
                            ),
                          ),
                          SizedBox(width: 16),
                          // User Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentStaff != null 
                                      ? 'Hello ${currentStaff!.name} ${currentStaff!.surname}'
                                      : 'Loading...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[800],
                                  ),
                                ),
                                SizedBox(height: 4),
                                if (currentStaff != null && currentStaff!.grades.isNotEmpty)
                                  Text(
                                    'Grades: ${currentStaff!.grades.join(', ')}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.orange[600],
                                    ),
                                  ),
                                if (currentStaff != null && currentStaff!.subjects.isNotEmpty)
                                  Text(
                                    currentStaff!.subjects.join(', '),
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
                                  builder: (context) => ViewAnnouncementsPage(isStaff: true),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.orange[800],
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Date Card
                    Card(
                      color: Colors.orange[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.orange[100]),
                    SizedBox(height: 8),
                    // Motivation Trends Title
                    Center(
                      child: Text(
                        'Average Student Motivation (Last 7 Days)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Student Motivation Bar Chart
                    SizedBox(
                      height: 200,
                      child: motivationSummary.isEmpty
                          ? Center(
                              child: Text(
                                'No motivation data available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            )
                          : BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: 10,
                                minY: 0,
                                gridData: FlGridData(
                                  show: true,
                                  drawHorizontalLine: true,
                                  drawVerticalLine: false,
                                  horizontalInterval: 2,
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 2,
                                      getTitlesWidget: (value, meta) => Text(
                                        '${value.toInt()}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        if (value.toInt() < motivationSummary.length) {
                                          return Text(
                                            motivationSummary[value.toInt()]['date'],
                                            style: TextStyle(fontSize: 10),
                                          );
                                        }
                                        return Text('');
                                      },
                                    ),
                                  ),
                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                barGroups: motivationSummary.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, dynamic> data = entry.value;
                                  double motivation = data['averageMotivation'].toDouble();
                                  
                                  return BarChartGroupData(
                                    x: index,
                                    barRods: [
                                      BarChartRodData(
                                        toY: motivation,
                                        color: Colors.orange[400],
                                        width: 20,
                                        borderRadius: BorderRadius.circular(4),
                                        backDrawRodData: BackgroundBarChartRodData(
                                          show: true,
                                          toY: 10,
                                          color: Colors.orange[100],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.orange[100]),
                    SizedBox(height: 16),
                    // Student List Section
                    SizedBox(
                      height: 300,
                      child: FutureBuilder<List<Student>>(
                        future: _userService.getAllStudents(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(color: Colors.orange),
                            );
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                                  SizedBox(height: 8),
                                  Text(
                                    'Error loading students',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            );
                          }
                          return StudentMotivationListView(
                            students: snapshot.data ?? [],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.orange[100]),
                    SizedBox(height: 8),
                    // Quick Actions Title
                    Text(
                      'Quick Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    // Quick Action Buttons (Orange)
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnnouncementPage(isStudent: false),
                          ),
                        );
                      },
                      icon: Icon(Icons.announcement, color: Colors.white),
                      label: Text('New Announcements'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: StadiumBorder(),
                      ),
                    ),

                    

                        ],
                      ),
                    ),
                  ),
                  
                  // Settings and logout section
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: _signOut,
                          icon: Icon(Icons.logout, color: Colors.red),
                          label: Text('Sign Out', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}