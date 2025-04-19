// // // lib/screens/admin/overview_screen.dart
// // import 'package:flutter/material.dart';
// // import '../../services/admin_service.dart';
// // import '../../models/overview_model.dart';
// // import '../../widgets/custom_card.dart';
// // import '../../config/app_colors.dart';
// // import '../../config/app_text_styles.dart';
// // import '../../widgets/loading_indicator.dart'; // Create this widget

// // class OverviewScreen extends StatefulWidget {
// // final Function(int index, [String? action]) onNavigateRequest;

// //   const OverviewScreen({Key? key, required this.onNavigateRequest}) : super(key: key);

// //   @override
// //   _OverviewScreenState createState() => _OverviewScreenState();
// // }

// // class _OverviewScreenState extends State<OverviewScreen> {
// //   late Future<OverviewData> _overviewData;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _refreshData();
// //   }

// //   void _refreshData() {
// //      setState(() {
// //        _overviewData = AdminService().getOverviewData();
// //      });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Scaffold and AppBar are now handled by AdminDashboard
// //     return RefreshIndicator( // Add pull-to-refresh
// //       onRefresh: () async => _refreshData(),
// //       color: AppColors.primary,
// //       child: FutureBuilder<OverviewData>(
// //         future: _overviewData,
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const LoadingIndicator(message: 'Loading Overview...');
// //           } else if (snapshot.hasError) {
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   const Icon(Icons.error_outline, color: AppColors.error, size: 50),
// //                   const SizedBox(height: 16),
// //                   Text('Error: ${snapshot.error}', style: AppTextStyles.bodyText1, textAlign: TextAlign.center,),
// //                   const SizedBox(height: 16),
// //                   ElevatedButton.icon(
// //                     icon: const Icon(Icons.refresh),
// //                     label: const Text('Retry'),
// //                     onPressed: _refreshData,
// //                   )
// //                 ],
// //               ),
// //             );
// //           } else if (!snapshot.hasData) {
// //             return Center(child: Text('No data available.', style: AppTextStyles.bodyText1));
// //           }

// //           final data = snapshot.data!;
// //           return ListView( // Use ListView for scrollability if content grows
// //             padding: const EdgeInsets.all(16.0),
// //             children: [
// //               // Use a Row for horizontal layout on larger screens if needed,
// //               // but GridView is often better for varying numbers of stats
// //                GridView.count(
// //                   crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive columns
// //                   crossAxisSpacing: 16,
// //                   mainAxisSpacing: 16,
// //                   shrinkWrap: true, // Important inside ListView
// //                   physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
// //                   children: [
// //                     _buildStatCard('Teachers', data.totalTeachers, Icons.person_outline, AppColors.primary),
// //                     _buildStatCard('Students', data.totalStudents, Icons.school_outlined, AppColors.accent),
// //                     _buildStatCard('Courses', data.totalCourses, Icons.book_outlined, AppColors.secondary),
// //                   ],
// //                ),
// //               const SizedBox(height: 24),
// //               Text('Quick Actions', style: AppTextStyles.headline3),
// //               const SizedBox(height: 12),
// //               CustomCard(
// //                 child: Column(
// //                    crossAxisAlignment: CrossAxisAlignment.start,
// //                    children: [
// //                      ListTile(

// //                               leading: const Icon(Icons.person_add_alt_1_outlined, color: AppColors.primary),
// //                               title: Text('Add New Teacher', style: AppTextStyles.bodyText1),
// //                               trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
// //                               onTap: () {
// //                                 // *** Call with index AND action ***
// //                                 widget.onNavigateRequest(1, 'add_teacher');
// //                               },
// //                               dense: true,
// //                             ),
// //                             const Divider(height: 1, indent: 16, endIndent: 16),
// //                             ListTile(
// //                               leading: const Icon(Icons.playlist_add_outlined, color: AppColors.primary),
// //                               title: Text('Add New Course', style: AppTextStyles.bodyText1),
// //                               trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
// //                               onTap: () {
// //                                 // *** Call with index AND action ***
// //                                 widget.onNavigateRequest(2, 'add_course');
// //                               },
// //                               dense: true,
// //                             ),
// //                           ]),
// //                     ),
// //               //          onTap: () {
// //               //            // Navigate or show dialog
// //               //            // Example: _showAddTeacherDialog(context); // Needs context if used here
// //               //          },
// //               //          dense: true,
// //               //        ),
// //               //        const Divider(),
// //               //        ListTile(
// //               //          leading: const Icon(Icons.playlist_add_outlined, color: AppColors.primary),
// //               //          title: Text('Add New Course', style: AppTextStyles.bodyText1),
// //               //          onTap: () {
// //               //            // Navigate or show dialog
// //               //            // Example: _showAddCourseDialog(context); // Needs context if used here
// //               //          },
// //               //          dense: true,
// //               //        ),
// //               //    ]),
// //               // ),

