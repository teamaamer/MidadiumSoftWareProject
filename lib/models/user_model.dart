// // lib/models/user_model.dart

import 'course_model.dart'; // Make sure Course model is imported
// lib/models/user_model.dart
import 'package:flutter/foundation.dart'; // For kDebugMode
 
class User {
  final String id;
  final String username;
  final String email;
  final String role;

  final List<Course> populatedCourses;
  // Always store the raw course IDs if available
  final List<String> courseIds;

  // STUDENT specific
  final String? grade;
  final List<Course> enrollments; // Expect populated Courses from backend

  // Other fields
  final String? resetCode;
  final DateTime? resetCodeExpires;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
       required this.populatedCourses, // Parsed courses if available
    required this.courseIds,        // Raw IDs if available
    this.grade,
    required this.enrollments,
    this.resetCode,
    this.resetCodeExpires,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {


   List<Course> parsedPopulatedCourses = [];
    List<String> parsedCourseIds = [];

    // --- Handle 'courses' field (Teacher) ---
    if (json['courses'] != null && json['courses'] is List) {
      final coursesList = json['courses'] as List;
      if (coursesList.isNotEmpty) {
        if (coursesList.first is String) {
          // Only IDs received
          parsedCourseIds = List<String>.from(coursesList);
          if (kDebugMode) {
            print("User.fromJson: Received course IDs for teacher ${json['_id']}");
          }
        } else if (coursesList.first is Map) {
          // Populated course objects received
          if (kDebugMode) {
            print("User.fromJson: Received populated courses for teacher ${json['_id']}");
          }
          try {
            parsedPopulatedCourses = coursesList
              .map((courseJson) => Course.fromJson(courseJson as Map<String, dynamic>))
              .toList();
            // Also extract IDs from the populated objects
            parsedCourseIds = parsedPopulatedCourses.map((c) => c.id).toList();
          } catch (e) {
             print("Error parsing populated courses in User.fromJson: $e");
             // Attempt to extract IDs even if full parsing failed
             parsedCourseIds = coursesList
                .map((courseJson) => (courseJson as Map<String, dynamic>)['_id'] as String? ?? '')
                .where((id) => id.isNotEmpty)
                .toList();
          }
        }
      }
    }

    // --- Handle 'enrollments' field (Student) ---
    List<Course> enrolledCourses = [];
    if (json['enrollments'] != null && json['enrollments'] is List) {
        final enrollmentsList = json['enrollments'] as List;
        if (enrollmentsList.isNotEmpty && enrollmentsList.first is Map) {
          // Expecting POPULATED objects for enrollments
           try {
              enrolledCourses = enrollmentsList
                .map((enrollmentJson) => Course.fromJson(enrollmentJson as Map<String, dynamic>))
                .toList();
           } catch (e) {
              print("Error parsing populated enrollments in User.fromJson: $e");
           }
        } else if (enrollmentsList.isNotEmpty && enrollmentsList.first is String){
            // print("Warning: Received enrollment IDs instead of populated objects in User.fromJson for student ${json['_id']}.");
        }
    }

    return User(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      populatedCourses: parsedPopulatedCourses, // Store parsed Course objects
      courseIds: parsedCourseIds,              // Store course IDs
      grade: json['grade'],
      enrollments: enrolledCourses,
      resetCode: json['resetCode'],
      resetCodeExpires: json['resetCodeExpires'] != null ? DateTime.tryParse(json['resetCodeExpires']) : null,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

   Map<String, dynamic> toJson() {
     return {
       '_id': id,
       'username': username,
       'email': email,
       'role': role,
       'courses': courseIds, // Send back only IDs for courses
       'grade': grade,
       'enrollments': enrollments.map((course) => course.id).toList(), // Send back only IDs for enrollments
       'createdAt': createdAt.toIso8601String(),
       'updatedAt': updatedAt.toIso8601String(),
     };
   }
}