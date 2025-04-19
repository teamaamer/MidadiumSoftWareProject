// // // lib/widgets/bottom_nav_bar.dart
// // import 'package:flutter/material.dart';

// // class CustomBottomNavBar extends StatelessWidget {
// //   final int currentIndex;
// //   final Function(int) onTap;

// //   const CustomBottomNavBar({
// //     Key? key,
// //     required this.currentIndex,
// //     required this.onTap,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return BottomNavigationBar(
// //       currentIndex: currentIndex,
// //       onTap: onTap,
// //       backgroundColor: const Color(0xFFF5EEDC),
// //       selectedItemColor: const Color(0xFF27548A),
// //       unselectedItemColor: const Color(0xFF183B4E),
// //       items: const [
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.dashboard),
// //           label: 'Overview',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.person),
// //           label: 'Teachers',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.book),
// //           label: 'Courses',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.bar_chart),
// //           label: 'Reports',
// //         ),
// //         BottomNavigationBarItem(
// //           icon: Icon(Icons.settings),
// //           label: 'Settings',
// //         ),
// //       ],
// //     );
// //   }
// // }
// // lib/widgets/bottom_nav_bar.dart
// import 'package:flutter/material.dart';
// import '../config/app_colors.dart'; // Import AppColors

// class CustomBottomNavBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const CustomBottomNavBar({
//     Key? key,
//     required this.currentIndex,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Uses BottomNavigationBarTheme from Theme.of(context)
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: onTap,
//       // Removed explicit colors/styles, they come from the theme now
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.dashboard_outlined),
//           activeIcon: Icon(Icons.dashboard), // Optional: different icon when active
//           label: 'Overview',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           activeIcon: Icon(Icons.person),
//           label: 'Teachers',
//         ),
//          BottomNavigationBarItem(
//             icon: Icon(Icons.people_alt_outlined), // Student icon
//             activeIcon: Icon(Icons.people_alt),
//             label: 'Students',
//           ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.book_outlined),
//           activeIcon: Icon(Icons.book),
//           label: 'Courses',
//         ),
        
//         BottomNavigationBarItem(
//           icon: Icon(Icons.bar_chart_outlined),
//           activeIcon: Icon(Icons.bar_chart),
//           label: 'Reports',
//         ),
//         // BottomNavigationBarItem(
//         //   icon: Icon(Icons.settings_outlined),
//         //   activeIcon: Icon(Icons.settings),
//         //   label: 'Settings',
//         // ),
//       ],
//     );
//  
// }
// }
// lib/widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
// No need to import AppColors if using theme

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key, // Use super parameter
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Uses BottomNavigationBarTheme from Theme.of(context)
    return BottomNavigationBar(
     
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [ // Now only 5 items
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Overview', // Index 0
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Teachers', // Index 1
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Students', // Index 2
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book_outlined),
          activeIcon: Icon(Icons.book),
          label: 'Courses', // Index 3
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart_outlined),
          activeIcon: Icon(Icons.bar_chart),
          label: 'Reports', // Index 4
        ),
        // Removed Settings Item (Index 5)
      ],
    );
  }
}