// //               const SizedBox(height: 24),
// //               Text('Recent Activity', style: AppTextStyles.headline3),
// //               const SizedBox(height: 12),
// //               CustomCard(
// //                 child: Center(
// //                   child: Text(
// //                     'Activity feed coming soon.', // Placeholder
// //                     style: AppTextStyles.bodyText2,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           );
// //         },
// //       ),
// //     );
// //   }

// //   Widget _buildStatCard(String title, int count, IconData icon, Color iconBgColor) {
// //     return CustomCard(
// //       padding: const EdgeInsets.all(16), // Consistent padding
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
// //         crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
// //         children: [
// //           CircleAvatar( // Use CircleAvatar for icon background
// //             radius: 25,
// //             backgroundColor: iconBgColor.withOpacity(0.15),
// //             child: Icon(icon, size: 28, color: iconBgColor),
// //           ),
// //           const SizedBox(height: 12),
// //           Text(
// //             count.toString(),
// //             style: AppTextStyles.headline2.copyWith(color: AppColors.textPrimary),
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //           const SizedBox(height: 4),
// //           Text(
// //             title,
// //             style: AppTextStyles.bodyText2,
// //             textAlign: TextAlign.center,
// //             overflow: TextOverflow.ellipsis,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // lib/screens/admin/overview_screen.dart
// import 'package:flutter/material.dart';
// import 'package:timeago/timeago.dart' as timeago; // Import timeago

// import '../../services/admin_service.dart';
// import '../../models/overview_model.dart';
// import '../../models/activity_log_model.dart'; // Import activity model
// import '../../widgets/custom_card.dart';
// import '../../config/app_colors.dart';
// import '../../config/app_text_styles.dart';
// import '../../widgets/loading_indicator.dart';
// import 'teacher_detail_screen.dart'; // For navigation
// import 'course_detail_screen.dart'; // For navigation
// import 'student_detail_screen.dart';

// class OverviewScreen extends StatefulWidget {
//   final Function(int index, [String? action]) onNavigateRequest;
//   const OverviewScreen({Key? key, required this.onNavigateRequest})
//     : super(key: key);
//   @override
//   _OverviewScreenState createState() => _OverviewScreenState();
// }

// class _OverviewScreenState extends State<OverviewScreen> {
//   late Future<OverviewData> _overviewDataFuture;
//   // Add state for activity log
//   late Future<List<ActivityLog>> _activityLogFuture;

//   @override
//   void initState() {
//     super.initState();
//     _refreshData(); // Initial load for both
//   }

//   // Modify refresh to load both
//   // void _refreshData() {
//   //   setState(() {
//   //     _overviewDataFuture = AdminService().getOverviewData();
//   //     _activityLogFuture = AdminService().getActivityLog(); // Fetch activity
//   //   });
//   // }
//   Future<void> _refreshData() async {
//     // Add Future<void> and async
//     // This setState call initiates the asynchronous operations
//     setState(() {
//       _overviewDataFuture = AdminService().getOverviewData();
//       _activityLogFuture = AdminService().getActivityLog();
//     });
//   }

//   // Helper to build activity list item
//   Widget _buildActivityTile(ActivityLog log) {
//     IconData icon = Icons.info_outline;
//     String title = 'Unknown Action';
//     String subtitle = '${log.actorUsername}';
//     VoidCallback? onTap;
//        void setNavigation(Widget screen) {
//       onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen))
//           .then((_) => _refreshData()); // Refresh data when returning
//     }


