// lib/models/overview_model.dart
class OverviewData {
  final int totalTeachers;
  final int totalStudents;
  final int totalCourses;
  final int totalEnrollments;

  OverviewData({
    required this.totalTeachers,
    required this.totalStudents,
    required this.totalCourses,
     required this.totalEnrollments,
  });

  factory OverviewData.fromJson(Map<String, dynamic> json) {
    return OverviewData(
      totalTeachers: json['totalTeachers'] ?? 0,
      totalStudents: json['totalStudents'] ?? 0,
      totalCourses: json['totalCourses'] ?? 0,
          totalEnrollments: json['totalEnrollments'] as int? ?? 0, 
    );
  }
}