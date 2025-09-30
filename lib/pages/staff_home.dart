import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:motivation_grade_reports_student/services/auth_service.dart';
import 'package:motivation_grade_reports_student/services/user_service.dart';
import 'package:motivation_grade_reports_student/Models/staff_class.dart';
import 'package:motivation_grade_reports_student/pages/introduction_page.dart';

class StaffHomePage extends StatefulWidget {
  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  Staff? currentStaff;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
            ? Center(child: CircularProgressIndicator(color: Colors.orange))
            : SingleChildScrollView(
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
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: currentStaff?.profileImagePath != null
                                ? AssetImage(currentStaff!.profileImagePath!)
                                : AssetImage('assets/images/userprofile.png'),
                            backgroundColor: Colors.orange[100],
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
                          // Logout Button
                          GestureDetector(
                            onTap: _signOut,
                            child: Icon(Icons.logout, size: 28, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    // Date Card
                    Card(
                      color: Colors.purple[50],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.purple[100]),
                    SizedBox(height: 8),
                    // Motivation Trends Title
                    Center(
                      child: Text(
                        'Motivation trends (weekly)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    // Simple Chart
                    SizedBox(
                      height: 180,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: true, drawVerticalLine: true),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 25,
                                getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  const days = ['Mon.', 'Tues.', 'Wed.', 'Thur.', 'Fri.'];
                                  return Text(days[value.toInt()]);
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          minX: 0,
                          maxX: 4,
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 50),
                                FlSpot(1, 75),
                                FlSpot(2, 60),
                                FlSpot(3, 80),
                                FlSpot(4, 30),
                              ],
                              isCurved: false,
                              barWidth: 0,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                  radius: 8,
                                  color: Colors.black,
                                  strokeWidth: 0,
                                ),
                              ),
                              belowBarData: BarAreaData(show: false),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.purple[100]),
                    SizedBox(height: 8),
                    // Quick Actions Title
                    Text(
                      'Quick Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    // Quick Action Buttons (Orange)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add, color: Colors.white),
                          label: Text('Add Material'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.announcement, color: Colors.white),
                          label: Text('[New Announcements]'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.grade, color: Colors.white),
                          label: Text('Grade Reports'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Divider(color: Colors.purple[100]),
                    SizedBox(height: 8),
                    // Other Actions (Purple)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.schedule, color: Colors.white),
                          label: Text('Schedule'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.person, color: Colors.white),
                          label: Text('Profiles'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.update, color: Colors.white),
                          label: Text('Updates'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: StadiumBorder(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}