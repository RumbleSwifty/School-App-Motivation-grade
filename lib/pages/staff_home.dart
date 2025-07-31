import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StaffHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Avatar and Name
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hello Smith',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Date Card
              Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Today is [Day/Month/Year]',
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