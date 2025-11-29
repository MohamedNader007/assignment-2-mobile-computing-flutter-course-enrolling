class UserModel {
  final String uid;
  final String name;
  final String email;
  final List<String> enrolledCourses;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.enrolledCourses = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'enrolledCourses': enrolledCourses,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
    );
  }
}
