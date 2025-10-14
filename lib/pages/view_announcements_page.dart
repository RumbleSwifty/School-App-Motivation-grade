import 'package:flutter/material.dart';
import 'package:motivation_grade_reports_student/services/user_service.dart';
import 'package:motivation_grade_reports_student/Models/announcement_class.dart';

class ViewAnnouncementsPage extends StatefulWidget {
  @override
  _ViewAnnouncementsPageState createState() => _ViewAnnouncementsPageState();
}

class _ViewAnnouncementsPageState extends State<ViewAnnouncementsPage> {
  final UserService _userService = UserService();
  List<Announcement> announcements = [];
  bool isLoading = true;
  String selectedFilter = 'All';
  
  final List<String> filters = ['All', 'General', 'Sports', 'Academics'];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Announcement> allAnnouncements = await _userService.getAllAnnouncements();
      setState(() {
        announcements = allAnnouncements;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading announcements: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Announcement> get filteredAnnouncements {
    if (selectedFilter == 'All') {
      return announcements;
    }
    return announcements.where((announcement) => announcement.eventType == selectedFilter).toList();
  }

  Color _getEventTypeColor(String eventType) {
    switch (eventType) {
      case 'General':
        return Colors.blue;
      case 'Sports':
        return Colors.green;
      case 'Academics':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildAnnouncementTile(Announcement announcement) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: _getEventTypeColor(announcement.eventType),
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with event type and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getEventTypeColor(announcement.eventType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getEventTypeColor(announcement.eventType),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      announcement.eventType,
                      style: TextStyle(
                        color: _getEventTypeColor(announcement.eventType),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(announcement.dateCreated),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              // Title
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8),
              
              // Content
              Text(
                announcement.content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12),
              
              // Staff name
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[500],
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Posted by ${announcement.staffName}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Announcements',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadAnnouncements,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, index) {
                String filter = filters[index];
                bool isSelected = selectedFilter == filter;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: Colors.purple[100],
                    checkmarkColor: Colors.purple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.purple : Colors.grey[700],
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Announcements list
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  )
                : filteredAnnouncements.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.announcement_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              selectedFilter == 'All' 
                                  ? 'No announcements available'
                                  : 'No ${selectedFilter.toLowerCase()} announcements',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Check back later for updates',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadAnnouncements,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredAnnouncements.length,
                          itemBuilder: (context, index) {
                            return _buildAnnouncementTile(filteredAnnouncements[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}