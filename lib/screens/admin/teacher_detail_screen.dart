// // lib/screens/admin/teacher_detail_screen.dart
// import 'package:flutter/material.dart';
// import '../../services/admin_service.dart';
// import '../../models/user_model.dart';
// import '../../models/course_model.dart';
// import '../../widgets/custom_card.dart';
// import '../../widgets/custom_button.dart';

// class TeacherDetailScreen extends StatefulWidget {
//   final String teacherId;

//   const TeacherDetailScreen({Key? key, required this.teacherId}) : super(key: key);

//   @override
//   _TeacherDetailScreenState createState() => _TeacherDetailScreenState();
// }

// class _TeacherDetailScreenState extends State<TeacherDetailScreen> {
//   late Future<User> _teacher;
//   late Future<List<Course>> _allCourses;

//   @override
//   void initState() {
//     super.initState();
//     _teacher = AdminService().getTeacherById(widget.teacherId);
//     _allCourses = AdminService().getAllCourses();
//   }

//   void _showEditTeacherDialog(User teacher) {
//     final usernameController = TextEditingController(text: teacher.username);
//     final emailController = TextEditingController(text: teacher.email);

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Edit Teacher'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextField(
//                   controller: usernameController,
//                   decoration: const InputDecoration(labelText: 'Username'),
//                 ),
//                 TextField(
//                   controller: emailController,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             CustomButton(
//               text: 'Save',
//               onPressed: () async {
//                 try {
//                   await AdminService().updateTeacher(
//                     teacher.id,
//                     usernameController.text,
//                     emailController.text,
//                   );
//                   Navigator.pop(context);
//                   setState(() {
//                     _teacher = AdminService().getTeacherById(widget.teacherId);
//                   });
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Teacher updated successfully')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error: $e')),
//                   );
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showAssignCourseDialog(List<Course> allCourses, List<String> assignedCourseIds) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Assign Course'),
//           content: SingleChildScrollView(
//             child: Column(
//               children: allCourses.map((course) {
//                 return CheckboxListTile(
//                   title: Text(course.name),
//                   value: assignedCourseIds.contains(course.id),
//                   onChanged: (bool? value) async {
//                     if (value == true) {
//                       try {
//                         await AdminService().assignCourseToTeacher(widget.teacherId, course.id);
//                         Navigator.pop(context);
//                         setState(() {
//                           _teacher = AdminService().getTeacherById(widget.teacherId);
//                         });
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Course assigned successfully')),
//                         );
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Error: $e')),
//                         );
//                       }
//                     }
//                   },
//                 );
//               }).toList(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5EEDC),
//       appBar: AppBar(
//         title: const Text('Teacher Details'),
//         backgroundColor: const Color(0xFF27548A),
//         foregroundColor: Colors.white,
//       ),
//       body: FutureBuilder<User>(
//         future: _teacher,
//         builder: (context, teacherSnapshot) {
//           if (teacherSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (teacherSnapshot.hasError) {
//             return Center(child: Text('Error: ${teacherSnapshot.error}'));
//           } else if (!teacherSnapshot.hasData) {
//             return const Center(child: Text('Teacher not found'));
//           }

//           final teacher = teacherSnapshot.data!;
//           return FutureBuilder<List<Course>>(
//             future: _allCourses,
//             builder: (context, coursesSnapshot) {
//               if (coursesSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final allCourses = coursesSnapshot.data ?? [];
//               final assignedCourseIds = teacher.courses;

//               return SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CustomCard(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             teacher.username,
//                             style: const TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Color(0xFF183B4E),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text('Email: ${teacher.email}'),
//                           const SizedBox(height: 16),
//                           CustomButton(
//                             text: 'Edit Profile',
//                             onPressed: () => _showEditTeacherDialog(teacher),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Assigned Courses',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF183B4E),
//                           ),
//                         ),
//                         CustomButton(
//                           text: 'Assign Course',
//                           onPressed: () => _showAssignCourseDialog(allCourses, assignedCourseIds),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                     teacher.courses.isEmpty
//                         ? CustomCard(
//                             child: const Text('No courses assigned.'),
//                           )
//                         : Column(
//                             children: allCourses
//                                 .where((course) => teacher.courses.contains(course.id))
//                                 .map((course) => CustomCard(
//                                       child: ListTile(
//                                         title: Text(course.name),
//                                         subtitle: Text('Subject: ${course.subject}'),
//                                       ),
//                                     ))
//                                 .toList(),
//                           ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// lib/screens/admin/teacher_detail_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart'; // Ensure service import is correct
import '../../models/user_model.dart';
import '../../models/course_model.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import 'course_detail_screen.dart'; // For navigation

