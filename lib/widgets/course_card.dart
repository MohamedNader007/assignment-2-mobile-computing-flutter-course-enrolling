import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/course_model.dart';
import '../services/firestore_service.dart';

class CourseCard extends StatefulWidget {
  final CourseModel course;
  final String userId;

  const CourseCard({
    super.key,
    required this.course,
    required this.userId,
  });

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isEnrolled = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkEnrollment();
  }

  Future<void> _checkEnrollment() async {
    final enrolled = await _firestoreService.isEnrolled(
      widget.userId,
      widget.course.id,
    );
    setState(() {
      _isEnrolled = enrolled;
      _isLoading = false;
    });
  }

  Future<void> _enrollInCourse() async {
    final error = await _firestoreService.enrollInCourse(
      widget.userId,
      widget.course.id,
    );

    if (error == null) {
      setState(() => _isEnrolled = true);
      Fluttertoast.showToast(msg: 'Enrolled successfully!');
    } else {
      Fluttertoast.showToast(msg: 'Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.course.description,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text('Instructor: ${widget.course.instructor}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text('Duration: ${widget.course.duration} weeks'),
              ],
            ),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isEnrolled ? null : _enrollInCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEnrolled ? Colors.grey : Colors.blue,
                  ),
                  child: Text(_isEnrolled ? 'Enrolled' : 'Enroll Now'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
