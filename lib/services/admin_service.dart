// // lib/services/admin_service.dart
// import 'dart:convert';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/user_model.dart';
// import '../models/course_model.dart';
// import '../models/overview_model.dart';
// import '../models/report_data_model.dart';
// import '../models/activity_log_model.dart';
// class TeacherHasCoursesException implements Exception {
//   final String message;
//   final List<dynamic> coursesJson; // Store raw JSON or parsed Course objects

//   TeacherHasCoursesException(this.message, this.coursesJson);

//   @override
//   String toString() => message; // Keep the original message for display

//   //  Helper to get course IDs if coursesJson contains objects
//   List<String> get courseIds {
//      if (coursesJson.isEmpty) return [];
//      if (coursesJson.first is Map<String, dynamic>) {
//        // Assuming backend sends populated course objects
//        return coursesJson.map((course) => course['_id'] as String).toList();
//      } else if (coursesJson.first is String) {
//         // Assuming backend sends only course IDs
//        return List<String>.from(coursesJson);
//      }
//      return []; // Default case
//   }

//   // Helper to get course names if populated
//   List<String> get courseNames {
//       if (coursesJson.isEmpty || coursesJson.first is! Map<String, dynamic>) return [];
//       return coursesJson.map((course) => course['name'] as String? ?? 'Unknown Course').toList();
//   }
// }

// class AdminService {
//   final _storage = const FlutterSecureStorage();
//   final String baseUrl = kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";

//   Future<String?> _getToken() async {
//     return await _storage.read(key: "token");
//   }
//   dynamic _handleResponse(http.Response response) {
//     final responseData = jsonDecode(response.body);
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//         return responseData; // Return decoded JSON for success
//     } else {
//         // --- Special Handling for Teacher Deletion with Courses ---
//         if (response.statusCode == 400 &&
//             response.request?.url.path.contains('/api/admin/teachers/') == true &&
//             response.request?.method == 'DELETE' &&
//             responseData['message'] != null &&
//             responseData['message'].contains('Teacher has assigned courses')) {

//              throw TeacherHasCoursesException(
//                 responseData['message'],
//                 responseData['courses'] ?? []
//              );
//          }
//         // --- End Special Handling ---
//         throw Exception(responseData['message'] ?? "API Request Failed (Status: ${response.statusCode})");
//     }
//   }
//   // Overview
//   Future<OverviewData> getOverviewData() async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/overview'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       return OverviewData.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to fetch overview data");
//     }

//   }
// //ACTIVITY
// Future<List<ActivityLog>> getActivityLog({int limit = 15}) async {
//       final token = await _getToken();
//       final response = await http.get(
//         // Add limit query parameter
//         Uri.parse('$baseUrl/api/admin/activity?limit=$limit'),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data.map((json) => ActivityLog.fromJson(json)).toList();
//       } else {
//         final responseData = jsonDecode(response.body);
//         throw Exception(responseData['message'] ?? "Failed to fetch activity log (Status: ${response.statusCode})");
//       }
//     }
//   // Teachers
//   Future<List<User>> getAllTeachers() async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/teachers'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => User.fromJson(json)).toList();
//     } else {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to fetch teachers");
//     }
//   }

//   Future<User> getTeacherById(String id) async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/teachers/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       return User.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to fetch teacher");
//     }
//   }

//   Future<void> addTeacher(String username, String email, String password) async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/admin/teachers'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({
//         "username": username,
//         "email": email,
//         "password": password,
//       }),
//     );

//     if (response.statusCode != 201) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to add teacher");
//     }
//   }

//   Future<void> updateTeacher(String id, String username, String email) async {
//     final token = await _getToken();
//     final response = await http.put(
//       Uri.parse('$baseUrl/api/admin/teachers/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({
//         "username": username,
//         "email": email,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to update teacher");
//     }
//   }

//   // Future<void> deleteTeacher(String id) async {
//   //   final token = await _getToken();
//   //   final response = await http.delete(
//   //     Uri.parse('$baseUrl/api/admin/teachers/$id'),
//   //     headers: {
//   //       "Content-Type": "application/json",
//   //       "Authorization": "Bearer $token",
//   //     },
//   //   );

//   //   if (response.statusCode != 200) {
//   //     throw Exception(jsonDecode(response.body)['message'] ?? "Failed to delete teacher");
//   //   }
//   // }