//     switch (log.actionType) {
//       case 'TEACHER_ADDED':
//         icon = Icons.person_add_alt_1_outlined;
//         title = 'Added Teacher: ${log.targetName ?? ""}';
//         if (log.targetId != null) {
//           onTap =
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => TeacherDetailScreen(teacherId: log.targetId!),
//                 ),
//               ).then((_) => _refreshData());
//         }
//         break;
//       case 'TEACHER_REMOVED':
//       case 'TEACHER_REMOVED_WITH_COURSES':
//       case 'TEACHER_REMOVED_KEEP_COURSES':
//         icon = Icons.person_remove_outlined;
//         title = 'Removed Teacher: ${log.targetName ?? ""}';
//         // No navigation target after deletion
//         break;
//       case 'COURSE_ADDED':
//         icon = Icons.playlist_add_outlined;
//         title = 'Added Course: ${log.targetName ?? ""}';
//         if (log.targetId != null) {
//           onTap =
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CourseDetailScreen(courseId: log.targetId!),
//                 ),
//               ).then((_) => _refreshData());
//         }
//         break;
//           case 'COURSE_REMOVED': // *** ADDED ***
//         icon = Icons.delete_sweep_outlined;
//         title = 'Removed Course: ${log.targetName ?? 'N/A'}';
//         // No navigation target
//         break;
//       case 'COURSE_APPROVED':
//         icon = Icons.check_circle_outline;
//         title = 'Approved Course: ${log.targetName ?? ""}';
//         subtitle += ' approved a course';
//         if (log.targetId != null) {
//           onTap =
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CourseDetailScreen(courseId: log.targetId!),
//                 ),
//               ).then((_) => _refreshData());
//         }
//         break;
//       case 'COURSE_REJECTED':
//         icon = Icons.cancel_outlined;
//         title = 'Rejected Course: ${log.targetName ?? ""}';
//         subtitle += ' rejected a course';
//         if (log.targetId != null) {
//           onTap =
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CourseDetailScreen(courseId: log.targetId!),
//                 ),
//               ).then((_) => _refreshData());
//         }
//         break;
//       case 'COURSE_UPDATED':
//         icon = Icons.edit_note_outlined;
//         title = 'Updated Course: ${log.targetName ?? ""}';
//         subtitle += ' updated a course';
//         if (log.targetId != null) {
//           onTap =
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CourseDetailScreen(courseId: log.targetId!),
//                 ),
//               ).then((_) => _refreshData());
//         }
//         break;
//       case 'COURSE_ASSIGNED_TEACHER':
//         icon = Icons.assignment_ind_outlined;
//         title = 'Assigned Course: ${log.targetName ?? ""}';
//         subtitle +=
//             ' assigned a course'; // Needs more detail from backend ideally
//         if (log.targetId != null) {
//           onTap =
//               () => Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => CourseDetailScreen(courseId: log.targetId!),
//                 ),
//               ).then((_) => _refreshData());
//         }
//         break;
//       // Add more cases as needed
//       // --- Student Actions ---
//       case 'STUDENT_ADDED': // *** ADDED ***
//         icon = Icons.person_add_outlined; // Different from teacher add
//         title = 'Added Student: ${log.targetName ?? 'N/A'}';
//          // Add grade info if backend includes it in details
//          // if (log.details?['grade'] != null) { title += ' (Grade ${log.details['grade']})';}
//         if (log.targetId != null) {
//            setNavigation(StudentDetailScreen(studentId: log.targetId!));
//         }
//         break;
//        case 'STUDENT_UPDATED': // *** ADDED ***
//         icon = Icons.manage_accounts_outlined;
//         title = 'Updated Student: ${log.targetName ?? 'N/A'}';
//         subtitle += ' updated profile';
//         if (log.targetId != null) {
//            setNavigation(StudentDetailScreen(studentId: log.targetId!));
//         }
//         break;
//        case 'STUDENT_REMOVED': // *** ADDED ***
//         icon = Icons.person_remove_alt_1_outlined;
//         title = 'Removed Student: ${log.targetName ?? 'N/A'}';
//         // No navigation target
//         break;

//       // --- Enrollment Actions ---
//       case 'STUDENT_ENROLLED': // *** ADDED ***
//          icon = Icons.assignment_turned_in_outlined;
//          // Backend log 'details' should ideally contain { courseName: '...', studentName: '...' }
//          title = 'Enrolled Student: ${log.targetName ?? 'N/A'}'; // Assumes targetName is student
//          subtitle += ' enrolled in a course'; // Refine with courseName if available
//          if (log.targetId != null) {
//              setNavigation(StudentDetailScreen(studentId: log.targetId!)); // Link to student
//          }
//          break;
//       case 'STUDENT_UNENROLLED': // *** ADDED ***
//          icon = Icons.assignment_return_outlined;
//          title = 'Unenrolled Student: ${log.targetName ?? 'N/A'}'; // Assumes targetName is student
//          subtitle += ' unenrolled from a course'; // Refine with courseName if available
//          if (log.targetId != null) {
//              setNavigation(StudentDetailScreen(studentId: log.targetId!)); // Link to student
//          }
//          break;

//       // --- Admin Actions ---
//       case 'ADMIN_SETTINGS_UPDATED': // *** ADDED ***
//           icon = Icons.admin_panel_settings_outlined;
//           title = 'Updated Admin Settings';
//           subtitle += ' updated settings'; // Target is usually the admin themselves
//           // Could link to settings page? widget.onNavigateRequest(5)? or null?
//           onTap = () => widget.onNavigateRequest(5); // Navigate to settings tab
//           break;
//       default:
//          icon = Icons.info_outline;
//         title = log.actionType.replaceAll('_', ' ').toLowerCase(); // Make it readable
//         title = title[0].toUpperCase() + title.substring(1); // Capitalize
//         subtitle += ' performed an action';
//     }

