import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  double dailyMotivation = 0.2;
  double weeklyMotivation = 0.5;
  double yearlyMotivation = 0.9;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Avatar, Name, Icons
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/avatar.png'), // Replace with your asset
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hello Smith',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Icon(Icons.settings, size: 28),
                  SizedBox(width: 16),
                  Icon(Icons.notifications_none, size: 28),
                ],
              ),
              SizedBox(height: 24),
              // Daily Motivation
              Text('Daily Motivation'),
              Slider(
                value: dailyMotivation,
                onChanged: (value) => setState(() => dailyMotivation = value),
                activeColor: Colors.purple,
                inactiveColor: Colors.purple[100],
              ),
              // Weekly Motivation
              Text('Weekly motivation'),
              Slider(
                value: weeklyMotivation,
                onChanged: (value) => setState(() => weeklyMotivation = value),
                activeColor: Colors.purple,
                inactiveColor: Colors.purple[100],
              ),
              // Yearly Motivation
              Text('Overall/Yearly Motivation'),
              Slider(
                value: yearlyMotivation,
                onChanged: (value) => setState(() => yearlyMotivation = value),
                activeColor: Colors.purple,
                inactiveColor: Colors.purple[100],
              ),
              SizedBox(height: 32),
              // Add Material Button
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    '+ Add Material',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 24),
              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  ),
                  child: Text(
                    'submit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}