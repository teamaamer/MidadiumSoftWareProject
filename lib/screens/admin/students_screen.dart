// lib/screens/admin/students_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/user_model.dart'; // Using User model for students
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/filter_chip.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import 'student_detail_screen.dart'; // We will create this next

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  StudentsScreenState createState() => StudentsScreenState();
}

class StudentsScreenState extends State<StudentsScreen> {
  late Future<List<User>> _studentsFuture;
  List<User> _allStudents = [];
  List<User> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();
  String? _gradeFilter; // Add grade filter

  // Define example grades - adjust or load dynamically if needed
  final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12', 'Other'];


  @override
  void initState() {
    super.initState();
    _loadStudents();
    _searchController.addListener(_filterStudents);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterStudents);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _studentsFuture = AdminService().getAllStudents(grade: _gradeFilter, search: _searchController.text);
    });
    try {
      _allStudents = await _studentsFuture;
      _filterStudents(); // Apply filters after fetching
    } catch (e) {
      print("Error loading students: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load students: $e'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  void _filterStudents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = _allStudents.where((student) {
        final gradeMatch = _gradeFilter == null || (student.grade != null && student.grade == _gradeFilter);
        final searchMatch = query.isEmpty ||
                           student.username.toLowerCase().contains(query) ||
                           student.email.toLowerCase().contains(query);
        return gradeMatch && searchMatch;
      }).toList();
    });
     // No need to call _loadStudents here if filtering locally after initial load
     // If search/filter should trigger backend query directly, modify _loadStudents call.
     // For simplicity, we filter locally after the fetch controlled by _loadStudents.
     // If you expect thousands of students, backend filtering is better.
     // If filtering locally, we don't need the 'search' param in _loadStudents above
  }

  void _setGradeFilter(String? grade) {
     setState(() {
       _gradeFilter = (_gradeFilter == grade) ? null : grade; // Toggle or set null for "All"
       // Reload data from backend based on the new filter
       _loadStudents();
       // Or, if filtering locally:
       // _filterStudents();
     });
  }

  void _showAddStudentDialog() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedGrade; // Use String? for dropdown state
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add New Student'),
          content: StatefulBuilder( // Needed for dropdown state update
             builder: (BuildContext context, StateSetter setStateDialog) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        validator: (value) { /* ... email validation ... */
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
                       const SizedBox(height: 16),
                       // Grade Dropdown
                       DropdownButtonFormField<String>(
                         value: selectedGrade,
                         decoration: const InputDecoration(labelText: 'Grade Level', prefixIcon: Icon(Icons.grade_outlined)),
                         items: _grades.map((String grade) {
                           return DropdownMenuItem<String>(
                             value: grade,
                             child: Text(grade),
                           );
                         }).toList(),
                         onChanged: (String? newValue) {
                           setStateDialog(() { selectedGrade = newValue; });
                         },
                         validator: (value) => value == null ? 'Grade required' : null,
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
              text: 'Add Student',
              icon: Icons.add,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // --- Capture context & mounted state ---
                   final navigator = Navigator.of(dialogContext);
                   final scaffoldMessenger = ScaffoldMessenger.of(context);
                   final isMounted = mounted;

                  try {
                    // Call service to add student
                    await AdminService().addStudent(
                      usernameController.text,
                      emailController.text,
                      passwordController.text,
                      selectedGrade!, // Use selected grade
                    );

                    if (!isMounted) return;
                    navigator.pop(); // Close dialog
                    _loadStudents(); // Refresh list
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Student added successfully'), backgroundColor: AppColors.success),
                    );
                  } catch (e) {
                     if (!isMounted) return;
                     // Keep dialog open
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Error adding student: $e'), backgroundColor: AppColors.error),
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

   // Public method for external trigger (from dashboard)
   void showAddStudentDialogFromDashboard() {
    if (mounted) {
      _showAddStudentDialog();
    } else {
      print("Warning: Tried to show Add Student dialog when widget was not mounted.");
    }
  }


  void _confirmDeleteStudent(User student) {
     showDialog(
       context: context,
       builder: (dialogContext) => AlertDialog(
         title: const Text('Confirm Deletion'),
         content: Text('Are you sure you want to delete student "${student.username}"?\nTheir enrollments will be removed. This action cannot be undone.'),
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
                // --- Capture context & mounted state ---
                 final navigator = Navigator.of(dialogContext);
                 final scaffoldMessenger = ScaffoldMessenger.of(context);
                 final isMounted = mounted;

                navigator.pop(); // Close dialog first

               try {
                 // Call service to delete student
                 await AdminService().deleteStudent(student.id);

                  if (!isMounted) return;
                 _loadStudents(); // Refresh list
                 scaffoldMessenger.showSnackBar(
                   const SnackBar(content: Text('Student deleted successfully'), backgroundColor: AppColors.success),
                 );
               } catch (e) {
                   if (!isMounted) return;
                 scaffoldMessenger.showSnackBar(
                   SnackBar(content: Text('Error deleting student: $e'), backgroundColor: AppColors.error),
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
    return Column(
      children: [
        // --- Search ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by name or email...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton( icon: const Icon(Icons.clear), onPressed: () => _searchController.clear())
                  : null,
            ),
            // You might want to trigger _filterStudents or _loadStudents on change/submit
            // onChanged: (value) => _filterStudents(), // Example: filter locally as user types
             onEditingComplete: _loadStudents, // Example: Refresh data from backend on submit
          ),
        ),
         // --- Grade Filters ---
          Padding(
             padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
             child: SingleChildScrollView(
               scrollDirection: Axis.horizontal,
               child: Wrap(
                spacing: 8.0, // Horizontal space between chips
               runSpacing: 8.0, // Vertical space if chips wrap
                 children: [
                    CustomFilterChip(
                      label: 'All Grades',
                      isSelected: _gradeFilter == null,
                      onSelected: () => _setGradeFilter(null),
                    ),
                    ..._grades.map((grade) => //Padding( // Map through defined grades
                     // padding: const EdgeInsets.only(left: 8.0),
                       CustomFilterChip(
                        label: grade,
                        isSelected: _gradeFilter == grade,
                        onSelected: () => _setGradeFilter(grade),
                      )
                    ).toList(),
                 ],
               ),
             ),
          ),

        // --- Student List ---
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadStudents,
            color: AppColors.primary,
            child: FutureBuilder<List<User>>(
              future: _studentsFuture,
              builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.waiting && _allStudents.isEmpty) {
                   return const LoadingIndicator(message: 'Loading students...');
                 } else if (snapshot.hasError && _allStudents.isEmpty) {
                    return Center(child: Text('Error: ${snapshot.error}', style: AppTextStyles.bodyText1, textAlign: TextAlign.center));
                 } else if (_allStudents.isEmpty) {
                   return Center( /* No students message */
                       child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Icon(Icons.people_outline, size: 60, color: AppColors.textSecondary),
                         const SizedBox(height: 16),
                         Text('No students found.', style: AppTextStyles.subtitle1),
                         const SizedBox(height: 8),
                         Text('Add a new student using the + button below.', style: AppTextStyles.bodyText2, textAlign: TextAlign.center,),
                       ],
                     ),
                   );
                 } else if (_filteredStudents.isEmpty) {
                    return Center(child: Text('No students match your filters.', style: AppTextStyles.bodyText1));
                 }

                // Display filtered students
                return ListView.separated(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 90.0),
                  itemCount: _filteredStudents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final student = _filteredStudents[index];
                    return CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentDetailScreen(studentId: student.id),
                          ),
                          // Refresh student list when returning from detail screen
                        ).then((_) => _loadStudents());
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.accent.withAlpha((255 * 0.15).round()),
                          child: Text(
                            student.username.isNotEmpty ? student.username[0].toUpperCase() : 'S',
                            style: AppTextStyles.subtitle1.copyWith(color: AppColors.accent),
                          ),
                        ),
                        title: Text(student.username, style: AppTextStyles.subtitle1),
                        subtitle: Text('${student.email}\nGrade: ${student.grade ?? 'N/A'}', style: AppTextStyles.bodyText2),
                        // Only show enrollments count if we have populated data
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (student.enrollments.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Text('${student.enrollments.length} courses', style: AppTextStyles.caption),
                              ),
       ]) ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        // --- FAB ---
        Padding(
         
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
             heroTag: 'fab_students',
            onPressed: _showAddStudentDialog,
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.secondary,
            tooltip: 'Add Student',
            child: const Icon(Icons.person_add_alt_1),
          ),
        ),
      ],
    );
  }
}