//   Future<void> assignCourseToTeacher(String teacherId, String courseId) async {
//     final token = await _getToken();
//     final response = await http.put(
//       Uri.parse('$baseUrl/api/admin/teachers/$teacherId/assign-course'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({"courseId": courseId}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to assign course");
//     }
//   }
//   Future<void> deleteTeacherKeepCourses(String teacherId) async {
//     final token = await _getToken();
//     final response = await http.delete( // Matches the backend route method
//       Uri.parse('$baseUrl/api/admin/teachers/$teacherId/orphan-courses'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode != 200) {
//        final responseData = jsonDecode(response.body);
//        throw Exception(responseData['message'] ?? "Failed to delete teacher (keep courses) (Status: ${response.statusCode})");
//     }
//     // Success
//   }

//   // Courses
//   Future<List<Course>> getAllCourses({String? status, String? subject, String? grade, String? teacher}) async {
//     final token = await _getToken();
//     final queryParams = <String, String>{};
//     if (status != null) queryParams['status'] = status;
//     if (subject != null) queryParams['subject'] = subject;
//     if (grade != null) queryParams['grade'] = grade;
//     if (teacher != null) queryParams['teacher'] = teacher;

//     final uri = Uri.parse('$baseUrl/api/admin/courses').replace(queryParameters: queryParams);
//     final response = await http.get(
//       uri,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => Course.fromJson(json)).toList();
//     } else {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to fetch courses");
//     }
//   }

//   Future<Course> getCourseById(String id) async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/courses/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       return Course.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to fetch course");
//     }
//   }

//   Future<void> approveCourse(String id) async {
//     final token = await _getToken();
//     final response = await http.put(
//       Uri.parse('$baseUrl/api/admin/courses/$id/approve'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode != 200) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to approve course");
//     }
//   }

//   Future<void> rejectCourse(String id) async {
//     final token = await _getToken();
//     final response = await http.put(
//       Uri.parse('$baseUrl/api/admin/courses/$id/reject'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode != 200) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to reject course");
//     }
//   }

//   Future<void> updateCourse(String id, Map<String, dynamic> updates) async {
//     final token = await _getToken();
//     final response = await http.put(
//       Uri.parse('$baseUrl/api/admin/courses/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode(updates),
//     );

//     if (response.statusCode != 200) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to update course");
//     }
//   }

//   Future<void> addCourse(Map<String, dynamic> courseData) async {
//     final token = await _getToken();
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/admin/courses'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode(courseData),
//     );

//     if (response.statusCode != 201) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to add course");
//     }
//   }
// ////////////////////////
// // *** Step 1: Modify deleteTeacher ***
//   Future<void> deleteTeacher(String id) async {
//     final token = await _getToken();
//     final response = await http.delete(
//       Uri.parse('$baseUrl/api/admin/teachers/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       // Success, do nothing specific here, UI will refresh
//       return;
//     } else if (response.statusCode == 400) {
//        try {
//           final responseData = jsonDecode(response.body);
//           // Check for the specific message
//           if (responseData['message'] != null &&
//               responseData['message'].contains('Teacher has assigned courses')) {
//              // Throw the custom exception with the course data
//              throw TeacherHasCoursesException(
//                 responseData['message'],
//                 responseData['courses'] ?? [] // Pass the courses array
//              );
//           } else {
//              // Other 400 error
//              throw Exception(responseData['message'] ?? "Failed to delete teacher (Bad Request)");
//           }
//        } catch (e) {
//           // Handle JSON parsing error or rethrow the custom exception
//           if (e is TeacherHasCoursesException) rethrow;
//           throw Exception("Failed to delete teacher (Invalid response format)");
//        }
//     } else {
//       // Handle other non-200 status codes
//       final responseData = jsonDecode(response.body);
//       throw Exception(responseData['message'] ?? "Failed to delete teacher (Status: ${response.statusCode})");
//     }
//   }

//   // *** Step 5: Add deleteTeacherAndCourses ***
//   Future<void> deleteTeacherAndCourses(String teacherId, List<String> courseIdsToDelete) async {
//     final token = await _getToken();
//     final response = await http.delete( // Or PUT/POST depending on backend route definition
//       // Ensure this matches your backend route in adminRoutes.js
//       Uri.parse('$baseUrl/api/admin/teachers/$teacherId/delete-with-courses'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       // Send the course IDs in the body
//       body: jsonEncode({
//         "coursesToDelete": courseIdsToDelete,
//       }),
//     );

