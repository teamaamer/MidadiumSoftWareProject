// lib/models/course_model.dart
import 'user_model.dart';
class Course {
  final String id;
  final String name;
  final String description;
  final String teacherId;
  final String teacherName;
  final String subject;
  final String grade;
  final String status;
  final String? syllabus;
  final String? resources;
   final List<User> students; 

  Course({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.grade,
    required this.status,
    this.syllabus,
    this.resources,
    required this.students,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    // *** PARSE STUDENTS ARRAY ***
    List<User> enrolledStudents = [];
    if (json['students'] != null && json['students'] is List) {
      try {
        enrolledStudents = (json['students'] as List).map((studentData) {
          if (studentData is Map<String, dynamic>) {
            // If student is a full object
            return User.fromJson(studentData);
          } else if (studentData is String) {
            // If student is just an ID string - create minimal User with required fields
            return User(
              id: studentData,
              username: 'Unknown',
              email: '',
              role: 'student',
              populatedCourses: [],
              courseIds: [],
              enrollments: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now()
            );
          }
          return User(
            id: '',
            username: 'Unknown',
            email: '',
            role: 'student',
            populatedCourses: [],
            courseIds: [],
            enrollments: [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()
          );
        }).toList();
      } catch (e) {
        print("Error parsing students in Course.fromJson: $e");
      }
    }
    return Course(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      teacherId: json['teacher'] is Map ? json['teacher']['_id'] ?? '' : json['teacher'] ?? '',
      teacherName: json['teacher'] is Map ? json['teacher']['username'] ?? '' : '',
      subject: json['subject'] ?? '',
      grade: json['grade'] ?? '',
      status: json['status'] ?? 'pending',
      syllabus: json['syllabus'],
      resources: json['resources'],
      students: enrolledStudents,
    );
  }

// Optional: Update toJson if needed, usually send IDs back
   Map<String, dynamic> toJson() {
     return {
       '_id': id,
       'name': name,
       'description': description,
       'teacher': teacherId, // Send teacher ID back
       'subject': subject,
       'grade': grade,
       'status': status,
       'syllabus': syllabus,
       'resources': resources,
       'students': students.map((student) => student.id).toList(), // Send student IDs back
     };
   }
}