// Helper class to manage the two futures together
class TeacherDetailsData {
  final User? teacher; // Teacher object (User model)
  final List<Course> allCourses; // List of all courses for assignment

  TeacherDetailsData({this.teacher, required this.allCourses});
}


class TeacherDetailScreen extends StatefulWidget {
  final String teacherId;

  const TeacherDetailScreen({super.key, required this.teacherId}); // Use super parameters

  @override
  _TeacherDetailScreenState createState() => _TeacherDetailScreenState();
}

class _TeacherDetailScreenState extends State<TeacherDetailScreen> {
  // Future to hold the combined data
  late Future<TeacherDetailsData> _detailsFuture;
  // Cache data to prevent UI flicker on dialog close/refresh
  TeacherDetailsData _cachedData = TeacherDetailsData(teacher: null, allCourses: []);

  @override
  void initState() {
    super.initState();
    _loadData(); // Load data on initial state
  }

  // Fetches/Refreshes both teacher details and all courses
  Future<void> _loadData() async {
    setState(() {
      // Trigger the future fetch
      _detailsFuture = _fetchTeacherAndCourseData();
    });
    // Update cache upon successful completion
    try {
      _cachedData = await _detailsFuture;
       // Call setState again after caching if needed, though FutureBuilder should handle it
       if (mounted) { setState(() {}); }
    } catch (e) {
      print("Error caching teacher details data: $e");
      if (mounted) {
        // Clear cache on error
        setState(() { _cachedData = TeacherDetailsData(teacher: null, allCourses: []); });
        // Error is handled by FutureBuilder, but log is useful
      }
    }
  }

  // Helper function to fetch data concurrently
  Future<TeacherDetailsData> _fetchTeacherAndCourseData() async {
    try {
      // Fetch concurrently
      final results = await Future.wait([
        AdminService().getTeacherById(widget.teacherId), // Fetches teacher (expects populated courses from User.fromJson fix)
        AdminService().getAllCourses(status: 'approved'), // Fetch only approved courses for assigning
      ]);
      // Basic type checking
      if (results.length == 2 && results[0] is User && results[1] is List<Course>) {
        return TeacherDetailsData(
          teacher: results[0] as User,
          allCourses: results[1] as List<Course>
        );
      } else {
        throw Exception("Unexpected data types returned from API");
      }
    } catch (e) {
      print("Error in _fetchTeacherAndCourseData: $e");
      rethrow; // Rethrow for FutureBuilder
    }
  }


  // --- DIALOG INPUT DECORATION HELPER ---
   InputDecoration dialogInputDecoration(String label) {
     // Use theme defaults, but can customize here if needed
     return InputDecoration(
       labelText: label,
       alignLabelWithHint: true,
       contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
       border: Theme.of(context).inputDecorationTheme.border,
       enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
       focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
       labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
       floatingLabelStyle: Theme.of(context).inputDecorationTheme.floatingLabelStyle,
     );
   }