//      if (response.statusCode != 200) {
//         final responseData = jsonDecode(response.body);
//         throw Exception(responseData['message'] ?? "Failed to delete teacher and courses (Status: ${response.statusCode})");
//      }
//      // Success
//   }

// ////////////////////////////////////
// // --- NEW: Student Methods ---

//   Future<List<User>> getAllStudents({String? grade, String? search}) async {
//     final token = await _getToken();
//     final queryParams = <String, String>{};
//     if (grade != null) queryParams['grade'] = grade;
//     if (search != null && search.isNotEmpty) queryParams['search'] = search;

//     final uri = Uri.parse('$baseUrl/api/admin/students').replace(queryParameters: queryParams);

//     final response = await http.get(
//       uri,
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     final responseData = _handleResponse(response);
//     final List<dynamic> data = responseData as List;
//     return data.map((json) => User.fromJson(json)).toList();
//   }

//   Future<User> getStudentById(String id) async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/students/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//      final responseData = _handleResponse(response);
//      return User.fromJson(responseData);
//   }

//   Future<User> addStudent(String username, String email, String password, String grade) async {
//       final token = await _getToken();
//       final response = await http.post(
//           Uri.parse('$baseUrl/api/admin/students'),
//           headers: {
//               "Content-Type": "application/json",
//               "Authorization": "Bearer $token",
//           },
//           body: jsonEncode({
//               "username": username,
//               "email": email,
//               "password": password,
//               "grade": grade, // Include grade
//           }),
//       );
//       final responseData = _handleResponse(response);
//       // Assuming the backend returns { message: "...", student: {...} }
//       if (responseData['student'] != null) {
//         return User.fromJson(responseData['student']);
//       } else {
//         throw Exception("Student data not found in response after creation");
//       }
//   }

//   Future<User> updateStudent(String id, {String? username, String? email, String? grade}) async {
//      final token = await _getToken();
//      final updateData = <String, String>{};
//      if (username != null) updateData['username'] = username;
//      if (email != null) updateData['email'] = email;
//      if (grade != null) updateData['grade'] = grade;

//      if (updateData.isEmpty) {
//        // Or fetch and return the current student if no updates needed
//        return getStudentById(id);
//      }

//      final response = await http.put(
//        Uri.parse('$baseUrl/api/admin/students/$id'),
//        headers: {
//          "Content-Type": "application/json",
//          "Authorization": "Bearer $token",
//        },
//        body: jsonEncode(updateData),
//      );
//       final responseData = _handleResponse(response);
//        // Assuming the backend returns { message: "...", student: {...} }
//        if (responseData['student'] != null) {
//          return User.fromJson(responseData['student']);
//        } else {
//          throw Exception("Updated student data not found in response");
//        }
//    }

//   Future<void> deleteStudent(String id) async {
//     final token = await _getToken();
//     final response = await http.delete(
//       Uri.parse('$baseUrl/api/admin/students/$id'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//      _handleResponse(response); // Use handler
//   }

//   // --- NEW: Enrollment Methods ---

//   Future<void> enrollStudentInCourse(String studentId, String courseId) async {
//     final token = await _getToken();
//     // Make sure the route matches backend: POST /api/admin/students/:studentId/enroll/:courseId
//     final response = await http.post(
//       Uri.parse('$baseUrl/api/admin/students/$studentId/enroll/$courseId'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({}), // No body needed unless specified by backend
//     );
//     _handleResponse(response); // Use handler
//   }

//   Future<void> unenrollStudentFromCourse(String studentId, String courseId) async {
//     final token = await _getToken();
//      // Make sure the route matches backend: DELETE /api/admin/students/:studentId/unenroll/:courseId
//     final response = await http.delete(
//       Uri.parse('$baseUrl/api/admin/students/$studentId/unenroll/$courseId'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//     _handleResponse(response); // Use handler
//   }

// ///
//   // Reports
//  // *** Update getReports to return ReportData ***
//   Future<ReportData> getReports() async { // Change return type
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/reports'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       // Parse using the model's factory constructor
//       return ReportData.fromJson(jsonDecode(response.body));
//     } else {
//       final responseData = jsonDecode(response.body);
//       throw Exception(responseData['message'] ?? "Failed to fetch reports (Status: ${response.statusCode})");
//     }
//   }

