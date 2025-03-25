
import 'package:flutter/material.dart';
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
      title: 'Educational Management Platform',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/admin-dashboard': (context) => const AdminDashboard(),
        '/teacher-dashboard': (context) => const TeacherDashboard(),
        '/student-dashboard': (context) => const StudentDashboard(),
        '/home': (context) => const HomeScreen(),
        // Optionally, if you want a static reset password route:
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
onGenerateRoute: (settings) {
  if (settings.name != null && settings.name!.startsWith('/reset-password')) {
    // Retrieve the email from arguments if provided
    final args = settings.arguments as String?;
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
        email: args, // email passed from Forgot Password screen
      ),
    );
  }
  return null;
},

    );
  }
}
