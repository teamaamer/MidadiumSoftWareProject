// // lib/screens/admin/courses_screen.dart
import 'package:flutter/material.dart';
import '../../services/admin_service.dart';
import '../../models/course_model.dart';
import '../../models/user_model.dart'; // To fetch teachers for the dropdown
import '../../widgets/custom_card.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/filter_chip.dart';
import '../../widgets/loading_indicator.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import 'course_detail_screen.dart';
import 'teachers_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({Key? key}) : super(key: key);

  @override
  CoursesScreenState createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  late Future<List<Course>> _coursesFuture;
  late Future<List<User>> _teachersFuture; // For dropdown
  List<User> _fetchedTeachers = []; // Store fetched teachers
  List<Course> _allCourses = [];
  List<Course> _filteredCourses = [];
  String? _statusFilter;
  String? _subjectFilter; // Add subject filter state
  final TextEditingController _searchController = TextEditingController();

  // Define available subjects (replace with dynamic loading if needed)
  final List<String> _subjects = ['Mathematics', 'Science', 'History', 'English', 'Art', 'Physics', 'Chemistry'];
  final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12']; // Example Grades

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterCourses);
  }

   @override
  void dispose() {
    _searchController.removeListener(_filterCourses);
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _loadData() async {
    setState(() {
      // Fetch both courses and teachers concurrently
      _coursesFuture = AdminService().getAllCourses(status: _statusFilter, subject: _subjectFilter);
      _teachersFuture = AdminService().getAllTeachers(); // Needed for Add Course Dialog
    });
    try {
       final results = await Future.wait([_coursesFuture, _teachersFuture]);
       _allCourses = results[0] as List<Course>;
       _fetchedTeachers = results[1] as List<User>; // Store teachers
       _filterCourses();
    } catch (e) {
       print("Error loading courses: $e");
        if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Failed to load courses: $e'), backgroundColor: AppColors.error),
         );
       }
    }
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCourses = _allCourses.where((course) {
        final statusMatch = _statusFilter == null || course.status == _statusFilter;
        final subjectMatch = _subjectFilter == null || course.subject.toLowerCase() == _subjectFilter!.toLowerCase();
        final searchMatch = course.name.toLowerCase().contains(query) ||
                            course.teacherName.toLowerCase().contains(query) ||
                            course.subject.toLowerCase().contains(query) ||
                            course.grade.toLowerCase().contains(query);
        return statusMatch && subjectMatch && searchMatch;
      }).toList();
    });
  }

  void _setFilter(String filterType, String? value) {
     setState(() {
       if (filterType == 'status') {
         _statusFilter = _statusFilter == value ? null : value;
       } else if (filterType == 'subject') {
         _subjectFilter = _subjectFilter == value ? null : value;
       }
       // Refetch courses from backend with new filters
       _coursesFuture = AdminService().getAllCourses(status: _statusFilter, subject: _subjectFilter);
       _coursesFuture.then((courses) {
          _allCourses = courses;
          _filterCourses(); // Apply search query locally
       }).catchError((e){
            print("Error applying filters: $e");
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to apply filters: $e'), backgroundColor: AppColors.error),
              );
            }
       });
     });
  }


  void _showAddCourseDialog(List<User> teachers) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final subjectController = TextEditingController();
    final gradeController = TextEditingController();
    final syllabusController = TextEditingController(); // Add controller
    final resourcesController = TextEditingController(); // Add controller
    String? selectedTeacherId;
    String? selectedSubject;
    String? selectedGrade;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Course'),
          content: StatefulBuilder( // Use StatefulBuilder for dropdowns
            builder: (BuildContext context, StateSetter setStateDialog) {
             return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Course Name', prefixIcon: Icon(Icons.label_outline)),
                        validator: (v) => v!.isEmpty ? 'Name required' : null,
                      ),
                      const SizedBox(height: 16),
                       DropdownButtonFormField<String>(
                         value: selectedTeacherId,
                         decoration: const InputDecoration(labelText: 'Assign Teacher', prefixIcon: Icon(Icons.person_outline)),
                         items: teachers.map((User teacher) {
                           return DropdownMenuItem<String>(
                             value: teacher.id,
                             child: Text(teacher.username),
                           );
                         }).toList(),
                         onChanged: (String? newValue) {
                            setStateDialog(() { selectedTeacherId = newValue; });
                         },
                         validator: (v) => v == null ? 'Teacher required' : null,
                       ),
                      const SizedBox(height: 16),
                      // Dropdown for Subject
                       DropdownButtonFormField<String>(
                         value: selectedSubject,
                         decoration: const InputDecoration(labelText: 'Subject', prefixIcon: Icon(Icons.subject_outlined)),
                         items: _subjects.map((String subject) {
                           return DropdownMenuItem<String>(
                             value: subject,
                             child: Text(subject),
                           );
                         }).toList(),
                         onChanged: (String? newValue) {
                            setStateDialog(() { selectedSubject = newValue; });
                         },
                         validator: (v) => v == null ? 'Subject required' : null,
                       ),
                       const SizedBox(height: 16),
                       // Dropdown for Grade
                        DropdownButtonFormField<String>(
                         value: selectedGrade,
                         decoration: const InputDecoration(labelText: 'Grade', prefixIcon: Icon(Icons.grade_outlined)),
                         items: _grades.map((String grade) {
                           return DropdownMenuItem<String>(
                             value: grade,
                             child: Text(grade),
                           );
                         }).toList(),
                         onChanged: (String? newValue) {
                            setStateDialog(() { selectedGrade = newValue; });
                         },
                         validator: (v) => v == null ? 'Grade required' : null,
                       ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.description_outlined)),
                        maxLines: 3,
                        validator: (v) => v!.isEmpty ? 'Description required' : null,
                      ),
                       const SizedBox(height: 16),
                       TextFormField( // Syllabus Field
                         controller: syllabusController,
                         decoration: const InputDecoration(labelText: 'Syllabus (Optional)', prefixIcon: Icon(Icons.list_alt_outlined)),
                         maxLines: 3,
                       ),
                        const SizedBox(height: 16),
                       TextFormField( // Resources Field
                         controller: resourcesController,
                         decoration: const InputDecoration(labelText: 'Resources (Optional Links/Text)', prefixIcon: Icon(Icons.link_outlined)),
                         maxLines: 3,
                       ),
                    ],
                  ),
                ),
             );
            }
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            CustomButton(
              text: 'Add Course',
              icon: Icons.add,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    await AdminService().addCourse({
                      "name": nameController.text,
                      "description": descriptionController.text,
                      "subject": selectedSubject!,
                      "grade": selectedGrade!,
                      "teacher": selectedTeacherId!,
                      "syllabus": syllabusController.text, // Send syllabus
                      "resources": resourcesController.text, // Send resources
                    });
                    Navigator.pop(context);
                    _loadData(); // Refresh list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Course added successfully'), backgroundColor: AppColors.success),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.error),
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
   void showAddCourseDialogFromDashboard() {
    if (mounted) {
      // Use the already fetched teachers list
      if (_fetchedTeachers.isNotEmpty) {
         _showAddCourseDialog(_fetchedTeachers);
      } else {
          // If teachers haven't loaded yet for some reason, show message or try loading again
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Teacher data not ready. Please wait and try again.'), backgroundColor: AppColors.error),
         );
          // Optionally trigger _loadData again, but be careful of infinite loops
          // _loadData();
      }
    } else {
       print("Warning: Tried to show Add Course dialog when widget was not mounted.");
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved': return AppColors.approved;
      case 'rejected': return AppColors.error;
      case 'pending': return AppColors.pending;
      default: return AppColors.textSecondary;
    }
  }

   IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'approved': return Icons.check_circle_outline;
      case 'rejected': return Icons.cancel_outlined;
      case 'pending': return Icons.hourglass_empty_outlined;
      default: return Icons.help_outline;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
         Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, teacher, subject...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
              ),
            ),
          ),
        // Filter Chips Row
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), 
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
               spacing: 8.0, // Horizontal space between chips
              runSpacing: 8.0, // Vertical space if chips wrap
              children: [
                 // Status Filters
                 CustomFilterChip(
                   label: 'All Status',
                   isSelected: _statusFilter == null,
                   onSelected: () => _setFilter('status', null),
                 ),
                 //const SizedBox(width: 8),
                 CustomFilterChip(
                   label: 'Pending',
                   icon: Icons.hourglass_empty_outlined,
                   isSelected: _statusFilter == 'pending',
                   onSelected: () => _setFilter('status','pending'),
                 ),
                 const SizedBox(width: 8),
                 CustomFilterChip(
                   label: 'Approved',
                    icon: Icons.check_circle_outline,
                   isSelected: _statusFilter == 'approved',
                   onSelected: () => _setFilter('status','approved'),
                 ),
                 const SizedBox(width: 8),
                 CustomFilterChip(
                   label: 'Rejected',
                    icon: Icons.cancel_outlined,
                   isSelected: _statusFilter == 'rejected',
                   onSelected: () => _setFilter('status','rejected'),
                 ),
                 // Optional: Subject Filter Dropdown or Chips
                 // Example using a dropdown button (can be complex here)
                 // Or add more chips for common subjects
                 // const VerticalDivider(width: 24, indent: 8, endIndent: 8),
                 // CustomFilterChip(
                 //   label: 'All Subjects',
                 //   isSelected: _subjectFilter == null,
                 //   onSelected: () => _setFilter('subject', null),
                 // ),
                 // ... chips for subjects ...
              ],
            ),
          ),
        ),
        // Course List
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: AppColors.primary,
            child: FutureBuilder<List<Course>>(
              future: _coursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting && _allCourses.isEmpty) {
                  return const LoadingIndicator(message: 'Loading courses...');
                } else if (snapshot.hasError && _allCourses.isEmpty) {
                  return Center(child: Text('Error: ${snapshot.error}', style: AppTextStyles.bodyText1));
                 } else if (_allCourses.isEmpty) {
                     return Center(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           const Icon(Icons.school_outlined, size: 60, color: AppColors.textSecondary),
                           const SizedBox(height: 16),
                           Text('No courses found.', style: AppTextStyles.subtitle1),
                           const SizedBox(height: 8),
                           FutureBuilder<List<User>>( // Check if teachers exist before showing add button hint
                             future: _teachersFuture,
                             builder: (context, teacherSnapshot) {
                               if (teacherSnapshot.hasData && teacherSnapshot.data!.isNotEmpty) {
                                 return Text('Add a new course using the + button below.', style: AppTextStyles.bodyText2, textAlign: TextAlign.center);
                               }
                               return Text('Add teachers first before creating courses.', style: AppTextStyles.bodyText2, textAlign: TextAlign.center);
                             }
                           ),
                         ],
                       ),
                     );
                  } else if (_filteredCourses.isEmpty && (_searchController.text.isNotEmpty || _statusFilter != null || _subjectFilter != null)) {
                    return Center(child: Text('No courses match your filters.', style: AppTextStyles.bodyText1));
                  }

                return ListView.separated(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 90.0), // Padding for FAB
                  itemCount: _filteredCourses.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final course = _filteredCourses[index];
                    return CustomCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetailScreen(courseId: course.id),
                          ),
                        ).then((_) => _loadData()); // Refresh on return
                      },
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Expanded(child: Text(course.name, style: AppTextStyles.subtitle1, overflow: TextOverflow.ellipsis)),
                               Container(
                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                 decoration: BoxDecoration(
                                   color: _getStatusColor(course.status).withOpacity(0.15),
                                   borderRadius: BorderRadius.circular(12)
                                 ),
                                 child: Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Icon(_getStatusIcon(course.status), size: 14, color: _getStatusColor(course.status)),
                                     const SizedBox(width: 4),
                                     Text(
                                       course.status[0].toUpperCase() + course.status.substring(1), // Capitalize
                                       style: AppTextStyles.caption.copyWith(color: _getStatusColor(course.status), fontWeight: FontWeight.w600),
                                     ),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                          const SizedBox(height: 8),
                           Text('Teacher: ${course.teacherName}', style: AppTextStyles.bodyText2),
                           Text('Subject: ${course.subject} | Grade: ${course.grade}', style: AppTextStyles.bodyText2),
                           // Optional: Add quick action buttons directly on the card if needed
                           // SizedBox(height: 8),
                           // Row(children: [ ... actions ... ])
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        // Add Course FAB
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: FutureBuilder<List<User>>( // Only show FAB if teachers exist
             future: _teachersFuture,
             builder: (context, teacherSnapshot) {
               if (teacherSnapshot.hasData && teacherSnapshot.data!.isNotEmpty) {
                 return FloatingActionButton(
                    heroTag: 'fab_courses',
                   onPressed: () => _showAddCourseDialog(teacherSnapshot.data!),
                   backgroundColor: AppColors.accent,
                   foregroundColor: AppColors.secondary,
                   tooltip: 'Add Course',
                   child: const Icon(Icons.add),
                 );
               }
               return const SizedBox.shrink(); // Hide FAB if no teachers
             }
           ),
         ),
      ],
    );
  }
}