//   // Settings
//   Future<User> getAdminSettings() async {
//     final token = await _getToken();
//     final response = await http.get(
//       Uri.parse('$baseUrl/api/admin/settings'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );

//     if (response.statusCode == 200) {
//       return User.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to fetch admin settings");
//     }
//   }

//   Future<void> updateAdminSettings(String username, String email) async {
//     final token = await _getToken();
//     final response = await http.put(
//       Uri.parse('$baseUrl/api/admin/settings'),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//       body: jsonEncode({
//         "username": username,
//         "email": email,
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception(jsonDecode(response.body)['message'] ?? "Failed to update admin settings");
//     }
//   }
// }

// lib/services/admin_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';
import '../models/course_model.dart';
import '../models/overview_model.dart';
import '../models/report_data_model.dart';
import '../models/activity_log_model.dart';

// Exception class (if not already defined elsewhere)
class TeacherHasCoursesException implements Exception {
  final String message;
  final List<dynamic> coursesJson; // Store raw JSON or parsed Course objects

  TeacherHasCoursesException(this.message, this.coursesJson);

  @override
  String toString() => message; // Keep the original message for display

  List<String> get courseIds {
    if (coursesJson.isEmpty) return [];
    if (coursesJson.first is Map<String, dynamic>) {
      return coursesJson.map((course) => course['_id'] as String).toList();
    } else if (coursesJson.first is String) {
      return List<String>.from(coursesJson);
    }
    return [];
  }

  List<String> get courseNames {
    if (coursesJson.isEmpty || coursesJson.first is! Map<String, dynamic>)
      return [];
    return coursesJson
        .map((course) => course['name'] as String? ?? 'Unknown Course')
        .toList();
  }
}

class AdminService {
  final _storage = const FlutterSecureStorage();
  final String baseUrl =
      kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";

  Future<String?> _getToken() async {
    return await _storage.read(key: "token");
  }

