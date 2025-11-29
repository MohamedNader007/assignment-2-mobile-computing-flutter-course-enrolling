import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all courses
  Stream<List<CourseModel>> getCourses() {
    return _firestore.collection('courses').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => CourseModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  // Add a new course
  Future<String?> addCourse(CourseModel course) async {
    try {
      await _firestore.collection('courses').add(course.toMap());
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Enroll in a course
  Future<String?> enrollInCourse(String userId, String courseId) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId]),
      });
      return null; // Success
    } catch (e) {
      return e.toString();
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
    } catch (e) {
      print('Error getting user data: $e');
    }
    return null;
  }

  // Check if user is enrolled in course
  Future<bool> isEnrolled(String userId, String courseId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        return user.enrolledCourses.contains(courseId);
      }
    } catch (e) {
      print('Error checking enrollment: $e');
    }
    return false;
  }
}
