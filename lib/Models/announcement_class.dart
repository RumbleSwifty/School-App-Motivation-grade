import 'package:cloud_firestore/cloud_firestore.dart';

/// Announcement model for storing school announcements
/// Represents announcements posted by staff members
class Announcement {
  final String id;
  final String eventType;
  final String title;
  final String content;
  final DateTime dateCreated;
  final String staffName; // Name of the staff member for display

  Announcement({
    required this.id,
    required this.eventType,
    required this.title,
    required this.content,
    required this.dateCreated,
    required this.staffName,
  });

  /// Create Announcement from Firestore document
  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] ?? '',
      eventType: map['eventType'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      dateCreated: map['dateCreated'] is Timestamp 
          ? (map['dateCreated'] as Timestamp).toDate()
          : DateTime.parse(map['dateCreated']),
      staffName: map['staffName'] ?? '',
    );
  }

  /// Convert Announcement to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventType': eventType,
      'title': title,
      'content': content,
      'dateCreated': Timestamp.fromDate(dateCreated),
      'staffName': staffName,
    };
  }

  /// Create a copy of this announcement with updated fields
  Announcement copyWith({
    String? id,
    String? eventType,
    String? title,
    String? content,
    DateTime? dateCreated,
    String? staffName,
  }) {
    return Announcement(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      content: content ?? this.content,
      dateCreated: dateCreated ?? this.dateCreated,
      staffName: staffName ?? this.staffName,
    );
  }

  @override
  String toString() {
    return 'Announcement(id: $id, eventType: $eventType, title: $title, content: $content, dateCreated: $dateCreated, staffName: $staffName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Announcement &&
      other.id == id &&
      other.eventType == eventType &&
      other.title == title &&
      other.content == content &&
      other.dateCreated == dateCreated &&
      other.staffName == staffName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      eventType.hashCode ^
      title.hashCode ^
      content.hashCode ^
      dateCreated.hashCode ^
      staffName.hashCode;
  }
}