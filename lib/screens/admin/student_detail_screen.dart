// lib/screens/admin/student_detail_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart'; // Student is a User
import '../../models/course_model.dart'; // To show course info
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import 'course_detail_screen.dart'; // For navigation to course

class StudentDetailScreen extends StatefulWidget {
  final String studentId;

  const StudentDetailScreen({Key? key, required this.studentId}) : super(key: key);

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late Future<User> _studentFuture;
  // Also fetch available approved courses for enrollment dropdown
  late Future<List<Course>> _approvedCoursesFuture;
  User? _currentStudent; // Cache current student data
  List<Course>? _approvedCourses; // Cache approved courses

    // Define example grades - adjust or load dynamically if needed
   final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
     // Reset cached data on reload
     _currentStudent = null;
     _approvedCourses = null;

     // Set up futures
    setState(() {
      _studentFuture = AdminService().getStudentById(widget.studentId);
      _approvedCoursesFuture = AdminService().getAllCourses(status: 'approved');
    });

    try {
        // Wait for both
       final results = await Future.wait([_studentFuture, _approvedCoursesFuture]);
       if (mounted) {
          setState(() {
             _currentStudent = results[0] as User;
             _approvedCourses = results[1] as List<Course>;
             print("Student and Courses Loaded");
          });
       }

    } catch (e) {
      print("Error loading student details or courses: $e");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to load details: $e'), backgroundColor: AppColors.error, duration: const Duration(seconds: 5)),
         );
          setState(() { // Ensure state is updated even on error
             _currentStudent = null;
             _approvedCourses = null;
          });
      }
    }
  }

 void _showEditStudentDialog(User student) {
    final usernameController = TextEditingController(text: student.username);
    final emailController = TextEditingController(text: student.email);
    String? selectedGrade = _grades.contains(student.grade) ? student.grade : null; // Validate initial grade
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Student'),
          content: StatefulBuilder( // For dropdown update
              builder: (context, setStateDialog) {
                return SingleChildScrollView(
                   child: Form(
                     key: formKey,
                     child: Column(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         TextFormField(
                           controller: usernameController,
                           decoration: const InputDecoration(labelText: 'Username'),
                           validator: (v) => v!.isEmpty ? 'Username required' : null,
                         ),
                         const SizedBox(height: 16),
                         TextFormField(
                           controller: emailController,
                           decoration: const InputDecoration(labelText: 'Email'),
                           keyboardType: TextInputType.emailAddress,
                            validator: (value) { /* ... email validation ... */
                                if (value == null || value.isEmpty) return 'Email required';
                               if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'Enter a valid email';
                               return null;
                             },
                         ),
                         const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                           value: selectedGrade,
                           decoration: const InputDecoration(labelText: 'Grade Level'),
                           items: _grades.map((String grade) {
                             return DropdownMenuItem<String>(value: grade, child: Text(grade));
                           }).toList(),
                           onChanged: (String? newValue) {
                             setStateDialog(() { selectedGrade = newValue; });
                           },
                           validator: (v) => v == null ? 'Grade required' : null,
                         ),
                       ],
                     ),
                   ),
                 );
              }
           ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            CustomButton(
              text: 'Save Changes',
              icon: Icons.save_alt_outlined,
              onPressed: () async {
                 if (formKey.currentState!.validate()) {
                   // Capture context & mounted
                   final navigator = Navigator.of(dialogContext);
                   final scaffoldMessenger = ScaffoldMessenger.of(context);
                   final isMounted = mounted;

                   try {
                      await AdminService().updateStudent(
                         student.id,
                         username: usernameController.text,
                         email: emailController.text,
                         grade: selectedGrade, // Pass selected grade
                      );
                      if (!isMounted) return;
                      navigator.pop();
                      _loadData(); // Reload student details
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Student updated successfully'), backgroundColor: AppColors.success),
                      );
                   } catch (e) {
                       if (!isMounted) return;
                       // Keep dialog open
                       scaffoldMessenger.showSnackBar(
                         SnackBar(content: Text('Error updating student: $e'), backgroundColor: AppColors.error),
                      );
                   }
                 }
              },
            ),
          ],
        );
      },
    );
  }

   void _showEnrollCourseDialog(List<Course> allApprovedCourses, List<String> currentlyEnrolledIds) {
      // Filter out courses the student is already enrolled in
       final availableCourses = allApprovedCourses.where((course) => !currentlyEnrolledIds.contains(course.id)).toList();
      String? selectedCourseId;

      if (availableCourses.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(content: Text('No more approved courses available to enroll in.'), backgroundColor: AppColors.textSecondary),
          );
          return;
      }


      showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Enroll in Course'),
            content: DropdownButtonFormField<String>(
                         value: selectedCourseId,
                         decoration: const InputDecoration(labelText: 'Select Course'),
                         items: availableCourses.map((Course course) {
                           return DropdownMenuItem<String>(
                             value: course.id,
                             child: Text("${course.name} (${course.subject ?? ''})"),
                           );
                         }).toList(),
                         onChanged: (String? newValue) {
                            selectedCourseId = newValue;
                         },
                         validator: (value) => value == null ? 'Please select a course' : null,
                        isExpanded: true, // Allow dropdown text to expand
                       ),
            actions: [
               TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
               CustomButton(
                  text: 'Enroll Student',
                  icon: Icons.add_task_outlined,
                  onPressed: () async {
                     if (selectedCourseId == null) {
                        // Validator should catch this, but double-check
                         ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a course first.'), backgroundColor: AppColors.error),
                          );
                        return;
                     }

                      // --- Capture context & mounted state ---
                     final navigator = Navigator.of(dialogContext);
                     final scaffoldMessenger = ScaffoldMessenger.of(context);
                     final isMounted = mounted;

                      try {
                         await AdminService().enrollStudentInCourse(widget.studentId, selectedCourseId!);
                          if (!isMounted) return;
                          navigator.pop();
                         _loadData(); // Reload data to show updated enrollments
                         scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text('Student enrolled successfully.'), backgroundColor: AppColors.success),
                         );
                      } catch(e) {
                           if (!isMounted) return;
                            // Keep dialog open
                           scaffoldMessenger.showSnackBar(
                             SnackBar(content: Text('Error enrolling student: $e'), backgroundColor: AppColors.error),
                           );
                      }
                  },
               )
            ]
          );
        }
      );
   }


   void _confirmUnenrollStudent(String courseId, String courseName) {
    showDialog(
       context: context,
       builder: (dialogContext) => AlertDialog(
         title: const Text('Confirm Unenrollment'),
         content: Text('Are you sure you want to unenroll this student from "$courseName"?'),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(dialogContext),
             child: const Text('Cancel'),
           ),
           CustomButton(
             text: 'Unenroll',
             backgroundColor: AppColors.error, // Use caution color
             onPressed: () async {
                // --- Capture context & mounted state ---
                 final navigator = Navigator.of(dialogContext);
                 final scaffoldMessenger = ScaffoldMessenger.of(context);
                 final isMounted = mounted;

                navigator.pop(); // Close dialog first

               try {
                 // Call service to unenroll student
                 await AdminService().unenrollStudentFromCourse(widget.studentId, courseId);

                  if (!isMounted) return;
                 _loadData(); // Refresh list
                 scaffoldMessenger.showSnackBar(
                   const SnackBar(content: Text('Student unenrolled successfully'), backgroundColor: AppColors.success),
                 );
               } catch (e) {
                   if (!isMounted) return;
                 scaffoldMessenger.showSnackBar(
                   SnackBar(content: Text('Error unenrolling student: $e'), backgroundColor: AppColors.error),
                 );
               }
             },
           ),
         ],
       ),
     );
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
         actions: [
            // Use FutureBuilder to enable Edit only when student data is loaded
             FutureBuilder<User>(
                future: _studentFuture,
                builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && !snapshot.hasError) {
                      return IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit Student',
                        onPressed: () => _showEditStudentDialog(snapshot.data!),
                      );
                   }
                    return IconButton( // Disabled look
                      icon: Icon(Icons.edit_outlined, color: Colors.white.withOpacity(0.5)),
                      onPressed: null,
                    );
                }
             )
          ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: FutureBuilder<List<dynamic>>( // Wait for both student and course list
            future: Future.wait([_studentFuture, _approvedCoursesFuture]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingIndicator(message: 'Loading student details...');
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading details: ${snapshot.error}', style: AppTextStyles.bodyText1));
              } else if (!snapshot.hasData || snapshot.data!.length != 2) {
                return Center(child: Text('Could not load data.', style: AppTextStyles.bodyText1));
              }

             // Extract data after checks
              final student = snapshot.data![0] as User;
              final approvedCourses = snapshot.data![1] as List<Course>;
              // Update state cache if needed (though FutureBuilder has the latest)
              _currentStudent = student;
              _approvedCourses = approvedCourses;

              final enrolledCourseIds = student.enrollments?.map((c) => c.id).toSet() ?? {};

              return ListView(
                 padding: const EdgeInsets.all(16.0),
                 children: [
                   // --- Student Info Card ---
                    CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(student.username, style: AppTextStyles.headline2),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.email_outlined, 'Email:', student.email),
                            _buildInfoRow(Icons.grade_outlined, 'Grade:', student.grade ?? 'Not Set'),
                            // Add more fields if needed
                        ],
                     ),
                    ),
                     const SizedBox(height: 24),

                   // --- Enrollments Card ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('Enrolled Courses', style: AppTextStyles.headline3),
                          CustomButton(
                             text: 'Enroll Course',
                             icon: Icons.add,
                             onPressed: () => _showEnrollCourseDialog(approvedCourses, enrolledCourseIds.toList()),
                             // Reduce button padding if needed for space
                             // style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8))
                          )
                       ],
                    ),
                     const SizedBox(height: 12),
                     CustomCard(
                        padding: EdgeInsets.zero, // Use ListTile padding
                       child: student.enrollments == null || student.enrollments!.isEmpty
                       ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: Text('Not enrolled in any courses.')),
                       )
                       : ListView.separated(
                           shrinkWrap: true,
                           physics: const NeverScrollableScrollPhysics(),
                           itemCount: student.enrollments!.length,
                           itemBuilder: (context, index) {
                             final enrolledCourse = student.enrollments![index]; // Assumes populated model
                             return ListTile(
                                title: Text(enrolledCourse.name, style: AppTextStyles.bodyText1),
                                subtitle: Text('Subject: ${enrolledCourse.subject ?? 'N/A'} | Status: ${enrolledCourse.status}'),
                                trailing: IconButton(
                                   icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                                   tooltip: 'Unenroll',
                                   onPressed: () => _confirmUnenrollStudent(enrolledCourse.id, enrolledCourse.name),
                                ),
                                // onTap: () { // Optionally navigate to course detail
                                //    Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailScreen(courseId: enrolledCourse.id)));
                                // }
                             );
                           },
                           separatorBuilder: (_, __) => const Divider(height: 1),
                       )
                     ),
                      const SizedBox(height: 24),
                   // --- Potentially add student progress section later ---
                 ]
              );
            },
        ),
      ),
    );
  }

   Widget _buildInfoRow(IconData icon, String label, String value) {
     // Reuse helper from CourseDetailScreen or make it global
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align top for potentially long values
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(label, style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(width: 5),
          Expanded(child: Text(value, style: AppTextStyles.bodyText2)),
        ],
      ),
    );
  }

}
