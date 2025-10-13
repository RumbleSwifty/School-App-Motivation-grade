class Student {
   final String id;
   final String name;
   final String email;
   final List<String> subjects;
   final String grade;
   final String surname;
   final String phone;
   final DateTime dateOfBirth;
   final int age;
   final Map<DateTime, double> studentMotivation;  //Student's motivation 
   final String? profileImagePath;  // Path to profile image
  //Constructor- initial object creation
  Student({
       required this.id,
       required this.name,
       required this.surname,
       required this.dateOfBirth,
       required this.email,
       required this.phone,
       required this.subjects,
       required this.grade,
       required this.age,
       required this.studentMotivation,
       this.profileImagePath,
      }); 

  /// Convert Student object to Map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'email': email,
      'phone': phone,
      'subjects': subjects,
      'grade': grade,
      'age': age,
      'studentMotivation': studentMotivation.map(
        (key, value) => MapEntry(key.toIso8601String(), value),
      ),
      'profileImagePath': profileImagePath,
    };
  }

  /// Create Student object from Firestore Map data
  factory Student.fromMap(Map<String, dynamic> map) {
    // Convert string keys back to DateTime for studentMotivation
    Map<DateTime, double> motivationMap = {};
    if (map['studentMotivation'] != null) {
      Map<String, dynamic> motivation = Map<String, dynamic>.from(map['studentMotivation']);
      motivation.forEach((key, value) {
        motivationMap[DateTime.parse(key)] = (value as num).toDouble();
      });
    }

    return Student(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      surname: map['surname'] ?? '',
      dateOfBirth: DateTime.parse(map['dateOfBirth'] ?? DateTime.now().toIso8601String()),
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      subjects: List<String>.from(map['subjects'] ?? []),
      grade: map['grade'] ?? '',
      age: (map['age'] as num?)?.toInt() ?? 0, // Handle both int and double
      studentMotivation: motivationMap,
      profileImagePath: map['profileImagePath'],
    );
  }
}