//         return ListTile(
//       leading: Icon(
//         icon, color: AppColors.secondary.withOpacity(0.8)),
//       title: Text(title, style: AppTextStyles.bodyText1.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
//       subtitle: Text(subtitle, style: AppTextStyles.caption),
//       trailing: Text(timeago.format(log.createdAt, locale: 'en_short'), style: AppTextStyles.caption), // Use short locale
//       dense: true,
//       onTap: onTap,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//       timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
//     return RefreshIndicator(
//       onRefresh: _refreshData, // Refreshes both futures
//       color: AppColors.primary,
//       child: ListView(
//         // Use a single ListView for the whole screen
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           // --- Overview Stats ---
//           FutureBuilder<OverviewData>(
//             future: _overviewDataFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 // Show placeholder or smaller loader for this part
//                 return const SizedBox(
//                   height: 120,
//                   child: Center(child: LoadingIndicator()),
//                 );
//               } else if (snapshot.hasError) {
//                 return CustomCard(
//                   child: Text(
//                     'Could not load stats: ${snapshot.error}',
//                     style: const TextStyle(color: AppColors.error),
//                   ),
//                 );
//               } else if (!snapshot.hasData) {
//                 return const CustomCard(child: Text('No overview data.'));
//               }
//               final data = snapshot.data!;
//               return GridView.count(
//                 crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 children: [
//                   /* ... _buildStatCard calls ... */
//                   _buildStatCard(
//                     'Teachers',
//                     data.totalTeachers,
//                     Icons.person_outline,
//                     AppColors.primary,
//                   ),
//                   _buildStatCard(
//                     'Students',
//                     data.totalStudents,
//                     Icons.school_outlined,
//                     AppColors.accent,
//                   ),
//                   _buildStatCard(
//                     'Courses',
//                     data.totalCourses,
//                     Icons.book_outlined,
//                     AppColors.secondary,
//                   ),
//                 ],
//               );
//             },
//           ),
//           const SizedBox(height: 24),

//           // --- Quick Actions ---
//           Text('Quick Actions', style: AppTextStyles.headline3),
//           const SizedBox(height: 12),
//           CustomCard(
//             child: Column(
//               children: [
//                 /* ... ListTiles for Add Teacher/Course ... */
//                 ListTile(
//                   leading: const Icon(
//                     Icons.person_add_alt_1_outlined,
//                     color: AppColors.primary,
//                   ),
//                   title: Text(
//                     'Add New Teacher',
//                     style: AppTextStyles.bodyText1,
//                   ),
//                   trailing: const Icon(
//                     Icons.chevron_right,
//                     color: AppColors.textSecondary,
//                   ),
//                   onTap: () => widget.onNavigateRequest(1, 'add_teacher'),
//                   dense: true,
//                 ),
//                 const Divider(height: 1, indent: 16, endIndent: 16),
//                  // *** ADD STUDENT TILE ***
//                   ListTile(
//                     leading: const Icon(Icons.person_add_outlined, color: AppColors.primary), // Different icon
//                     title: Text('Add New Student', style: AppTextStyles.bodyText1),
//                     trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
//                     onTap: () => widget.onNavigateRequest(2, 'add_student'), // Index 2 for StudentsScreen
//                     dense: true,
//                   ),
//                   const Divider(height: 1, indent: 16, endIndent: 16),
//                   // *** END ADD STUDENT TILE ***
//                 ListTile(
//                   leading: const Icon(
//                     Icons.playlist_add_outlined,
//                     color: AppColors.primary,
//                   ),
//                   title: Text('Add New Course', style: AppTextStyles.bodyText1),
//                   trailing: const Icon(
//                     Icons.chevron_right,
//                     color: AppColors.textSecondary,
//                   ),
//                   onTap: () => widget.onNavigateRequest(3, 'add_course'),
//                   dense: true,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 24),

//           // --- Recent Activity Section ---
//           Text('Recent Activity', style: AppTextStyles.headline3),
//           const SizedBox(height: 12),
//           CustomCard(
//             padding:
//                 EdgeInsets.zero, // Remove card padding, use ListTile padding
//             child: FutureBuilder<List<ActivityLog>>(
//               future: _activityLogFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const SizedBox(
//                     height: 150,
//                     child: Center(child: LoadingIndicator()),
//                   ); // Placeholder size
//                 } else if (snapshot.hasError) {
//                   return Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text(
//                       'Could not load activity: ${snapshot.error}',
//                       style: const TextStyle(color: AppColors.error),
//                     ),
//                   );
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Center(child: Text('No recent activity found.')),
//                   );
//                 }

