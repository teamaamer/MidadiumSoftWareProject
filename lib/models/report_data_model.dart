// lib/models/report_data_model.dart
import 'package:flutter/material.dart'; // For Color

// Simple class for named counts (used for subject, grade, teacher distribution)
class NameCountData {
  final String name;
  final int count;

  NameCountData({required this.name, required this.count});

  factory NameCountData.fromJson(Map<String, dynamic> json) {
    return NameCountData(
      name: json['name'] ?? 'Unknown',
      count: json['count'] ?? 0,
    );
  }
}

class ReportData {
  final int pendingCourses;
  final int approvedCourses;
  final int rejectedCourses;
  final int totalCourses;
  final List<NameCountData> subjectDistribution;
  final List<NameCountData> gradeDistribution;
  final List<NameCountData> coursesPerTeacher;
    final int totalStudents; 
  final List<NameCountData> studentGradeDistribution; 
  final double placeholderCompletionRate;

  ReportData({
    required this.pendingCourses,
    required this.approvedCourses,
    required this.rejectedCourses,
    required this.totalCourses,
    required this.subjectDistribution,
    required this.gradeDistribution,
    required this.coursesPerTeacher,
    required this.totalStudents, 
    required this.studentGradeDistribution,
    required this.placeholderCompletionRate,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) {
    final statusCounts = json['courseStatusCounts'] as Map<String, dynamic>? ?? {};
    final subjectDist = (json['subjectDistribution'] as List<dynamic>?)
        ?.map((item) => NameCountData.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];
    final gradeDist = (json['gradeDistribution'] as List<dynamic>?)
        ?.map((item) => NameCountData.fromJson(item as Map<String, dynamic>))
        .toList() ?? [];
     final teacherDist = (json['coursesPerTeacher'] as List<dynamic>?)
         ?.map((item) => NameCountData.fromJson(item as Map<String, dynamic>))
         .toList() ?? [];
    final studentGradeDist = (json['studentGradeDistribution'] as List<dynamic>?)?.map((item) => NameCountData.fromJson(item)).toList() ?? [];
    final totalStudentsCount = json['totalStudents'] as int? ?? 0;     

    return ReportData(
      pendingCourses: statusCounts['pending'] ?? 0,
      approvedCourses: statusCounts['approved'] ?? 0,
      rejectedCourses: statusCounts['rejected'] ?? 0,
      totalCourses: statusCounts['total'] ?? 0,
      subjectDistribution: subjectDist,
      gradeDistribution: gradeDist,
      coursesPerTeacher: teacherDist,
       totalStudents: totalStudentsCount,
      studentGradeDistribution: studentGradeDist,
      placeholderCompletionRate: (json['placeholderCourseCompletionRate'] as num? ?? 0.0).toDouble(),
    );
  }
}