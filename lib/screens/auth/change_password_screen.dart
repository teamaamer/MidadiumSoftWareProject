// // lib/screens/auth/change_password_screen.dart
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // To get token

// import '../../config/app_colors.dart';
// import '../../config/app_text_styles.dart';
// import '../../widgets/custom_button.dart';
// import '../../widgets/custom_card.dart';
// import '../../widgets/loading_indicator.dart'; // Use consistent loading indicator


// class ChangePasswordScreen extends StatefulWidget {
//   const ChangePasswordScreen({Key? key}) : super(key: key);

//   @override
//   _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _storage = const FlutterSecureStorage(); // For token access

//   String _currentPassword = '';
//   String _newPassword = '';
//   String _confirmPassword = '';

//   bool _obscureCurrentPassword = true;
//   bool _obscureNewPassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;

//   void _toggleCurrentPasswordVisibility() => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
//   void _toggleNewPasswordVisibility() => setState(() => _obscureNewPassword = !_obscureNewPassword);
//   void _toggleConfirmPasswordVisibility() => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

//   Future<String?> _getToken() async {
//     return await _storage.read(key: "token");
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     // Redundant check, validator handles this, but good practice
//     if (_newPassword != _confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("New passwords do not match"), backgroundColor: AppColors.error),
//       );
//       return;
//     }

//      if (_currentPassword == _newPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("New password cannot be the same as the current password"), backgroundColor: AppColors.error),
//       );
//       return;
//     }


//     setState(() => _isLoading = true);

//     final token = await _getToken();
//     if (token == null) {
//        ScaffoldMessenger.of(context).showSnackBar(
//          const SnackBar(content: Text("Authentication error. Please log in again."), backgroundColor: AppColors.error),
//        );
//        // Optionally navigate to login screen
//        // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//        setState(() => _isLoading = false);
//        return;
//     }

//     const String baseUrl = kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";
//     // Adjust the endpoint path based on your backend setup
//     final url = Uri.parse('$baseUrl/api/auth/change-password'); // Or /api/user/change-password

//     try {
//       final response = await http.put( // Use PUT as defined in the backend route
//         url,
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token", // Send token
//         },
//         body: jsonEncode({
//           "currentPassword": _currentPassword,
//           "newPassword": _newPassword,
//         }),
//       );

//       final responseData = jsonDecode(response.body);

