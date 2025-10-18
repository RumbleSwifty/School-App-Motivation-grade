import 'package:flutter/material.dart';
import 'package:motivation_grade_reports_student/Models/student_class.dart';
import 'dart:io';

class StudentMotivationListView extends StatelessWidget {
  final List<Student> students;

  StudentMotivationListView({required this.students});

  /// Calculate the latest motivation level for a student
  double _getLatestMotivation(Student student) {
    if (student.studentMotivation.isEmpty) return 0.0;
    
    // Get the most recent motivation entry
    DateTime latestDate = student.studentMotivation.keys.reduce((a, b) => a.isAfter(b) ? a : b);
    return student.studentMotivation[latestDate] ?? 0.0;
  }

  /// Get motivation level color based on value
  Color _getMotivationColor(double motivation) {
    if (motivation >= 8.0) return Colors.green;
    if (motivation >= 6.0) return Colors.orange;
    if (motivation >= 4.0) return Colors.amber;
    return Colors.red;
  }

  /// Get motivation level text
  String _getMotivationText(double motivation) {
    if (motivation >= 8.0) return 'Excellent';
    if (motivation >= 6.0) return 'Good';
    if (motivation >= 4.0) return 'Average';
    if (motivation > 0.0) return 'Low';
    return 'No Data';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.orange[800], size: 24),
                SizedBox(width: 8),
                Text(
                  'Student Motivation Levels',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${students.length} Students',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Student List
          Expanded(
            child: students.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.school, size: 64, color: Colors.grey[400]),
                          SizedBox(height: 16),
                          Text(
                            'No Students Found',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Students will appear here once they register',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(8),
                    itemCount: students.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[200],
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final student = students[index];
                      final latestMotivation = _getLatestMotivation(student);
                      final motivationColor = _getMotivationColor(latestMotivation);
                      final motivationText = _getMotivationText(latestMotivation);

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        child: Row(
                          children: [
                            // Profile Image
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.orange[100],
                              backgroundImage: student.profileImagePath != null
                                  ? FileImage(File(student.profileImagePath!))
                                  : null,
                              child: student.profileImagePath == null
                                  ? Text(
                                      student.name.isNotEmpty ? student.name[0].toUpperCase() : 'S',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[800],
                                      ),
                                    )
                                  : null,
                            ),
                            SizedBox(width: 12),
                            // Student Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${student.name} ${student.surname}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[50],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.blue[200]!),
                                        ),
                                        child: Text(
                                          'Grade ${student.grade}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      if (student.subjects.isNotEmpty) ...[
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            student.subjects.join(', '),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Motivation Level
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: motivationColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: motivationColor.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.trending_up,
                                        size: 14,
                                        color: motivationColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        latestMotivation > 0 
                                            ? latestMotivation.toStringAsFixed(1) 
                                            : '-',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: motivationColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  motivationText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: motivationColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}