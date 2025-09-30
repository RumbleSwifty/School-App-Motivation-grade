# Firebase User Service Implementation Guide

## Overview
This guide explains how to use the newly created Firebase services for managing staff and student data in your Flutter application.

## Files Created

### 1. UserService (`lib/services/user_service.dart`)
- **Purpose**: Handles all Firebase Firestore operations for staff and student data
- **Features**:
  - Role-based authentication (staff vs student)
  - CRUD operations for both user types
  - Real-time data streaming
  - Motivation tracking for students
  - Search functionality

### 2. UserProfileWidget (`lib/widgets/user_profile_widget.dart`)
- **Purpose**: Reusable widget for displaying user profiles
- **Features**:
  - Automatic detection of user type (staff/student)
  - Compact and detailed view modes
  - Customizable styling
  - Built-in error handling and loading states

### 3. Updated Models
- **Staff Class**: Added `fromMap()` factory constructor
- **Student Class**: Added `fromMap()` factory constructor
- **Purpose**: Enable proper serialization/deserialization with Firestore

## Firestore Database Structure

### Collections Required:
```
firestore/
├── userRoles/           # Maps user IDs to roles
│   └── {userId}/
│       ├── role: "staff" | "student"
│       ├── userId: string
│       └── createdAt: timestamp
├── staff/               # Staff profiles
│   └── {userId}/
│       ├── id: string
│       ├── name: string
│       ├── surname: string
│       ├── email: string
│       ├── phone: string
│       ├── dateOfBirth: string (ISO)
│       ├── subjects: array<string>
│       └── grades: array<string>
└── students/            # Student profiles
    └── {userId}/
        ├── id: string
        ├── name: string
        ├── surname: string
        ├── email: string
        ├── phone: string
        ├── dateOfBirth: string (ISO)
        ├── subjects: array<string>
        ├── grade: string
        ├── age: number
        └── studentMotivation: map<string, number>
```

## Implementation Examples

### 1. Basic Usage - Get Current User
```dart
import 'package:your_app/services/user_service.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final UserService _userService = UserService();
  Student? currentStudent;
  Staff? currentStaff;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String role = await _userService.getUserRole();
    
    if (role == 'student') {
      currentStudent = await _userService.getCurrentStudent();
    } else if (role == 'staff') {
      currentStaff = await _userService.getCurrentStaff();
    }
    
    setState(() {});
  }
}
```

### 2. Display User Profile - Compact View
```dart
UserProfileWidget(
  isDetailed: false,
  primaryColor: Colors.blue,
)
```

### 3. Display User Profile - Detailed View
```dart
UserProfileWidget(
  isDetailed: true,
  primaryColor: Colors.purple,
  backgroundColor: Colors.grey[50],
)
```

### 4. Update Student Motivation
```dart
Future<void> updateMotivation(int motivationScore) async {
  Student? student = await _userService.getCurrentStudent();
  if (student != null) {
    Map<DateTime, int> updatedMotivation = Map.from(student.studentMotivation);
    updatedMotivation[DateTime.now()] = motivationScore;
    
    await _userService.updateStudentMotivation(student.id, updatedMotivation);
  }
}
```

### 5. Real-time Data Streaming
```dart
StreamBuilder(
  stream: _userService.getCurrentUserStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      var user = snapshot.data;
      return UserProfileWidget();
    } else {
      return CircularProgressIndicator();
    }
  },
)
```

## Setup Instructions

### 1. Firebase Configuration
Make sure you have Firebase configured in your project:
- `firebase_core` dependency
- `cloud_firestore` dependency
- Proper Firebase initialization in `main.dart`

### 2. Security Rules (Firestore)
Add these security rules to your Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /userRoles/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    match /staff/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      // Staff can read other staff profiles
      allow read: if request.auth != null && 
        exists(/databases/$(database)/documents/userRoles/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/userRoles/$(request.auth.uid)).data.role == 'staff';
    }
    
    match /students/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      // Staff can read student profiles
      allow read: if request.auth != null && 
        exists(/databases/$(database)/documents/userRoles/$(request.auth.uid)) &&
        get(/databases/$(database)/documents/userRoles/$(request.auth.uid)).data.role == 'staff';
    }
  }
}
```

### 3. Initial Data Setup
During user registration, make sure to:
1. Create the user account with Firebase Auth
2. Set the user role using `_userService.setUserRole(userId, 'student'|'staff')`
3. Create the initial profile using `_userService.saveStudentProfile()` or `_userService.saveStaffProfile()`

## Recommendations for Displaying User Information

### 1. **User Profile Header**
Use the compact version of `UserProfileWidget` in:
- Navigation headers
- App bars
- Quick user identification areas

```dart
UserProfileWidget(isDetailed: false)
```

### 2. **Profile Pages**
Use the detailed version for:
- Dedicated profile/settings pages
- User information modals
- Account management sections

```dart
UserProfileWidget(isDetailed: true)
```

### 3. **Loading States**
Always handle loading and error states:
- Show loading indicators during data fetch
- Display error messages with retry options
- Provide fallback UI for missing data

### 4. **Data Caching**
Consider implementing local caching for:
- Current user profile (frequently accessed)
- Motivation data (for offline viewing)
- User preferences and settings

### 5. **Performance Optimization**
- Use `StreamBuilder` for real-time updates
- Implement proper pagination for lists
- Cache frequently accessed data
- Use `FutureBuilder` for one-time data fetching

### 6. **Error Handling**
```dart
try {
  Student? student = await _userService.getCurrentStudent();
  // Handle success
} catch (e) {
  // Show user-friendly error message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Failed to load profile: ${e.toString()}')),
  );
}
```

## Best Practices

1. **Always check user role** before displaying role-specific content
2. **Use proper error handling** for all Firebase operations
3. **Implement loading states** for better user experience
4. **Cache data locally** for offline functionality
5. **Use real-time listeners** for collaborative features
6. **Follow Firebase security rules** for data protection
7. **Test with different user types** (staff and student)
8. **Implement proper navigation** based on user roles

## Testing Checklist

- [ ] User authentication works correctly
- [ ] Role assignment during registration
- [ ] Profile creation for both user types
- [ ] Profile data retrieval and display
- [ ] Motivation tracking for students
- [ ] Error handling for network issues
- [ ] Loading states display properly
- [ ] User interface is responsive
- [ ] Data persistence across app restarts
- [ ] Security rules prevent unauthorized access

## Common Issues and Solutions

### Issue: "fromMap method not found"
**Solution**: Make sure you've updated the model classes with the new `fromMap` factory constructors.

### Issue: "Permission denied" errors
**Solution**: Check your Firestore security rules and ensure proper user role setup.

### Issue: "User profile not found"
**Solution**: Ensure profile creation after user registration and proper role assignment.

### Issue: Loading states never complete
**Solution**: Add proper error handling and timeout mechanisms to your data fetching methods.

This implementation provides a robust, scalable foundation for managing user data in your school application while maintaining security and performance best practices.