//       if (!mounted) return; // Check if widget is still mounted before showing snackbar/navigating

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(responseData['message'] ?? "Password changed successfully"),
//             backgroundColor: AppColors.success,
//           ),
//         );
//         Navigator.pop(context); // Go back to the previous screen (Settings)
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(responseData['message'] ?? "Failed to change password"),
//             backgroundColor: AppColors.error,
//           ),
//         );
//       }
//     } catch (error) {
//        if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred: $error"), backgroundColor: AppColors.error),
//       );
//     } finally {
//        if (mounted) {
//          setState(() => _isLoading = false);
//        }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Change Password"),
//         leading: IconButton( // Add back button explicitly if needed
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: CustomCard( // Wrap form in a card for consistency
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
//                 crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch button
//                 children: [
//                   Text(
//                     "Update Your Password",
//                     style: AppTextStyles.headline3,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "Enter your current password and set a new one.",
//                     style: AppTextStyles.bodyText2,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),

//                   // Current Password Field
//                   TextFormField(
//                     decoration: InputDecoration( // Uses theme styles
//                       labelText: 'Current Password',
//                       prefixIcon: const Icon(Icons.lock_clock_outlined),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                         ),
//                         onPressed: _toggleCurrentPasswordVisibility,
//                       ),
//                     ),
//                     obscureText: _obscureCurrentPassword,
//                     onSaved: (value) => _currentPassword = value ?? '',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return "Please enter your current password";
//                       return null;
//                     },
//                     enabled: !_isLoading,
//                   ),
//                   const SizedBox(height: 16),

//                   // New Password Field
//                   TextFormField(
//                     decoration: InputDecoration( // Uses theme styles
//                       labelText: 'New Password',
//                       prefixIcon: const Icon(Icons.lock_outline),
//                        suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                         ),
//                         onPressed: _toggleNewPasswordVisibility,
//                       ),
//                     ),
//                     obscureText: _obscureNewPassword,
//                     onSaved: (value) => _newPassword = value ?? '',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return "Please enter a new password";
//                       if (value.length < 6) return "Password must be at least 6 characters";
//                       return null;
//                     },
//                      enabled: !_isLoading,
//                      // Update validator for confirm password when this changes
//                      onChanged: (value) => _newPassword = value,
//                   ),
//                   const SizedBox(height: 16),

//                   // Confirm New Password Field
//                   TextFormField(
//                     decoration: InputDecoration( // Uses theme styles
//                       labelText: 'Confirm New Password',
//                       prefixIcon: const Icon(Icons.lock_outline),
//                        suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
//                         ),
//                         onPressed: _toggleConfirmPasswordVisibility,
//                       ),
//                     ),
//                     obscureText: _obscureConfirmPassword,
//                     onSaved: (value) => _confirmPassword = value ?? '',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return "Please confirm your new password";
//                       if (value != _newPassword) return "Passwords do not match";
//                       return null;
//                     },
//                      enabled: !_isLoading,
//                   ),
//                   const SizedBox(height: 30),

//                   // Submit Button
//                   _isLoading
//                       ? const Center(child: LoadingIndicator()) // Use consistent indicator
//                       : CustomButton( // Use CustomButton
//                           onPressed: _submit,
//                           text: 'Update Password',
//                           icon: Icons.save_outlined, // Add an icon
//                         ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/screens/admin/change_password_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// --- Use Theme Imports ---
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/custom_button.dart'; // Assuming you prefer this
import '../../widgets/loading_indicator.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key}); // Use super parameter

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  // Use controllers for better control and potentially less state management complexity
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Still need obscure state variables
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Keep toggle functions
  void _toggleCurrentPasswordVisibility() => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword);
  void _toggleNewPasswordVisibility() => setState(() => _obscureNewPassword = !_obscureNewPassword);
  void _toggleConfirmPasswordVisibility() => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

  // Dispose controllers
  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


  Future<String?> _getToken() async {
    return await _storage.read(key: "token");
  }

  Future<void> _submit() async {
    // Validate using the controllers now
    if (!_formKey.currentState!.validate()) return;
    // No need for _formKey.currentState!.save() when using controllers

    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    // Confirm password value is checked by the validator directly

    // Keep these checks
     if (currentPassword == newPassword) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("New password cannot be the same as the current password"), backgroundColor: AppColors.error),);
      return;
    }

    setState(() => _isLoading = true);

    final token = await _getToken();
    if (token == null) {
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text("Authentication error. Please log in again."), backgroundColor: AppColors.error),);
       setState(() => _isLoading = false);
       return;
    }

    const String baseUrl = kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";
    final url = Uri.parse('$baseUrl/api/auth/change-password');

    try {
      final response = await http.put(
        url,
        headers: { "Content-Type": "application/json", "Authorization": "Bearer $token", },
        // Send values from controllers
        body: jsonEncode({ "currentPassword": currentPassword, "newPassword": newPassword, }),
      );
      final responseData = jsonDecode(response.body);
      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(responseData['message'] ?? "Password changed successfully"), backgroundColor: AppColors.success), );
        Navigator.pop(context); // Go back
      } else {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(responseData['message'] ?? "Failed to change password"), backgroundColor: AppColors.error),);
      }
    } catch (error) {
       if (!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("An error occurred: $error"), backgroundColor: AppColors.error),);
    } finally {
       if (mounted) { setState(() => _isLoading = false); }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use AppBar theme defined in main.dart
      appBar: AppBar(
        title: const Text("Change Password"),
        // Optional: Add explicit back button if needed on some platforms
         leading: IconButton(
           icon: const Icon(Icons.arrow_back),
           onPressed: () => Navigator.of(context).pop(),
         ),
      ),
      // Use Scaffold background from theme
      body: Center( // Center the content vertically and horizontally
        child: SingleChildScrollView( // Allow scrolling on smaller screens
          padding: const EdgeInsets.all(24.0), // Consistent padding
          // *** Constrain width for web/large screens ***
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500), // Adjust max width as needed
            child: Card( // Wrap form in a Card for visual structure (uses theme)
               child: Padding(
                 padding: const EdgeInsets.all(24.0), // Padding inside card
                 child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Column takes minimum vertical space
                    crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch button to fit card width
                    children: [
                      Text( "Update Your Password", style: AppTextStyles.headline3, textAlign: TextAlign.center, ),
                      const SizedBox(height: 8),
                      Text( "Enter your current password and set a new one.", style: AppTextStyles.bodyText2, textAlign: TextAlign.center, ),
                      const SizedBox(height: 30),

                      // Current Password Field
                      TextFormField(
                        controller: _currentPasswordController, // Use controller
                        decoration: InputDecoration( // Uses theme styles
                          labelText: 'Current Password',
                          prefixIcon: const Icon(Icons.lock_clock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon( _obscureCurrentPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, ),
                            onPressed: _toggleCurrentPasswordVisibility,
                          ),
                        ),
                        obscureText: _obscureCurrentPassword,
                        // onSaved not needed with controller
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter your current password";
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),

                      // New Password Field
                      TextFormField(
                        controller: _newPasswordController, // Use controller
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                           suffixIcon: IconButton(
                            icon: Icon( _obscureNewPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, ),
                            onPressed: _toggleNewPasswordVisibility,
                          ),
                        ),
                        obscureText: _obscureNewPassword,
                        // onSaved not needed with controller
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please enter a new password";
                          if (value.length < 6) return "Password must be at least 6 characters";
                          return null;
                        },
                         enabled: !_isLoading,
                        // Re-validate confirm password when this changes
                         onChanged: (value) {
                            // Trigger revalidation of the confirm password field if needed
                            _formKey.currentState?.validate();
                         },
                      ),
                      const SizedBox(height: 16),

                      // Confirm New Password Field
                      TextFormField(
                        controller: _confirmPasswordController, // Use controller
                        decoration: InputDecoration(
                          labelText: 'Confirm New Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                           suffixIcon: IconButton(
                            icon: Icon( _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, ),
                            onPressed: _toggleConfirmPasswordVisibility,
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        // onSaved not needed with controller
                        validator: (value) {
                          if (value == null || value.isEmpty) return "Please confirm your new password";
                          // Compare with the NEW password controller's value
                          if (value != _newPasswordController.text) return "Passwords do not match";
                          return null;
                        },
                         enabled: !_isLoading,
                      ),
                      const SizedBox(height: 30),

                      // Submit Button
                      _isLoading
                          ? const Center(child: LoadingIndicator())
                          : CustomButton(
                              onPressed: _submit,
                              text: 'Update Password',
                              icon: Icons.save_outlined,
                            ),
                    ],
                  ),
                             ),
               ),
            ),
          ),
        ),
      ),
    );
  }
}