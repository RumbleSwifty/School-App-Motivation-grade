# Profile Image Implementation

This document describes the profile image functionality added to the school application.

## Features Added

### 1. Model Updates
- **Student Class**: Added `profileImagePath` field to store the local path of profile images
- **Staff Class**: Added `profileImagePath` field to store the local path of profile images
- Both classes updated with proper serialization/deserialization for Firestore

### 2. Image Service
- **Location**: `lib/services/image_service.dart`
- **Features**:
  - Pick images from gallery or camera
  - Resize images to 512x512 pixels for optimal storage
  - Save images to local app documents directory
  - Simple image picker dialog interface
  - Image deletion and existence checking

### 3. User Service Updates
- Added `updateStaffProfileImage()` method
- Added `updateStudentProfileImage()` method
- These methods update the Firestore document with the new image path

### 4. UserProfileWidget Updates
- **New Parameter**: `allowImageEdit` - enables/disables image editing
- **Profile Avatar**: Now displays actual profile images when available
- **Edit Button**: Small camera icon overlay for editing when `allowImageEdit=true`
- **Fallback**: Shows initials when no image is available or image file doesn't exist

### 5. Dependencies Added
- `image_picker: ^1.0.4` - For selecting images from gallery/camera
- `path_provider: ^2.1.1` - For accessing app's documents directory

## Usage Examples

### Display Profile with Image Editing
```dart
UserProfileWidget(
  primaryColor: Colors.purple,
  isDetailed: true,
  allowImageEdit: true, // Enable image editing
)
```

### Display Profile (Read-only)
```dart
UserProfileWidget(
  primaryColor: Colors.purple,
  isDetailed: false,
  allowImageEdit: false, // Disable image editing
)
```

## Image Storage Strategy

- **Local Storage**: Images are stored in the app's documents directory under `profile_images/`
- **Firestore**: Only the local file path is stored in Firestore, not the actual image
- **Naming**: Files are named with timestamp: `profile_[timestamp].jpg`
- **Size**: Images are automatically resized to 512x512 pixels

## Benefits of This Approach

1. **Simple**: No need for cloud storage setup (Firebase Storage, etc.)
2. **Fast**: Images load instantly from local storage
3. **Lightweight**: Firestore only stores file paths, not large image data
4. **Privacy**: Images stay on the device
5. **Cost-effective**: No additional storage costs

## Installation Steps

1. Run `flutter pub get` to install new dependencies
2. For iOS: Add camera and photo library permissions to `ios/Runner/Info.plist`:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>This app needs camera access to take profile photos</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>This app needs photo library access to select profile images</string>
   ```
3. For Android: Camera and gallery permissions are already included in the image_picker plugin

## File Structure
```
lib/
├── Models/
│   ├── staff_class.dart          # Updated with profileImagePath
│   └── student_class.dart        # Updated with profileImagePath
├── services/
│   ├── image_service.dart        # New - handles image operations
│   └── user_service.dart         # Updated with image update methods
├── widgets/
│   └── user_profile_widget.dart  # Updated with image display/editing
└── pages/
    └── profile_example_page.dart # Updated examples

assets/
└── images/                       # Directory for default images (if needed)
```

## Future Enhancements

1. **Cloud Sync**: Implement Firebase Storage for cross-device image sync
2. **Image Caching**: Add better caching mechanisms for performance
3. **Compression**: Further optimize image compression
4. **Multiple Images**: Support for multiple profile images or galleries
5. **Default Avatars**: Add default avatar options for users without photos