  // Helper for handling common API responses
  dynamic _handleResponse(http.Response response) {
    final responseData = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return responseData; // Return decoded JSON for success
    } else {
      // Special Handling for Teacher Deletion with Courses
      if (response.statusCode == 400 &&
          response.request?.url.path.contains('/api/admin/teachers/') == true &&
          response.request?.method == 'DELETE' &&
          responseData['message'] != null &&
          responseData['message'].contains('Teacher has assigned courses')) {
        throw TeacherHasCoursesException(
          responseData['message'],
          responseData['courses'] ?? [],
        );
      }
      throw Exception(
        responseData['message'] ??
            "API Request Failed (Status: ${response.statusCode})",
      );
    }
  }

  // --- Overview ---
  Future<OverviewData> getOverviewData() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/overview'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    return OverviewData.fromJson(responseData);
  }

  // --- Activity ---
  Future<List<ActivityLog>> getActivityLog({int limit = 15}) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/activity?limit=$limit'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    final List<dynamic> data = responseData as List;
    return data.map((json) => ActivityLog.fromJson(json)).toList();
  }

  // --- Teachers ---
  Future<List<User>> getAllTeachers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/teachers'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    final List<dynamic> data = responseData as List;
    return data.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getTeacherById(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/teachers/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    return User.fromJson(responseData);
  }

  Future<User> addTeacher(
    String username,
    String email,
    String password,
  ) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/teachers'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );
    final responseData = _handleResponse(response);
    if (responseData['teacher'] != null) {
      return User.fromJson(responseData['teacher']);
    } else {
      throw Exception("Teacher data not found in response after creation");
    }
  }

  Future<User> updateTeacher(String id, String username, String email) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/teachers/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"username": username, "email": email}),
    );
    final responseData = _handleResponse(response);
    if (responseData['teacher'] != null) {
      return User.fromJson(responseData['teacher']);
    } else {
      throw Exception("Updated teacher data not found in response");
    }
  }

  Future<void> deleteTeacher(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/teachers/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    _handleResponse(response);
  }

  Future<void> deleteTeacherKeepCourses(String teacherId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/teachers/$teacherId/orphan-courses'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    _handleResponse(response);
  }

  Future<void> deleteTeacherAndCourses(
    String teacherId,
    List<String> courseIdsToDelete,
  ) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/teachers/$teacherId/delete-with-courses'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"coursesToDelete": courseIdsToDelete}),
    );
    _handleResponse(response);
  }

  Future<void> assignCourseToTeacher(String teacherId, String courseId) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/teachers/$teacherId/assign-course'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"courseId": courseId}),
    );
    _handleResponse(response);
  }

  // --- Courses ---
  Future<List<Course>> getAllCourses({
    String? status,
    String? subject,
    String? grade,
    String? teacher,
  }) async {
    final token = await _getToken();
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (subject != null) queryParams['subject'] = subject;
    if (grade != null) queryParams['grade'] = grade;
    if (teacher != null) queryParams['teacher'] = teacher;

    final uri = Uri.parse(
      '$baseUrl/api/admin/courses',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    final List<dynamic> data = responseData as List;
    return data.map((json) => Course.fromJson(json)).toList();
  }

  Future<Course> getCourseById(String id) async {
    final token = await _getToken();
    // **Ensure backend populates the 'students' field here**
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    // Assuming backend now returns course with populated 'students' field (basic info)
    return Course.fromJson(responseData);
  }

  Future<void> approveCourse(String id) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/courses/$id/approve'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );
    _handleResponse(response);
  }

  Future<void> rejectCourse(String id) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/courses/$id/reject'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );
    _handleResponse(response);
  }

  Future<void> updateCourse(String id, Map<String, dynamic> updates) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(updates),
    );
    _handleResponse(response);
  }

  Future<Course> addCourse(Map<String, dynamic> courseData) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/courses'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(courseData),
    );
    final responseData = _handleResponse(response);
    if (responseData['course'] != null) {
      return Course.fromJson(responseData['course']);
    } else {
      throw Exception("Course data not found in response after creation");
    }
  }

  // **** ADDED rveCourse method ****
  Future<void> removeCourse(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/courses/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    _handleResponse(response); // Use handler to manage response/errors
  }

  // --- Students ---
  Future<List<User>> getAllStudents({String? grade, String? search}) async {
    final token = await _getToken();
    final queryParams = <String, String>{};
    if (grade != null) queryParams['grade'] = grade;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    // Add populate parameter to get enrollment counts
    queryParams['populate'] = 'enrollments';

    final uri = Uri.parse(
      '$baseUrl/api/admin/students',
    ).replace(queryParameters: queryParams);
    final response = await http.get(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    final List<dynamic> data = responseData as List;
    return data.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getStudentById(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/students/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    // Assuming backend populates 'enrollments' with basic course info
    return User.fromJson(responseData);
  }

  Future<User> addStudent(
    String username,
    String email,
    String password,
    String grade,
  ) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/students'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
        "grade": grade,
      }),
    );
    final responseData = _handleResponse(response);
    if (responseData['student'] != null) {
      return User.fromJson(responseData['student']);
    } else {
      throw Exception("Student data not found in response after creation");
    }
  }

  Future<User> updateStudent(
    String id, {
    String? username,
    String? email,
    String? grade,
  }) async {
    final token = await _getToken();
    final updateData = <String, String>{};
    if (username != null) updateData['username'] = username;
    if (email != null) updateData['email'] = email;
    if (grade != null) updateData['grade'] = grade;

    if (updateData.isEmpty) {
      return getStudentById(id);
    } // Return current if no change

    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/students/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(updateData),
    );
    final responseData = _handleResponse(response);
    if (responseData['student'] != null) {
      return User.fromJson(responseData['student']);
    } else {
      throw Exception("Updated student data not found in response");
    }
  }

  Future<void> deleteStudent(String id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/students/$id'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    _handleResponse(response);
  }

  // --- Enrollments ---
  Future<void> enrollStudentInCourse(String studentId, String courseId) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/students/$studentId/enroll/$courseId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({}),
    );
    _handleResponse(response);
  }

  Future<void> unenrollStudentFromCourse(
    String studentId,
    String courseId,
  ) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/students/$studentId/unenroll/$courseId'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    _handleResponse(response);
  }

  // --- Reports ---
  Future<ReportData> getReports() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/reports'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    return ReportData.fromJson(responseData);
  }

  // --- Settings ---
  Future<User> getAdminSettings() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/settings'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    final responseData = _handleResponse(response);
    return User.fromJson(responseData);
  }

  Future<void> updateAdminSettings(String username, String email) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/settings'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"username": username, "email": email}),
    );
    _handleResponse(response);
  }
}