//                 final logs = snapshot.data!;
//                 // Use ListView.builder if list can be long, otherwise Column is fine for ~10 items
//                 return ListView.separated(
//                   shrinkWrap: true, // Important inside the outer ListView
//                   physics:
//                       const NeverScrollableScrollPhysics(), // Disable its scrolling
//                   itemCount: logs.length,
//                   itemBuilder:
//                       (context, index) => _buildActivityTile(logs[index]),
//                   separatorBuilder:
//                       (context, index) => const Divider(
//                         height: 1,
//                         indent: 16,
//                         endIndent: 16,
//                       ), // Separators
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(
//     String title,
//     int count,
//     IconData icon,
//     Color iconBgColor,
//   ) {
//     /* ... Same implementation ... */
    
//     return CustomCard(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 25,
//             backgroundColor: iconBgColor.withOpacity(0.15),
//             child: Icon(icon, size: 28, color: iconBgColor),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             count.toString(),
//             style: AppTextStyles.headline2.copyWith(
//               color: AppColors.textPrimary,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: AppTextStyles.bodyText2,
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
    
//   }
// }
// // lib/screens/admin/overview_screen.dart
// import 'package:flutter/material.dart';
// import '../../services/admin_service.dart';
// import '../../models/overview_model.dart';
// import '../../widgets/custom_card.dart';
// import '../../config/app_colors.dart';
// import '../../config/app_text_styles.dart';
// import '../../widgets/loading_indicator.dart'; // Create this widget

// class OverviewScreen extends StatefulWidget {
// final Function(int index, [String? action]) onNavigateRequest;

//   const OverviewScreen({Key? key, required this.onNavigateRequest}) : super(key: key);

//   @override
//   _OverviewScreenState createState() => _OverviewScreenState();
// }

// class _OverviewScreenState extends State<OverviewScreen> {
//   late Future<OverviewData> _overviewData;

//   @override
//   void initState() {
//     super.initState();
//     _refreshData();
//   }

//   void _refreshData() {
//      setState(() {
//        _overviewData = AdminService().getOverviewData();
//      });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Scaffold and AppBar are now handled by AdminDashboard
//     return RefreshIndicator( // Add pull-to-refresh
//       onRefresh: () async => _refreshData(),
//       color: AppColors.primary,
//       child: FutureBuilder<OverviewData>(
//         future: _overviewData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const LoadingIndicator(message: 'Loading Overview...');
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, color: AppColors.error, size: 50),
//                   const SizedBox(height: 16),
//                   Text('Error: ${snapshot.error}', style: AppTextStyles.bodyText1, textAlign: TextAlign.center,),
//                   const SizedBox(height: 16),
//                   ElevatedButton.icon(
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retry'),
//                     onPressed: _refreshData,
//                   )
//                 ],
//               ),
//             );
//           } else if (!snapshot.hasData) {
//             return Center(child: Text('No data available.', style: AppTextStyles.bodyText1));
//           }

//           final data = snapshot.data!;
//           return ListView( // Use ListView for scrollability if content grows
//             padding: const EdgeInsets.all(16.0),
//             children: [
//               // Use a Row for horizontal layout on larger screens if needed,
//               // but GridView is often better for varying numbers of stats
//                GridView.count(
//                   crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2, // Responsive columns
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   shrinkWrap: true, // Important inside ListView
//                   physics: const NeverScrollableScrollPhysics(), // Disable grid scrolling
//                   children: [
//                     _buildStatCard('Teachers', data.totalTeachers, Icons.person_outline, AppColors.primary),
//                     _buildStatCard('Students', data.totalStudents, Icons.school_outlined, AppColors.accent),
//                     _buildStatCard('Courses', data.totalCourses, Icons.book_outlined, AppColors.secondary),
//                   ],
//                ),
//               const SizedBox(height: 24),
//               Text('Quick Actions', style: AppTextStyles.headline3),
//               const SizedBox(height: 12),
//               CustomCard(
//                 child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      ListTile(

