class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final int duration; // in weeks

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'instructor': instructor,
      'duration': duration,
    };
  }

  factory CourseModel.fromMap(String id, Map<String, dynamic> map) {
    return CourseModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      instructor: map['instructor'] ?? '',
      duration: map['duration'] ?? 0,
    );
  }
}
