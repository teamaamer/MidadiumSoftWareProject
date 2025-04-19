
import 'package:flutter/material.dart';
////
import 'config/app_colors.dart'; // Import colors
import 'config/app_text_styles.dart'; // Import text styles
///
import 'screens/welcome_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/student/student_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Midadium',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        hintColor: AppColors.accent, // Often used for accents
       scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          background: AppColors.background,
          error: AppColors.error,
          surface: AppColors.cardBackground, // Card/Dialog backgrounds
        ),
        appBarTheme: AppBarTheme(
           elevation: 0, // Remove default elevation
          centerTitle: false, // Align title left (common modern style)
          backgroundColor: AppColors.appBarBackground, // Use defined color (e.g., white)
          foregroundColor: AppColors.appBarForeground, // Icon/action color (dark text)
          iconTheme: const IconThemeData(color: AppColors.appBarForeground, size: 22), // Back arrow etc.
          actionsIconTheme: const IconThemeData(color: AppColors.appBarForeground, size: 22), // Actions like logout
          titleTextStyle: AppTextStyles.headline3.copyWith(color: AppColors.appBarForeground), // Title style
          // Add a subtle bottom border for separation instead of elevation
          // shape: const Border(
          //    bottom: BorderSide(
          //      color: AppColors.divider, // Use a subtle divider color
          //      width: 1.0,
          //    )
          // ),
        ),
        textTheme: TextTheme( // Apply GoogleFonts globally
          displayLarge: AppTextStyles.headline1,
          displayMedium: AppTextStyles.headline2,
          displaySmall: AppTextStyles.headline3,
          headlineMedium: AppTextStyles.headline3, // Map headline styles
          headlineSmall: AppTextStyles.subtitle1,
          titleLarge: AppTextStyles.subtitle1,    // Map title styles
          titleMedium: AppTextStyles.bodyText1,
          titleSmall: AppTextStyles.bodyText2,
          bodyLarge: AppTextStyles.bodyText1,       // Map body styles
          bodyMedium: AppTextStyles.bodyText2,
          labelLarge: AppTextStyles.button,       // Map button styles
          bodySmall: AppTextStyles.caption,      // Map caption styles
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textLight,
            textStyle: AppTextStyles.button,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: AppColors.background.withOpacity(0.5)), // Subtle border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          labelStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.textSecondary),
          hintStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.textSecondary.withOpacity(0.7)),
          prefixIconColor: AppColors.textSecondary,
        ),
        cardTheme: CardTheme(
           color: AppColors.cardBackground,
           elevation: 1.5, // Subtle elevation
           margin: const EdgeInsets.symmetric(vertical: 8.0), // Consistent margin
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(12),
            //  side: BorderSide(color: AppColors.background.withOpacity(0.6), width: 0.5) // Optional subtle border
           ),
        ),
        dialogTheme: DialogTheme(
          backgroundColor: AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          titleTextStyle: AppTextStyles.headline3,
          contentTextStyle: AppTextStyles.bodyText1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.cardBackground, // White background for contrast
          selectedItemColor: AppColors.primary,     // Active item color
          unselectedItemColor: AppColors.textSecondary, // Inactive item color
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          type: BottomNavigationBarType.fixed, // Ensure all items are visible
          elevation: 5.0, // Add some elevation
        ),
        // chipTheme: ChipThemeData(
        //   backgroundColor: AppColors.chipBackground,
        //   selectedColor: const Color.fromRGBO(208, 216, 224, 1),
        //   secondarySelectedColor: AppColors.primary, // Ensure consistency
        //   labelStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.textPrimary),
        //   secondaryLabelStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.textLight), // Text on selected chip
        //   checkmarkColor: AppColors.textLight,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //     side: BorderSide.none,
        //   ),
        //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        // ),
        // chipTheme: ChipThemeData(
        //   backgroundColor: AppColors.chipBackground, // e.g., #D0D8E0
        //   // *** FIX: Use a contrasting selected color ***
        //   selectedColor: const Color.fromARGB(255, 110, 143, 183), // e.g., #27548A (Your primary blue)
        //   // secondarySelectedColor is less relevant if not using specific chip types needing it
        //   labelStyle: AppTextStyles.caption.copyWith(color: AppColors.textPrimary), // Text color for UNSELECTED chip
        //   // *** Use secondaryLabelStyle for SELECTED text color ***
        //   secondaryLabelStyle: AppTextStyles.caption.copyWith(color: AppColors.textLight, fontWeight: FontWeight.w600), // White & semi-bold for SELECTED chip
        //   checkmarkColor: AppColors.textLight, // Color if checkmark were shown
        //   // Keep shape or adjust if needed
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(20),
        //     // side: BorderSide.none, // Keep no border by default in theme
        //      side: BorderSide(color: AppColors.divider.withOpacity(0.5), width: 0.5) // Or add default border
        //   ),
        //   // Set the desired default padding
        //  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),// Use desired padding here
        //    showCheckmark: false, // Set default checkmark visibility in theme
        //    iconTheme: IconThemeData( // Default theme for icons within chips
        //       color: AppColors.textSecondary,
        //       size: 16,
        //    ),
        // ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.primary,
        ),
        snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.secondary,
            contentTextStyle: AppTextStyles.bodyText2.copyWith(color: AppColors.textLight),
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(8),
             ),
        ),
      ),
      initialRoute: '/',
      routes: {
         '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/teacher-dashboard': (context) => const TeacherDashboard(),
        '/student-dashboard': (context) => const StudentDashboard(),
        '/home': (context) => const HomeScreen(),
       // '/reset-password': (context) => const ResetPasswordScreen(), // Keep this if needed for static access
      },
onGenerateRoute: (settings) {
 // if (settings.name != null && settings.name!.startsWith('/reset-password')) {
 if (settings.name == '/reset-password') {
    // Retrieve the email from arguments if provided
      final String? emailArgument = settings.arguments as String?;
   // final args = settings.arguments as String?;
    String? resetToken;
    // If deep linking is used, you can also extract the token
    if (settings.name!.contains('/')) {
      final segments = settings.name!.split('/');
      if (segments.length > 2) {
        resetToken = segments.last;
      }
    }
    return MaterialPageRoute(
      builder: (context) => ResetPasswordScreen(
        resetToken: resetToken,
        email: emailArgument, // email passed from Forgot Password screen
      ),
    );
  }
  return null;
},

    );
  }
}