//                               leading: const Icon(Icons.person_add_alt_1_outlined, color: AppColors.primary),
//                               title: Text('Add New Teacher', style: AppTextStyles.bodyText1),
//                               trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
//                               onTap: () {
//                                 // *** Call with index AND action ***
//                                 widget.onNavigateRequest(1, 'add_teacher');
//                               },
//                               dense: true,
//                             ),
//                             const Divider(height: 1, indent: 16, endIndent: 16),
//                             ListTile(
//                               leading: const Icon(Icons.playlist_add_outlined, color: AppColors.primary),
//                               title: Text('Add New Course', style: AppTextStyles.bodyText1),
//                               trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
//                               onTap: () {
//                                 // *** Call with index AND action ***
//                                 widget.onNavigateRequest(2, 'add_course');
//                               },
//                               dense: true,
//                             ),
//                           ]),
//                     ),
//               //          onTap: () {
//               //            // Navigate or show dialog
//               //            // Example: _showAddTeacherDialog(context); // Needs context if used here
//               //          },
//               //          dense: true,
//               //        ),
//               //        const Divider(),
//               //        ListTile(
//               //          leading: const Icon(Icons.playlist_add_outlined, color: AppColors.primary),
//               //          title: Text('Add New Course', style: AppTextStyles.bodyText1),
//               //          onTap: () {
//               //            // Navigate or show dialog
//               //            // Example: _showAddCourseDialog(context); // Needs context if used here
//               //          },
//               //          dense: true,
//               //        ),
//               //    ]),
//               // ),

//               const SizedBox(height: 24),
//               Text('Recent Activity', style: AppTextStyles.headline3),
//               const SizedBox(height: 12),
//               CustomCard(
//                 child: Center(
//                   child: Text(
//                     'Activity feed coming soon.', // Placeholder
//                     style: AppTextStyles.bodyText2,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildStatCard(String title, int count, IconData icon, Color iconBgColor) {
//     return CustomCard(
//       padding: const EdgeInsets.all(16), // Consistent padding
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
//         crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
//         children: [
//           CircleAvatar( // Use CircleAvatar for icon background
//             radius: 25,
//             backgroundColor: iconBgColor.withOpacity(0.15),
//             child: Icon(icon, size: 28, color: iconBgColor),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             count.toString(),
//             style: AppTextStyles.headline2.copyWith(color: AppColors.textPrimary),
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: AppTextStyles.bodyText2,
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ],
//       ),
//     );
//   }
// }

// lib/screens/admin/overview_screen.dart
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago; // Import timeago

import '../../services/admin_service.dart';
import '../../models/overview_model.dart';
import '../../models/activity_log_model.dart'; // Import activity model
import '../../widgets/custom_card.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/loading_indicator.dart';
import 'teacher_detail_screen.dart'; // For navigation
import 'course_detail_screen.dart'; // For navigation
import 'student_detail_screen.dart';

class OverviewScreen extends StatefulWidget {
  final Function(int index, [String? action]) onNavigateRequest;
  const OverviewScreen({Key? key, required this.onNavigateRequest})
    : super(key: key);
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  late Future<OverviewData> _overviewDataFuture;
  // Add state for activity log
  late Future<List<ActivityLog>> _activityLogFuture;

  @override
  void initState() {
    super.initState();
    _refreshData(); // Initial load for both
  }

  // Modify refresh to load both

  Future<void> _refreshData() async {
    // Add Future<void> and async
    // This setState call initiates the asynchronous operations
    setState(() {
      _overviewDataFuture = AdminService().getOverviewData();
      _activityLogFuture = AdminService().getActivityLog();
    });
  }