  // --- EDIT TEACHER DIALOG ---
  void _showEditTeacherDialog(User teacher) {
    final usernameController = TextEditingController(text: teacher.username);
    final emailController = TextEditingController(text: teacher.email);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismiss
      builder: (dialogContext) {
        return Dialog( // Use Dialog for better width control
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            insetPadding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
               constraints: const BoxConstraints(maxWidth: 500), // Max width for web
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   // --- Title ---
                   Padding(
                     padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0),
                     child: Text('Edit Teacher', style: Theme.of(context).dialogTheme.titleTextStyle ?? AppTextStyles.headline3),
                   ),
                   // --- Content ---
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: usernameController,
                                decoration: dialogInputDecoration('Username'),
                                validator: (v) => v == null || v.trim().isEmpty ? 'Username required' : null,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: emailController,
                                decoration: dialogInputDecoration('Email'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                   if (v == null || v.trim().isEmpty) return 'Email required';
                                   if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(v.trim())) return 'Enter a valid email'; // Improved regex
                                   return null;
                                 },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                   // --- Actions ---
                   Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                         mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                           TextButton(
                             onPressed: () => Navigator.pop(dialogContext),
                             child: const Text('Cancel'),
                           ),
                            const SizedBox(width: 8),
                           CustomButton(
                             text: 'Save Changes',
                             icon: Icons.save_outlined,
                             onPressed: () async {
                               if (formKey.currentState!.validate()) {
                                  // Safe Async Pattern
                                  final navigator = Navigator.of(dialogContext);
                                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                                  final isMounted = mounted;

                                  try {
                                    await AdminService().updateTeacher(
                                      teacher.id,
                                      usernameController.text.trim(),
                                      emailController.text.trim(),
                                    );
                                    if (!isMounted) return;
                                    navigator.pop(); // Close dialog
                                    _loadData(); // Refresh teacher details
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(content: Text('Teacher updated successfully'), backgroundColor: AppColors.success),
                                    );
                                  } catch (e) {
                                      if (!isMounted) return;
                                     scaffoldMessenger.showSnackBar(
                                       SnackBar(content: Text('Error updating teacher: $e'), backgroundColor: AppColors.error),
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

  // --- ASSIGN COURSE DIALOG ---
  void _showAssignCourseDialog(User teacher, List<Course> allApprovedCourses) {
     // Use the teacher's course IDs list for checking
     final List<String> assignedCourseIds = teacher.courseIds;

     // Filter available courses
      final availableCourses = allApprovedCourses.where((c) => !assignedCourseIds.contains(c.id)).toList();

     if (availableCourses.isEmpty) {
         ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('No available approved courses to assign.'), backgroundColor: AppColors.textSecondary),);
         return;
     }

     String? selectedCourseId; // Local state for dropdown

     showDialog(
       context: context,
        barrierDismissible: false,
       builder: (dialogContext) {
         return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            insetPadding: const EdgeInsets.all(20.0),
             child: ConstrainedBox(
                 constraints: const BoxConstraints(maxWidth: 500), // Max width
                 child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding( padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 8.0), child: Text('Assign Course to ${teacher.username}', style: Theme.of(context).dialogTheme.titleTextStyle ?? AppTextStyles.headline3),),
                       Flexible(
                         child: SingleChildScrollView(
                           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                           child: StatefulBuilder(
                              builder: (context, setStateDialog) {
                                // Use DropdownSearch or similar package for better UX with many courses
                                // For now, using standard DropdownButtonFormField
                                return DropdownButtonFormField<String>(
                                   value: selectedCourseId,
                                   decoration: dialogInputDecoration('Select an approved course').copyWith( prefixIcon: const Icon(Icons.add_link_outlined) ),
                                   isExpanded: true,
                                   items: availableCourses.map((Course course) => DropdownMenuItem<String>( value: course.id, child: Text("${course.name} (${course.subject ?? ''})", overflow: TextOverflow.ellipsis),)).toList(),
                                   onChanged: (String? newValue) => setStateDialog(() { selectedCourseId = newValue; }),
                                   validator: (value) => value == null ? 'Please select a course' : null,
                                 );
                              }
                           ),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(16.0),
                         child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                               TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
                                const SizedBox(width: 8),
                               CustomButton(
                                  text: 'Assign', icon: Icons.assignment_ind_outlined,
                                  onPressed: () async {
                                     if (selectedCourseId == null) { /* ... show error ... */ return; }
                                     // Safe Async
                                     final navigator = Navigator.of(dialogContext);
                                     final scaffoldMessenger = ScaffoldMessenger.of(context);
                                     final isMounted = mounted;
                                     try {
                                        await AdminService().assignCourseToTeacher(teacher.id, selectedCourseId!);
                                        if (!isMounted) return;
                                        navigator.pop();
                                        _loadData(); // Refresh details
                                        scaffoldMessenger.showSnackBar( const SnackBar(content: Text('Course assigned successfully'), backgroundColor: AppColors.success),);
                                     } catch(e) {
                                         if (!isMounted) return;
                                         scaffoldMessenger.showSnackBar( SnackBar(content: Text('Error assigning course: $e'), backgroundColor: AppColors.error),);
                                     }
                                  },
                               )
                            ]
                         ),
                       )
                    ],
                 )
             )
         );
       }
     );
   }

   // --- Build Info Row Helper ---
   Widget _buildInfoRow(IconData icon, String label, String value) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 6.0), // Slightly more vertical space
       child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Icon(icon, size: 18, color: AppColors.textSecondary),
           const SizedBox(width: 10), // Slightly more space
           Text(label, style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.w600, color: AppColors.textSecondary)), // Label slightly less prominent
           const SizedBox(width: 5),
           Expanded(child: Text(value, style: AppTextStyles.bodyText1)), // Value slightly more prominent
         ],
       ),
     );
   }

   // --- Build Assigned Courses List Helper ---
   Widget _buildAssignedCoursesList(User teacher) {
     // Access populated courses directly from the User model
     // Assumes User.fromJson correctly created List<Course> in populatedCourses
     final List<Course> assignedCourses = teacher.populatedCourses;

     if (assignedCourses.isEmpty) {
       return const Padding(
         padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0), // Center padding
         child: Center(child: Text('No courses currently assigned.', style: TextStyle(fontStyle: FontStyle.italic, color: AppColors.textSecondary))),
       );
     }

     return ListView.separated(
       shrinkWrap: true,
       physics: const NeverScrollableScrollPhysics(),
       itemCount: assignedCourses.length,
       itemBuilder: (context, index) {
         final course = assignedCourses[index];
         return ListTile(
           contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0), // Adjust padding
           leading: Icon(Icons.book_outlined, color: AppColors.secondary.withOpacity(0.7)), // Course icon
           title: Text(course.name, style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.w500)),
           subtitle: Text('Subject: ${course.subject ?? 'N/A'} | Grade: ${course.grade ?? 'N/A'}'),
           trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
           onTap: () => Navigator.push( context, MaterialPageRoute(builder: (_) => CourseDetailScreen(courseId: course.id)), ).then((_) => _loadData()),
         );
       },
       separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
     );
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use themed AppBar
      appBar: AppBar(
        title: const Text('Teacher Details'),
        actions: [
            FutureBuilder<TeacherDetailsData>( // Enable edit based on future
               future: _detailsFuture,
               builder: (context, snapshot) {
                  // Enable only if data loaded successfully AND teacher exists
                  final bool canEdit = snapshot.connectionState == ConnectionState.done && snapshot.hasData && !snapshot.hasError && snapshot.data!.teacher != null;
                   return IconButton(
                     icon: Icon(Icons.edit_outlined, color: canEdit ? Theme.of(context).appBarTheme.actionsIconTheme?.color : Theme.of(context).disabledColor ),
                     tooltip: 'Edit Teacher Profile',
                     onPressed: canEdit ? () => _showEditTeacherDialog(snapshot.data!.teacher!) : null,
                   );
               }
            )
         ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: FutureBuilder<TeacherDetailsData>(
          future: _detailsFuture,
          builder: (context, snapshot) {
            // Use cached data for display while loading/error if available
             final displayData = snapshot.hasData ? snapshot.data! : _cachedData;
             final teacher = displayData.teacher;
             final allCourses = displayData.allCourses;

             // Handle Loading State
             if (snapshot.connectionState == ConnectionState.waiting && teacher == null) {
               return const LoadingIndicator(message: 'Loading teacher details...');
             }
             // Handle Error State
             else if (snapshot.hasError && teacher == null) {
                return Center(child: Padding( padding: const EdgeInsets.all(16.0), child: Text('Error loading details: ${snapshot.error}', style: AppTextStyles.bodyText1.copyWith(color: AppColors.error), textAlign: TextAlign.center)));
             }
             // Handle Not Found or general failure
             else if (teacher == null) {
                return Center(child: Text('Teacher data could not be loaded.', style: AppTextStyles.bodyText1));
             }
final bool canAssign = !(allCourses.isEmpty && snapshot.connectionState != ConnectionState.done);
             // --- Display teacher data ---
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Teacher Info Card
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(teacher.username, style: AppTextStyles.headline2),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.email_outlined, 'Email:', teacher.email),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Assigned Courses Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0, top: 8.0),
                            child: Text('Assigned Courses (${teacher.populatedCourses.length})', style: AppTextStyles.headline3),
                          ),
                          CustomButton(
                            text: 'Assign Course',
                            icon: Icons.add_link_outlined,
                            onPressed: canAssign
                              ? () => _showAssignCourseDialog(teacher, allCourses)
                              : () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomCard(
                        padding: EdgeInsets.zero,
                        child: _buildAssignedCoursesList(teacher)
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}