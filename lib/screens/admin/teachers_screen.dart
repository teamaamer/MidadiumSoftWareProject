// lib/screens/admin/teachers_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import 'teacher_detail_screen.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen({Key? key}) : super(key: key);

  @override
  TeachersScreenState createState() => TeachersScreenState();
}

class TeachersScreenState extends State<TeachersScreen> {
  late Future<List<User>> _teachersFuture;
  List<User> _allTeachers = [];
  List<User> _filteredTeachers = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTeachers();
    _searchController.addListener(_filterTeachers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTeachers);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeachers() async {
    setState(() {
      _teachersFuture = AdminService().getAllTeachers();
    });
    try {
      _allTeachers = await _teachersFuture;
      _filterTeachers(); // Initial filter
    } catch (e) {
      // Error is handled by FutureBuilder, but you could log it here
      print("Error loading teachers: $e");
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to load teachers: $e'), backgroundColor: AppColors.error),
         );
       }
    }
  }

  void _filterTeachers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTeachers = _allTeachers.where((teacher) {
        return teacher.username.toLowerCase().contains(query) ||
               teacher.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _showAddTeacherDialog() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>(); // For validation

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Teacher'),
          content: SingleChildScrollView(
            child: Form( // Wrap content in a Form
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Prevent dialog stretching
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline)),
                    validator: (value) => value == null || value.isEmpty ? 'Username required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                    keyboardType: TextInputType.emailAddress,
                     validator: (value) {
                       if (value == null || value.isEmpty) return 'Email required';
                       if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) return 'Enter a valid email';
                       return null;
                     },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                    obscureText: true,
                     validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            CustomButton( // Use CustomButton
              text: 'Add Teacher',
              icon: Icons.add,
              onPressed: () async {
                 if (formKey.currentState!.validate()) { // Validate the form
                   try {
                     await AdminService().addTeacher(
                       usernameController.text,
                       emailController.text,
                       passwordController.text,
                     );
                     Navigator.pop(context); // Close dialog on success
                     _loadTeachers(); // Refresh the list
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Teacher added successfully'), backgroundColor: AppColors.success),
                     );
                   } catch (e) {
                      // Keep dialog open on error
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Error adding teacher: $e'), backgroundColor: AppColors.error),
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
void showAddTeacherDialogFromDashboard() {
     // Ensure the context used is valid when called externally
    if (mounted) {
      _showAddTeacherDialog();
    } else {
       print("Warning: Tried to show Add Teacher dialog when widget was not mounted.");
    }
  }
  void _confirmDeleteTeacher(User teacher) {
     showDialog(
       context: context,
       builder: (dialogContext) => AlertDialog(
         title: const Text('Confirm Deletion'),
         content: Text('Are you sure you want to delete teacher "${teacher.username}"? This action cannot be undone.'),
         actions: [
           TextButton(
             onPressed: () => Navigator.pop(dialogContext),
             child: const Text('Cancel'),
           ),
           CustomButton(
             text: 'Delete',
             backgroundColor: AppColors.error,
             icon: Icons.delete_forever,
             onPressed: () async {
               final navigator = Navigator.of(dialogContext);
               final scaffoldMessenger = ScaffoldMessenger.of(context);
               final bool isMounted = mounted;

               navigator.pop(); // Pop the first dialog

               try {
                 // Attempt the simple delete first
                 await AdminService().deleteTeacher(teacher.id);

                 if (!isMounted) return;
                 _loadTeachers();
                 scaffoldMessenger.showSnackBar(
                   const SnackBar(content: Text('Teacher deleted successfully'), backgroundColor: AppColors.success),
                 );

               } catch (e) {
                  // *** Catch the specific exception ***
                  if (e is TeacherHasCoursesException) {
                      if (!isMounted) return;
                      // Call the second dialog function, passing the necessary data
                      _showDeleteWithCoursesConfirmation(teacher, e);
                  }
                  // Handle other errors
                  else {
                     if (!isMounted) return;
                     scaffoldMessenger.showSnackBar(
                       SnackBar(content: Text('Error deleting teacher: $e'), backgroundColor: AppColors.error),
                     );
                  }
               }
             },
           ),
         ],
       ),
     );
  }
     void _showDeleteWithCoursesConfirmation(User teacher, TeacherHasCoursesException coursesException) {
    final courseNames = coursesException.courseNames;
    final courseIds = coursesException.courseIds;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Teacher Has Courses'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Teacher "${teacher.username}" is assigned to the following course(s):'),
              const SizedBox(height: 10),
              if (courseNames.isNotEmpty)
                ...courseNames.map((name) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text('- $name', style: const TextStyle(fontWeight: FontWeight.bold))
                ))
              else
                ...courseIds.map((id) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Text('- Course ID: $id')
                )),
              const SizedBox(height: 15),
              // *** Clarify the options ***
              const Text('Choose an action:'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          // --- Option 1: Delete Teacher Only (Keep Courses) ---
          TextButton( // Use TextButton for less emphasis than the destructive option
            onPressed: () async {
               final navigator = Navigator.of(dialogContext);
               final scaffoldMessenger = ScaffoldMessenger.of(context);
               final bool isMounted = mounted;
               navigator.pop(); // Pop the dialog

               try {
                 // Call the NEW service method
                 await AdminService().deleteTeacherKeepCourses(teacher.id);
                 if (!isMounted) return;
                 _loadTeachers();
                 scaffoldMessenger.showSnackBar(
                   const SnackBar(content: Text('Teacher deleted. Courses unassigned.'), backgroundColor: AppColors.success),
                 );
               } catch (e) {
                  if (!isMounted) return;
                  scaffoldMessenger.showSnackBar(
                     SnackBar(content: Text('Error deleting teacher only: $e'), backgroundColor: AppColors.error),
                  );
               }
            },
            child: const Text('Delete Teacher Only'),
          ),
          // --- Option 2: Delete Teacher AND Courses ---
          CustomButton( // Keep this more prominent as it's more destructive
            text: 'Delete Teacher & Courses', // Clarify button text
            backgroundColor: AppColors.error,
            icon: Icons.delete_sweep_outlined, // Different icon maybe
            onPressed: () async {
              final navigator = Navigator.of(dialogContext);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final bool isMounted = mounted;
              navigator.pop(); // Pop the dialog

              try {
                // Call the existing service to delete teacher AND courses
                await AdminService().deleteTeacherAndCourses(teacher.id, courseIds);
                if (!isMounted) return;
                _loadTeachers();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Teacher and associated courses deleted.'), backgroundColor: AppColors.success),
                );
              } catch (e) {
                if (!isMounted) return;
                scaffoldMessenger.showSnackBar(
                   SnackBar(content: Text('Error deleting teacher and courses: $e'), backgroundColor: AppColors.error),
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
    return Column( // Main layout
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration( // Uses theme styles
                hintText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          // _filterTeachers(); // Filter will be called by listener
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator( // Add pull-to-refresh
              onRefresh: _loadTeachers,
              color: AppColors.primary,
              child: FutureBuilder<List<User>>(
                future: _teachersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && _allTeachers.isEmpty) {
                    return const LoadingIndicator(message: 'Loading teachers...');
                  } else if (snapshot.hasError && _allTeachers.isEmpty) {
                    return Center(child: Text('Error: ${snapshot.error}', style: AppTextStyles.bodyText1));
                  } else if (_allTeachers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_off_outlined, size: 60, color: AppColors.textSecondary),
                          const SizedBox(height: 16),
                          Text('No teachers found.', style: AppTextStyles.subtitle1),
                          const SizedBox(height: 8),
                          Text('Add a new teacher using the + button above.', style: AppTextStyles.bodyText2, textAlign: TextAlign.center,),
                        ],
                      ),
                    );
                  } else if (_filteredTeachers.isEmpty && _searchController.text.isNotEmpty) {
                     return Center(child: Text('No teachers match your search.', style: AppTextStyles.bodyText1));
                  }

                  // Display the filtered list
                  return ListView.separated(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 90.0), // Adjust bottom padding for FAB
                    itemCount: _filteredTeachers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 0), // Cards have their own margin
                    itemBuilder: (context, index) {
                      final teacher = _filteredTeachers[index];
                      return CustomCard( // Use CustomCard for each item
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeacherDetailScreen(teacherId: teacher.id),
                            ),
                          ).then((_) => _loadTeachers()); // Refresh on return
                        },
                        child: ListTile(
                           leading: CircleAvatar(
                             backgroundColor: AppColors.primary.withOpacity(0.1),
                             child: Text(
                               teacher.username.isNotEmpty ? teacher.username[0].toUpperCase() : 'T',
                               style: AppTextStyles.subtitle1.copyWith(color: AppColors.primary),
                             ),
                           ),
                          title: Text(teacher.username, style: AppTextStyles.subtitle1),
                          subtitle: Text(teacher.email, style: AppTextStyles.bodyText2),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error),
                            tooltip: 'Delete Teacher',
                            onPressed: () => _confirmDeleteTeacher(teacher),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
           // Floating Action Button for adding
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
               heroTag: 'fab_teachers',
              onPressed: _showAddTeacherDialog,
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.secondary,
              tooltip: 'Add Teacher',
              child: const Icon(Icons.add),
            ),
          )
        ],
      );
  }
}