  // Helper to build activity list item
  Widget _buildActivityTile(ActivityLog log) {
    IconData icon = Icons.info_outline;
    String title = 'Unknown Action';
    String subtitle = '${log.actorUsername}';
    VoidCallback? onTap;

       void setNavigation(Widget screen) {
      onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen))
          .then((_) => _refreshData()); // Refresh data when returning
    }


    switch (log.actionType) {
      case 'TEACHER_ADDED':
        icon = Icons.person_add_alt_1_outlined;
        title = 'Added Teacher: ${log.targetName ?? ""}';
        if (log.targetId != null) {
          onTap =
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TeacherDetailScreen(teacherId: log.targetId!),
                ),
              ).then((_) => _refreshData());
        }
        break;
      case 'TEACHER_REMOVED':
      case 'TEACHER_REMOVED_WITH_COURSES':
      case 'TEACHER_REMOVED_KEEP_COURSES':
        icon = Icons.person_remove_outlined;
        title = 'Removed Teacher: ${log.targetName ?? ""}';
        // No navigation target after deletion
        break;
      case 'COURSE_ADDED':
        icon = Icons.playlist_add_outlined;
        title = 'Added Course: ${log.targetName ?? ""}';
        if (log.targetId != null) {
          onTap =
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(courseId: log.targetId!),
                ),
              ).then((_) => _refreshData());
        }
        break;
          case 'COURSE_REMOVED': // *** ADDED ***
        icon = Icons.delete_sweep_outlined;
        title = 'Removed Course: ${log.targetName ?? 'N/A'}';
        // No navigation target
        break;
      case 'COURSE_APPROVED':
        icon = Icons.check_circle_outline;
        title = 'Approved Course: ${log.targetName ?? ""}';
        subtitle += ' approved a course';
        if (log.targetId != null) {
          onTap =
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(courseId: log.targetId!),
                ),
              ).then((_) => _refreshData());
        }
        break;
      case 'COURSE_REJECTED':
        icon = Icons.cancel_outlined;
        title = 'Rejected Course: ${log.targetName ?? ""}';
        subtitle += ' rejected a course';
        if (log.targetId != null) {
          onTap =
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(courseId: log.targetId!),
                ),
              ).then((_) => _refreshData());
        }
        break;
      case 'COURSE_UPDATED':
        icon = Icons.edit_note_outlined;
        title = 'Updated Course: ${log.targetName ?? ""}';
        subtitle += ' updated a course';
        if (log.targetId != null) {
          onTap =
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(courseId: log.targetId!),
                ),
              ).then((_) => _refreshData());
        }
        break;
      case 'COURSE_ASSIGNED_TEACHER':
        icon = Icons.assignment_ind_outlined;
        title = 'Assigned Course: ${log.targetName ?? ""}';
        subtitle +=
            ' assigned a course'; // Needs more detail from backend ideally
        if (log.targetId != null) {
          onTap =
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(courseId: log.targetId!),
                ),
              ).then((_) => _refreshData());
        }
        break;
      // Add more cases as needed
      // --- Student Actions ---
      case 'STUDENT_ADDED': // *** ADDED ***
        icon = Icons.person_add_outlined; // Different from teacher add
        title = 'Added Student: ${log.targetName ?? 'N/A'}';
         // Add grade info if backend includes it in details
         // if (log.details?['grade'] != null) { title += ' (Grade ${log.details['grade']})';}
        if (log.targetId != null) {
           setNavigation(StudentDetailScreen(studentId: log.targetId!));
        }
        break;
       case 'STUDENT_UPDATED': // *** ADDED ***
        icon = Icons.manage_accounts_outlined;
        title = 'Updated Student: ${log.targetName ?? 'N/A'}';
        subtitle += ' updated profile';
        if (log.targetId != null) {
           setNavigation(StudentDetailScreen(studentId: log.targetId!));
        }
        break;
       case 'STUDENT_REMOVED': // *** ADDED ***
        icon = Icons.person_remove_alt_1_outlined;
        title = 'Removed Student: ${log.targetName ?? 'N/A'}';
        // No navigation target
        break;

      // --- Enrollment Actions ---
      case 'STUDENT_ENROLLED': // *** ADDED ***
         icon = Icons.assignment_turned_in_outlined;
         // Backend log 'details' should ideally contain { courseName: '...', studentName: '...' }
         title = 'Enrolled Student: ${log.targetName ?? 'N/A'}'; // Assumes targetName is student
         subtitle += ' enrolled in a course'; // Refine with courseName if available
         if (log.targetId != null) {
             setNavigation(StudentDetailScreen(studentId: log.targetId!)); // Link to student
         }
         break;
      case 'STUDENT_UNENROLLED': // *** ADDED ***
         icon = Icons.assignment_return_outlined;
         title = 'Unenrolled Student: ${log.targetName ?? 'N/A'}'; // Assumes targetName is student
         subtitle += ' unenrolled from a course'; // Refine with courseName if available
         if (log.targetId != null) {
             setNavigation(StudentDetailScreen(studentId: log.targetId!)); // Link to student
         }
         break;

      // --- Admin Actions ---
      case 'ADMIN_SETTINGS_UPDATED': // *** ADDED ***
          icon = Icons.admin_panel_settings_outlined;
          title = 'Updated Admin Settings';
          subtitle += ' updated settings'; // Target is usually the admin themselves
          // Could link to settings page? widget.onNavigateRequest(5)? or null?
          onTap = () => widget.onNavigateRequest(5); // Navigate to settings tab
          break;
      default:
         icon = Icons.info_outline;
        title = log.actionType.replaceAll('_', ' ').toLowerCase(); // Make it readable
        title = title[0].toUpperCase() + title.substring(1); // Capitalize
        subtitle += ' performed an action';
    }

        return ListTile(
      leading: Icon(
        icon, color: AppColors.secondary.withOpacity(0.8)),
      title: Text(title, style: AppTextStyles.bodyText1.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle, style: AppTextStyles.caption),
      trailing: Text(timeago.format(log.createdAt, locale: 'en_short'), style: AppTextStyles.caption), // Use short locale
      dense: true,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
      timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
      final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine columns based on width
    final crossAxisCount = screenWidth < 600 ? 2 : (screenWidth < 900 ? 3 : 4);
     double cardAspectRatio = crossAxisCount == 2 ? 1.1 : (crossAxisCount == 3 ? 1.3 : 1.5);
    return RefreshIndicator(
      onRefresh: _refreshData, // Refreshes both futures
      color: AppColors.primary,
      child: ListView(
        // Use a single ListView for the whole screen
        padding: const EdgeInsets.all(16.0),
        children: [
          // --- Overview Stats ---
          FutureBuilder<OverviewData>(
            future: _overviewDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show placeholder or smaller loader for this part
                return const SizedBox(
                  height: 120,
                  child: Center(child: LoadingIndicator()),
                );
              } else if (snapshot.hasError) {
                return CustomCard(
                  child: Text(
                    'Could not load stats: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.error),
                  ),
                );
              } else if (!snapshot.hasData) {
                return const CustomCard(child: Text('No overview data.'));
              }
              final data = snapshot.data!;
              return GridView.count(
                      // *** Use calculated crossAxisCount ***
                 crossAxisCount: crossAxisCount,
                 crossAxisSpacing: 16,
                 mainAxisSpacing: 16,
                 shrinkWrap: true, 
                 physics: const NeverScrollableScrollPhysics(),
                 childAspectRatio: cardAspectRatio, // Adjust aspect ratio
                children: [
                  /* ... _buildStatCard calls ... */
                  _buildStatCard(
                    'Teachers',
                    data.totalTeachers,
                    Icons.person_outline,
                    AppColors.primary,
                  ),
                  _buildStatCard(
                    'Students',
                    data.totalStudents,
                    Icons.school_outlined,
                    AppColors.accent,
                  ),
                  _buildStatCard(
                    'Courses',
                    data.totalCourses,
                    Icons.book_outlined,
                    AppColors.secondary,
                  ),
                   _buildStatCard(
                      'Enrollments', // <-- New Title
                      data.totalEnrollments, // <-- Use new data field
                      Icons.assignment_turned_in_outlined, // <-- Appropriate Icon
                      AppColors.accent, // <-- Choose a suitable color
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // --- Quick Actions ---
          Text('Quick Actions', style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              children: [
                /* ... ListTiles for Add Teacher/Course ... */
                ListTile(
                  leading: const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text(
                    'Add New Teacher',
                    style: AppTextStyles.bodyText1,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () => widget.onNavigateRequest(1, 'add_teacher'),
                  dense: true,
                ),
                const Divider(height: 1, indent: 16, endIndent: 16),
                 // *** ADD STUDENT TILE ***
                  ListTile(
                    leading: const Icon(Icons.person_add_outlined, color: AppColors.primary), // Different icon
                    title: Text('Add New Student', style: AppTextStyles.bodyText1),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () => widget.onNavigateRequest(2, 'add_student'), // Index 2 for StudentsScreen
                    dense: true,
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  // *** END ADD STUDENT TILE ***
                ListTile(
                  leading: const Icon(
                    Icons.playlist_add_outlined,
                    color: AppColors.primary,
                  ),
                  title: Text('Add New Course', style: AppTextStyles.bodyText1),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () => widget.onNavigateRequest(3, 'add_course'),
                  dense: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- Recent Activity Section ---
          Text('Recent Activity', style: AppTextStyles.headline3),
          const SizedBox(height: 12),
          CustomCard(
            padding:
                EdgeInsets.zero, // Remove card padding, use ListTile padding
            child: FutureBuilder<List<ActivityLog>>(
              future: _activityLogFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: LoadingIndicator()),
                  ); // Placeholder size
                } else if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Could not load activity: ${snapshot.error}',
                      style: const TextStyle(color: AppColors.error),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: Text('No recent activity found.')),
                  );
                }

                final logs = snapshot.data!;
                // Use ListView.builder if list can be long, otherwise Column is fine for ~10 items
                return ListView.separated(
                  shrinkWrap: true, // Important inside the outer ListView
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable its scrolling
                  itemCount: logs.length,
                  itemBuilder:
                      (context, index) => _buildActivityTile(logs[index]),
                  separatorBuilder:
                      (context, index) => const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ), // Separators
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    int count,
    IconData icon,
    Color iconBgColor,
  ) {
   
    
    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
             backgroundColor: iconBgColor.withAlpha((255*0.15).round()),
            child: Icon(icon, size: 24, color: iconBgColor),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.textPrimary,
              fontSize: 22
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            title,
           style: AppTextStyles.bodyText2.copyWith(fontSize: 13),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
    
  }
}
