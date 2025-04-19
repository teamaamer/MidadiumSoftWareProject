
// lib/screens/admin/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http; // Import http package
import 'dart:convert';                  // Import convert for jsonEncode\
import 'package:flutter/foundation.dart'; // Import kIsWeb for base URL
import '../../config/app_text_styles.dart';
import 'overview_screen.dart';
import 'teachers_screen.dart';
import 'courses_screen.dart';
import 'students_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../config/app_colors.dart'; // Import colors

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
final GlobalKey<TeachersScreenState> _teachersScreenKey = GlobalKey<TeachersScreenState>();
  final GlobalKey<CoursesScreenState> _coursesScreenKey = GlobalKey<CoursesScreenState>();
   final GlobalKey<StudentsScreenState> _studentsScreenKey = GlobalKey<StudentsScreenState>(); // <-- Add Student Key
final _storage = const FlutterSecureStorage();

late final List<Widget> _screens;

  // Optional: Titles for each screen
  final List<String> _titles = [
    'Admin Overview',
    'Manage Teachers',
    'Manage Students',
    'Manage Courses',
    'Platform Reports',
    'Admin Settings'
  ];
 // final int _settingsIndex = 5;
   static const double webBreakpoint = 720.0;
   static const double fixedRailWidth = 250.0;
/////////////////////
 @override
  void initState() {
    super.initState();
    // Initialize _screens here to pass the callback
    _screens = [
      // OverviewScreen(onNavigateRequest: _onNavTap), // Pass the callback
      // const TeachersScreen(),
      // const CoursesScreen(),
       OverviewScreen(onNavigateRequest: _handleNavigationRequest),
      // Assign keys to the screens
      TeachersScreen(key: _teachersScreenKey),
      StudentsScreen(key: _studentsScreenKey), // <-- Add Student Screen
      CoursesScreen(key: _coursesScreenKey),
      const ReportsScreen(),
      const SettingsScreen(),
    ];
    assert(_screens.length == _titles.length);
     assert(_screens.length == 6); // Assuming 6 items now
  }

  void _onNavTap(int index) {
     _handleNavigationRequest(index); // Use the common handler
  }

  // Handles navigation requests from OverviewScreen or BottomNavBar
  void _handleNavigationRequest(int index, [String? action]) {
    if (index < 0 || index >= _screens.length || index == _currentIndex && action == null) return; // Avoid unnecessary rebuilds

    setState(() {
      _currentIndex = index; // Update the index immediately
    });

    // If an action is requested, trigger it *after* the frame is built
    if (action != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure the state is mounted before calling methods
        if (!mounted) return;

        try {
           if (action == 'add_teacher' && _currentIndex == 1) {
             _teachersScreenKey.currentState?.showAddTeacherDialogFromDashboard();}
             else if (action == 'add_student' && _currentIndex == 2) { // <-- Add handler for students
                    _studentsScreenKey.currentState?.showAddStudentDialogFromDashboard();
                } 
           else if (action == 'add_course' && _currentIndex == 3) {
             _coursesScreenKey.currentState?.showAddCourseDialogFromDashboard();
           }
        } catch (e) {
           print("Error calling dialog method via GlobalKey: $e");
           // Optionally show a generic error message to the user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not open the add dialog.'), backgroundColor: AppColors.error),
            );
        }
      });
    }
  }
 // *** MODIFIED LOGOUT FUNCTION ***
  Future<void> _logout() async {
    // 1. Show Confirmation Dialog
    final bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
             style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    // 2. Proceed only if confirmed
    if (confirmLogout == true) {
      // Outer try...catch for essential local logout steps
      try {
        // --- Optional Backend Notification ---
        final token = await _storage.read(key: "token");
        if (token != null) {
          // Inner try...catch for the non-critical backend call
          try {
            const String baseUrl = kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";
            final url = Uri.parse('$baseUrl/api/auth/logout'); // Your backend logout endpoint

            await http.post(
              url,
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $token", // Send the token
              },
              body: jsonEncode({}), // Empty body if backend doesn't need anything
            );
             print("Successfully notified backend of logout."); // Optional success log
          } catch (backendError) {
            // Log backend error but DO NOT stop the local logout process
            print("Failed to notify backend of logout (non-critical): $backendError");
          }
        }
        // --- End Optional Backend Notification ---

        // 3. Clear the stored token (Essential)
        await _storage.delete(key: "token");

        // 4. (Optional) Clear other state

        // 5. Navigate to Login Screen and remove routes (Essential)
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (Route<dynamic> route) => false,
          );
        }
      } catch (e) {
          // Handle errors during essential local logout (storage delete, navigation)
          print("Critical error during local logout: $e");
           if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Logout failed: $e'), backgroundColor: AppColors.error),
              );
           }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isWebApp = screenWidth >= webBreakpoint;
    
