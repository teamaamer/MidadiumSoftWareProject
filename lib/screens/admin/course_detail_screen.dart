
// lib/screens/admin/course_detail_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/course_model.dart';
import '../../models/user_model.dart'; // For teacher list in edit
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import 'student_detail_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;

  const CourseDetailScreen({Key? key, required this.courseId}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late Future<Course> _courseFuture;
  late Future<List<User>> _teachersFuture; // For edit dialog dropdown
  Course? _currentCourse; // Store current course data

  // Define available subjects/grades (reuse from CoursesScreen or centralize)
  final List<String> _subjects = ['Mathematics', 'Science', 'History', 'English', 'Art', 'Physics', 'Chemistry'];
  final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12'];

  @override
  void initState() {
    super.initState();
    _loadCourseDetails();
    _teachersFuture = AdminService().getAllTeachers(); // Fetch teachers for edit dropdown
  }

  Future<void> _loadCourseDetails() async {
    setState(() {
      _courseFuture = AdminService().getCourseById(widget.courseId);
    });
     try {
      _currentCourse = await _courseFuture;
    } catch (e) {
      print("Error loading course details: $e");
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to load course details: $e'), backgroundColor: AppColors.error),
         );
      }
    }
  }

void _showEditCourseDialog(Course course, List<User> teachers) {
  // Initialize Controllers with existing data
  final nameController = TextEditingController(text: course.name);
  final descriptionController = TextEditingController(text: course.description);
  final syllabusController = TextEditingController(text: course.syllabus ?? '');
  final resourcesController = TextEditingController(text: course.resources ?? '');

  // Validate initial dropdown values to prevent errors if data is inconsistent
  final validTeacherIds = teachers.map((t) => t.id).toSet();
  String? initialTeacherId = validTeacherIds.contains(course.teacherId) ? course.teacherId : null;

  // Assuming _subjects and _grades lists are defined in the State class
  String? initialSubject = _subjects.contains(course.subject) ? course.subject : null;
  String? initialGrade = _grades.contains(course.grade) ? course.grade : null;

  // State variables for dropdowns within the dialog
  String? selectedTeacherId = initialTeacherId;
  String? selectedSubject = initialSubject;
  String? selectedGrade = initialGrade;

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Helper for consistent Input Decoration within the dialog
  InputDecoration dialogInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true, // Helps with multi-line field labels
      // Adjust padding for label visibility if needed
      contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      // floatingLabelBehavior: FloatingLabelBehavior.always, // Alternative
      // Inherit border styles from the main theme
      border: Theme.of(context).inputDecorationTheme.border,
      enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
      focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
      floatingLabelStyle: Theme.of(context).inputDecorationTheme.floatingLabelStyle, // Ensure floating label style is used
      // Add prefix icons if desired
      // prefixIcon: Icon( /* Choose appropriate icon */, color: AppColors.textSecondary),
    );
  }

  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside during edit
    builder: (dialogContext) { // Use a specific context for the dialog
      // Use Dialog Widget for better width control
      return Dialog(
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
         insetPadding: const EdgeInsets.all(20.0), // Padding around the dialog
         child: ConstrainedBox( // Constrain the Dialog's Child
            constraints: const BoxConstraints(
               maxWidth: 700, // Set desired max width here
               // Optional: Limit height
               maxHeight: 650 // Prevent excessively tall dialogs on large screens
            ),
            // Overall structure within the dialog
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fit content height
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- Dialog Title ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0),
                  child: Text(
                     'Edit Course',
                      style: Theme.of(context).dialogTheme.titleTextStyle ?? AppTextStyles.headline3,
                   ),
                ),

                // --- Scrollable Form Content ---
                 Flexible( // Make the form content scrollable and flexible
                   child: StatefulBuilder( // Needed for dropdown state updates
                    builder: (BuildContext context, StateSetter setStateDialog) {
                      return SingleChildScrollView(
                          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 16.0), // Padding for form
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Form Fields using dialogInputDecoration
                                const SizedBox(height: 12), // Top spacing inside form
                                TextFormField(
                                  controller: nameController,
                                  decoration: dialogInputDecoration('Course Name'),
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: selectedTeacherId,
                                  decoration: dialogInputDecoration('Assign Teacher'),
                                  isExpanded: true,
                                  items: teachers.map((User teacher) => DropdownMenuItem<String>(
                                      value: teacher.id, child: Text(teacher.username, overflow: TextOverflow.ellipsis))).toList(),
                                  onChanged: (String? newValue) => setStateDialog(() { selectedTeacherId = newValue; }),
                                  validator: (v) => v == null ? 'Teacher required' : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: selectedSubject,
                                  decoration: dialogInputDecoration('Subject'),
                                  isExpanded: true,
                                  items: _subjects.map((String subject) => DropdownMenuItem<String>(
                                      value: subject, child: Text(subject))).toList(),
                                  onChanged: (String? newValue) => setStateDialog(() { selectedSubject = newValue; }),
                                  validator: (v) => v == null ? 'Subject required' : null,
                                ),
                                const SizedBox(height: 16),
                                DropdownButtonFormField<String>(
                                  value: selectedGrade,
                                  decoration: dialogInputDecoration('Grade'),
                                  isExpanded: true,
                                  items: _grades.map((String grade) => DropdownMenuItem<String>(
                                      value: grade, child: Text(grade))).toList(),
                                  onChanged: (String? newValue) => setStateDialog(() { selectedGrade = newValue; }),
                                  validator: (v) => v == null ? 'Grade required' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: dialogInputDecoration('Description'),
                                  maxLines: 3,
                                  minLines: 1, // Ensure it starts small
                                  validator: (v) => v == null || v.trim().isEmpty ? 'Description required' : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: syllabusController,
                                  decoration: dialogInputDecoration('Syllabus (Optional)'),
                                  maxLines: 4,
                                  minLines: 1,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: resourcesController,
                                  decoration: dialogInputDecoration('Resources (Optional)'),
                                  maxLines: 4,
                                  minLines: 1,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                   ),
                 ),

                 Padding(
                    padding: const EdgeInsets.all(16.0), // Standard padding for actions
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
                       children: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            text: 'Save Changes',
                            icon: Icons.save_alt_outlined,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                 if (selectedTeacherId == null || selectedSubject == null || selectedGrade == null) {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please ensure Teacher, Subject, and Grade are selected.'), backgroundColor: AppColors.error),
                                    );
                                    return;
                                 }
                                 final updatePayload = {
                                   "name": nameController.text.trim(),
                                   "description": descriptionController.text.trim(),
                                   "subject": selectedSubject!,
                                   "grade": selectedGrade!,
                                   "teacher": selectedTeacherId!,
                                   "syllabus": syllabusController.text.trim(),
                                   "resources": resourcesController.text.trim(),
                                 };
                                 // Use Safe Async Pattern
                                 final navigator = Navigator.of(dialogContext);
                                 final scaffoldMessenger = ScaffoldMessenger.of(context);
                                 final isMounted = mounted;

                                 try {
                                   await AdminService().updateCourse(widget.courseId, updatePayload);
                                   if (!isMounted) return;
                                   navigator.pop();
                                   _loadCourseDetails(); // Refresh main screen
                                   scaffoldMessenger.showSnackBar(
                                     const SnackBar(content: Text('Course updated successfully'), backgroundColor: AppColors.success),
                                   );
                                 } catch (e) {
                                    if (!isMounted) return;
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(content: Text('Error updating course: $e'), backgroundColor: AppColors.error),
                                    );
                                 }
                              }
                            },
                          ),
                       ],
                    ),
                 ),
              ],
            ),
          ),
      );
    },
  );
}
   Future<void> _updateCourseStatus(String action) async {
      if (_currentCourse == null) return;

      String successMessage = '';
      String errorMessage = '';
      Function apiCall;

      if (action == 'approve') {
        apiCall = AdminService().approveCourse;
        successMessage = 'Course approved successfully';
        errorMessage = 'Failed to approve course';
      } else if (action == 'reject') {
        apiCall = AdminService().rejectCourse;
        successMessage = 'Course rejected successfully';
        errorMessage = 'Failed to reject course';
      } else {
        return; // Invalid action
      }

       try {
          await apiCall(_currentCourse!.id);
          _loadCourseDetails(); // Refresh the details
          if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text(successMessage), backgroundColor: AppColors.success),
              );
          }
       } catch (e) {
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$errorMessage: $e'), backgroundColor: AppColors.error),
           );
         }
       }
   }

  Color _getStatusColor(String status) { // Duplicated from CoursesScreen, consider centralizing
    switch (status.toLowerCase()) {
      case 'approved': return AppColors.approved;
      case 'rejected': return AppColors.error;
      case 'pending': return AppColors.pending;
      default: return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) { // Duplicated from CoursesScreen, consider centralizing
    switch (status.toLowerCase()) {
      case 'approved': return Icons.check_circle_outline;
      case 'rejected': return Icons.cancel_outlined;
      case 'pending': return Icons.hourglass_empty_outlined;
      default: return Icons.help_outline;
    }
  }

  //////////////////////
  void _confirmUnenrollStudentFromCourse(User student, String courseId, String courseName) {
    showDialog(
       context: context,
       builder: (dialogContext) => AlertDialog(
         title: const Text('Confirm Unenrollment'),
         content: Text('Are you sure you want to unenroll student "${student.username}" from "$courseName"?'),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(dialogContext),
             child: const Text('Cancel'),
           ),
           CustomButton(
             text: 'Unenroll',
             backgroundColor: AppColors.error,
             onPressed: () async {
                 final navigator = Navigator.of(dialogContext);
                 final scaffoldMessenger = ScaffoldMessenger.of(context);
                 final isMounted = mounted;
                navigator.pop(); // Close dialog first
               try {
                 await AdminService().unenrollStudentFromCourse(student.id, courseId);
                  if (!isMounted) return;
                 _loadCourseDetails(); // Refresh course details (to update student list)
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

  // *** ADD HELPER WIDGET FOR STUDENT LIST ***
   Widget _buildEnrolledStudentsList(List<User> students, String courseId) {
      if (students.isEmpty) {
          return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('No students enrolled in this course.')),
          );
      }
      return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
              final student = students[index];
              return ListTile(
                  leading: CircleAvatar(
                     backgroundColor: AppColors.accent.withAlpha((255 * 0.15).round()),
                     child: Text( student.username.isNotEmpty ? student.username[0].toUpperCase() : 'S'),
                     foregroundColor: AppColors.accent,
                  ),
                  title: Text(student.username, style: AppTextStyles.bodyText1),
                  subtitle: Text(student.email, style: AppTextStyles.caption),
                  trailing: IconButton(
                      icon: Icon(Icons.person_remove_outlined, color: AppColors.error),
                      tooltip: 'Unenroll Student',
                      onPressed: () => _confirmUnenrollStudentFromCourse(student, courseId, _currentCourse?.name ?? 'this course'),
                  ),
                  onTap: () { // Navigate to student detail
                      Navigator.push(context, MaterialPageRoute(builder: (_) => StudentDetailScreen(studentId: student.id)));
                  },
              );
          },
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
      );
    }
  
  // *** ADD DELETE COURSE CONFIRMATION DIALOG ***
  void _confirmDeleteCourse(String courseId, String courseName) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Delete Course'),
        content: Text('Are you sure you want to permanently delete the course "$courseName"?\n\nThis will unenroll all students and remove it from the assigned teacher. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          CustomButton(
            text: 'Delete Course',
            backgroundColor: AppColors.error,
            icon: Icons.delete_forever,
            onPressed: () async {
              // --- Capture context & mounted state ---
              final navigator = Navigator.of(context); // Use context from the main screen for final pop
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final isMounted = mounted;

              Navigator.pop(dialogContext); // Close the confirmation dialog

              try {
                // Call the service method
                await AdminService().removeCourse(courseId);

                if (!isMounted) return;

                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Course deleted successfully'), backgroundColor: AppColors.success),
                );

                // Navigate back to the previous screen (likely CoursesScreen)
                navigator.pop();

              } catch (e) {
                if (!isMounted) return;
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('Error deleting course: $e'), backgroundColor: AppColors.error),
                );
              }
            },
          ),
        ],
      ),
    );
  }
 //////////////////////////////////////
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        actions: [
          // *** Modify the Edit Button Logic ***
          // We need both the course data AND the teacher list for the dialog.
          // So, let's use a FutureBuilder that waits for BOTH futures.
          FutureBuilder<List<dynamic>>( // Wait for a list containing Course and List<User>
            // Use Future.wait to combine the two futures
            future: Future.wait([_courseFuture, _teachersFuture]),
            builder: (context, combinedSnapshot) {
              bool isReady = false;
              List<User>? teachers;

              // Check if both futures completed successfully
              if (combinedSnapshot.connectionState == ConnectionState.done &&
                  !combinedSnapshot.hasError &&
                  combinedSnapshot.hasData &&
                  combinedSnapshot.data!.length == 2) {

                    // You might need to cast depending on strictness
                    final courseData = combinedSnapshot.data![0] as Course?; // Result of _courseFuture
                    final teacherData = combinedSnapshot.data![1] as List<User>?; // Result of _teachersFuture

                    if (courseData != null && teacherData != null) {
                       isReady = true;
                       teachers = teacherData;
                       // Ensure _currentCourse is updated if it wasn't already
                       // (This might be redundant if _loadCourseDetails works, but safe)
                       if (_currentCourse == null) {
                           WidgetsBinding.instance.addPostFrameCallback((_) {
                              if(mounted) {
                                setState(() => _currentCourse = courseData);
                              }
                           });
                       }
                    }
              }

              // Enable button only if both futures are done, successful,
              // and we have a non-null _currentCourse (set above or by _loadCourseDetails)
              // and the teacher list.
              if (isReady && _currentCourse != null && teachers != null) {
                return IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit Course',
                  onPressed: () => _showEditCourseDialog(_currentCourse!, teachers!), // Pass fetched teachers
                );
              } else {
                // Show disabled button while loading or if error
                return IconButton(
                  icon: Icon(Icons.edit_outlined, color: Colors.white.withOpacity(0.5)),
                  onPressed: null,
                );
              }
            },
          ),

       FutureBuilder<Course>( // Only need course future to know if course exists
              future: _courseFuture,
              builder: (context, courseSnapshot) {
                  // Enable delete only if the course has loaded successfully
                  if (courseSnapshot.connectionState == ConnectionState.done &&
                      courseSnapshot.hasData &&
                      !courseSnapshot.hasError) {
                      final course = courseSnapshot.data!;
                      return IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error), // Use error color for emphasis
                          tooltip: 'Delete Course',
                          onPressed: () => _confirmDeleteCourse(course.id, course.name), // Call confirmation
                      );
                  } else {
                      // Show disabled delete button while loading or on error
                      return IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.white.withOpacity(0.5)),
                          onPressed: null,
                      );
                  }
              },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCourseDetails,
        color: AppColors.primary,
        child: FutureBuilder<Course>(
          // Body still uses only the course future for its main content
          future: _courseFuture,
          builder: (context, snapshot) {
            // Keep the existing body FutureBuilder logic
            if (snapshot.connectionState == ConnectionState.waiting && _currentCourse == null) { // Show loading only if _currentCourse isn't set yet
              return const LoadingIndicator(message: 'Loading course details...');
            } else if (snapshot.hasError) {
               // Prioritize showing loaded data if available, else show error
              if (_currentCourse == null) {
                  return Center(child: Text('Error loading course: ${snapshot.error}', style: AppTextStyles.bodyText1));
              }
              // If course loaded previously but future failed on refresh, still show course? Or error?
              // Let's stick to showing error if the future itself failed.
               return Center(child: Text('Error refreshing course: ${snapshot.error}', style: AppTextStyles.bodyText1));

            } else if (!snapshot.hasData && _currentCourse == null) { // Check both future result and state variable
              return Center(child: Text('Course not found.', style: AppTextStyles.bodyText1));
            }

            // Use snapshot.data if available and valid, otherwise fallback to _currentCourse if it exists (e.g., during refresh error)
            final course = snapshot.hasData ? snapshot.data! : _currentCourse;

            // Add a null check for course before proceeding
            if (course == null) {
               return Center(child: Text('Course data is unavailable.', style: AppTextStyles.bodyText1));
            }

            // --- Rest of the body rendering using 'course' ---
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomCard( /* ... Course Header Card ... */
                     child: Column(
                      children: [ // Children of the main content Column inside the Card
                              Row( // Row for Title and Status Badge
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Text(course.name, style: AppTextStyles.headline2)),
                                  const SizedBox(width: 16),
                                  Container( /* Status Badge */ ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(Icons.person_outline, 'Teacher:', course.teacherName),
                              _buildInfoRow(Icons.subject_outlined, 'Subject:', course.subject),
                              _buildInfoRow(Icons.grade_outlined, 'Grade:', course.grade),
                              const SizedBox(height: 20),

                              // --- Action Buttons Row ---
                              // Ensure this Row takes available width and aligns content right
                              Row( // This Row
                           mainAxisAlignment:MainAxisAlignment.end , // Align buttons right
                           children: [
                             if (course.status == 'pending') ...[
                               CustomButton(
                                 text: 'Reject',
                                 icon: Icons.cancel_outlined,
                                 backgroundColor: AppColors.error.withOpacity(0.15), // Lighter background
                                 textColor: AppColors.error,
                                 elevation: 0,
                                 onPressed: () => _updateCourseStatus('reject'),
                               ),
                               const SizedBox(width: 12),
                               CustomButton(
                                 text: 'Approve',
                                 icon: Icons.check_circle_outline,
                                 backgroundColor: AppColors.success, // Solid color for primary action
                                 onPressed: () => _updateCourseStatus('approve'),
                               ),
                             ],
                              if (course.status == 'rejected')
                                CustomButton(
                                 text: 'Re-Approve', // Or 'Approve'
                                 icon: Icons.check_circle_outline,
                                 backgroundColor: AppColors.success,
                                 onPressed: () => _updateCourseStatus('approve'),
                               ),
                              if (course.status == 'approved')
                                 CustomButton(
                                   text: 'Mark as Pending', // Or 'Unapprove'
                                   icon: Icons.hourglass_empty_outlined,
                                   
                                   backgroundColor: AppColors.pending.withOpacity(0.15),
                                   textColor: AppColors.pending,
                                   elevation: 0,
                                   onPressed: () {
                                     // Need backend endpoint for this potentially
                                     ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Functionality to mark as pending not implemented yet.')),
                                      );
                                   },
                                 ),
                           ],
                         ),],
                    ),
             

                    ),

                  
                  const SizedBox(height: 24),
                  Text('Course Content', style: AppTextStyles.headline3), // --- Course Content Card ---
                  const SizedBox(height: 12),
                  CustomCard( /* ... Content Details ... */
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailSection('Description', course.description),
                        if (course.syllabus != null && course.syllabus!.isNotEmpty)
                          _buildDetailSection('Syllabus', course.syllabus!),
                        if (course.resources != null && course.resources!.isNotEmpty)
                          _buildDetailSection('Resources', course.resources!),

                        if ((course.syllabus == null || course.syllabus!.isEmpty) && (course.resources == null || course.resources!.isEmpty))
                           Text("No syllabus or resources provided.", style: AppTextStyles.bodyText2.copyWith(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                   const SizedBox(height: 24),
                   // *** ADD ENROLLED STUDENTS SECTION ***
                  Text('Enrolled Students (${course.students.length})', style: AppTextStyles.headline3), // Show count
                  const SizedBox(height: 12),
                  CustomCard(
                     padding: EdgeInsets.zero, // Remove default padding
                     child: _buildEnrolledStudentsList(course.students, course.id) // Pass students list and courseId
                  ),
                  const SizedBox(height: 24),
                  // *** END ENROLLED STUDENTS SECTION ***
                ],
              ),////////// inside this 
            );
          },
        ),
      ),
    );
  }

  // ... rest of the methods (_loadCourseDetails, _showEditCourseDialog, _updateCourseStatus, _getStatusColor, _getStatusIcon, _buildInfoRow, _buildDetailSection)
///////////////////////
  // Helper widget for info rows
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
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

   // Helper widget for detail sections
  Widget _buildDetailSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.subtitle1.copyWith(color: AppColors.primary),
          ),
          const Divider(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyText2,
          ),
        ],
      ),
    );
  }
}