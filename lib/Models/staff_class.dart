class Staff {
   final String id;
   final String name;
   final String email;
   final List<String> subjects;
   final List<String> grades;
   final String surname;
   final String phone;
   final DateTime dateOfBirth;
   final String? profileImagePath;  // Path to profile image

  //Constructor- initial object creation
  Staff({
       required this.id,
       required this.name,
       required this.surname,
       required this.dateOfBirth,
       required this.email,
       required this.phone,
       required this.subjects,
       required this.grades,
       this.profileImagePath,
 });
 /// Convert Staff object to Map for Firestore storage
 Map<String, dynamic> toMap() {
   return {
     'id': id,
     'name': name,
     'surname': surname,
     'dateOfBirth': dateOfBirth.toIso8601String(),
     'email': email,
     'phone': phone,
     'subjects': subjects,
     'grades': grades,
     'profileImagePath': profileImagePath,
   };
 }

 /// Create Staff object from Firestore Map data
 factory Staff.fromMap(Map<String, dynamic> map) {
   return Staff(
     id: map['id'] ?? '',
     name: map['name'] ?? '',
     surname: map['surname'] ?? '',
     dateOfBirth: DateTime.parse(map['dateOfBirth'] ?? DateTime.now().toIso8601String()),
     email: map['email'] ?? '',
     phone: map['phone'] ?? '',
     subjects: List<String>.from(map['subjects'] ?? []),
     grades: List<String>.from(map['grades'] ?? []),
     profileImagePath: map['profileImagePath'],
   );
 }
}