NavigationRail? navigationRail = isWebApp
        ? NavigationRail(
            // *** MAKE IT EXTENDED ***
            extended: true,
            selectedIndex: _currentIndex,
            onDestinationSelected: _onNavTap,
            // labelType: NavigationRailLabelType.all, // Not needed when extended: true
            backgroundColor: Theme.of(context).colorScheme.surface,
            indicatorColor: AppColors.primary.withOpacity(0.1),
            selectedIconTheme: const IconThemeData(color: AppColors.primary, size: 20), // Adjust size
            unselectedIconTheme: IconThemeData(color: AppColors.textSecondary.withOpacity(0.7), size: 20), // Adjust size
            selectedLabelTextStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600), // Adjust style
            unselectedLabelTextStyle: AppTextStyles.bodyText1.copyWith(color: AppColors.textSecondary), // Adjust style
            elevation: 1, // Subtle elevation
            // Use leading for potential header/logo
             leading: Padding(
               padding: const EdgeInsets.symmetric(vertical: 20.0),
               child: Row( // Or just Image.asset if only logo
                 children: [
                   const SizedBox(width: 16), // Indent icon slightly
                   Image.asset('assets/images/logo.png', height: 30), // Adjust logo size
                   const SizedBox(width: 12),
                   Text("Midadium", style: AppTextStyles.headline3),
                 ],
               ),
             ),
            // Use trailing for items at the bottom (like logout)
             trailing: Expanded(
                child: Align(
                  alignment: Alignment.bottomLeft, // Align content to bottom-left
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0), // Add horizontal padding
                    // Use TextButton.icon for Icon + Text
                    child: TextButton.icon(
                       icon: const Icon(Icons.logout_outlined, size: 20, color: Colors.red), // Keep icon
                       label: const Text('Logout'), // Add label
                       onPressed: _logout, // Assign logout function
                       
                       style: TextButton.styleFrom(
                          foregroundColor: AppColors.textPrimary, // Set text/icon color
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Adjust padding
                          alignment: Alignment.centerLeft, // Align icon/text left within button
                          minimumSize: const Size(double.infinity, 40), // Make button take available width
                       ).copyWith( // Ensure hover/splash are subtle if desired
                           overlayColor: MaterialStateProperty.resolveWith<Color?>(
                             (Set<MaterialState> states) {
                               if (states.contains(MaterialState.hovered)) {
                                 return AppColors.primary.withOpacity(0.04);
                               }
                               if (states.contains(MaterialState.pressed)) {
                                 return AppColors.primary.withOpacity(0.1);
                               }
                               return null; // Defer to the widget's default.
                             },
                           ),
                       ),
                    ),
                  ),
                ),
             ),
            destinations: const <NavigationRailDestination>[
               // Labels are automatically shown next to icons when extended: true
              NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), /* selectedIcon: Icon(Icons.dashboard), */ label: Text('Overview')),
              NavigationRailDestination(icon: Icon(Icons.person_outline), /* selectedIcon: Icon(Icons.person), */ label: Text('Teachers')),
              NavigationRailDestination(icon: Icon(Icons.school_outlined), /* selectedIcon: Icon(Icons.school), */ label: Text('Students')),
              NavigationRailDestination(icon: Icon(Icons.book_outlined), /* selectedIcon: Icon(Icons.book), */ label: Text('Courses')),
              NavigationRailDestination(icon: Icon(Icons.bar_chart_outlined), /* selectedIcon: Icon(Icons.bar_chart), */ label: Text('Reports')),
              NavigationRailDestination(icon: Icon(Icons.settings_outlined), /* selectedIcon: Icon(Icons.settings), */ label: Text('Settings')),
             
            ],
          )
        : null;

    // --- Bottom Nav Bar for Mobile ---
    CustomBottomNavBar? bottomNavBar = !isWebApp
        ? CustomBottomNavBar( // Using your existing custom widget
            currentIndex: _currentIndex > 4 ? 0 : _currentIndex, // Highlight first item if Settings is active
             onTap: _onNavTap, // Still triggers the main handler with index 0-4
          
          )
        : null;

    // --- Main Scaffold ---
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(_titles[_currentIndex]),
      //   // Don't show back button automatically if using side rail
      //   automaticallyImplyLeading: !isWebApp,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout_outlined),
      //       tooltip: 'Logout',
      //       onPressed: _logout,
      //     ),
      //   ],
      // ),
      // Body structure changes based on platform
     body: isWebApp
          ? Row(
              children: [
                // *** WRAP RAIL TO FIX WIDTH ***
                SizedBox(
                  width: fixedRailWidth, // Apply fixed width
                  child: navigationRail!,
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  // Add an AppBar here specific to the content area if needed
                  child: Scaffold( // Nested scaffold for content area app bar
                     appBar: AppBar(
                        title: Text(_titles[_currentIndex]), // Title specific to content
                         automaticallyImplyLeading: false,
                      ),
                    body: IndexedStack(
                      index: _currentIndex,
                      children: _screens,
                    ),
                  ),
                ),
              ],
            )
          // Mobile Layout
          : Scaffold( // Keep original mobile scaffold with AppBar
               appBar: AppBar(
                 title: Text(_titles[_currentIndex],),
                 automaticallyImplyLeading: !isWebApp,
                 actions: [
                  IconButton(
                       icon: const Icon(Icons.settings_outlined),
                       tooltip: 'Settings',
                       // Navigate directly to the Settings screen index
                       onPressed: () => _onNavTap(5),
                    ),
                    IconButton(icon: const Icon(Icons.logout_outlined), tooltip: 'Logout', onPressed: _logout,color: Colors.red,),
                 ],
               ),
              body: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              bottomNavigationBar: bottomNavBar,
            ),
      // Remove bottomNavBar if using the nested scaffold structure for web
      // bottomNavigationBar: bottomNavBar,
    );
  }
}