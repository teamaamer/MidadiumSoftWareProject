// هاااااااااااااااااظ زاااااااااااابططططططططططططططط
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';


// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({Key? key}) : super(key: key);

//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   bool _isLoading = false;

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     setState(() => _isLoading = true);

//     const String baseUrl = kIsWeb
//         ? "http://localhost:5000"
//         : "http://10.0.2.2:5000";

//     final url = Uri.parse('$baseUrl/api/auth/forgot-password');

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"email": _email}),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData['message'] ?? "Reset code sent to email")),
//         );
//          print("ForgotPasswordScreen: Navigating with email: $_email"); // Add for debugging
//         Navigator.pushReplacementNamed(context, '/reset-password',  arguments: _email );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData['message'] ?? "Failed to send email")),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("An error occurred: $error")),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5EEDC),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//                  Image.asset(
//                 'assets/images/Forgotpassword.png',
//                 width: 140,
//                 height: 140,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Forgot Password?",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0F2A50),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Enter your email to reset password",
//                 style: TextStyle(fontSize: 16, color: Colors.grey),
//               ),
//               const SizedBox(height: 30),

//               Card(
//                 color: const Color(0xFFF5EEDC),
//                 elevation: 0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: const Icon(Icons.email, color: Color(0xFF5A7BB5)),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(color: Color(0xFF0F2A50)),
//                             ),
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           onSaved: (value) => _email = value?.trim() ?? '',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Please enter your email";
//                             }
//                             if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                               return "Enter a valid email address";
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 24),

//                         _isLoading
//                             ? const CircularProgressIndicator()
//                             : ElevatedButton(
//                                 onPressed: _submit,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: const Color(0xFF0F2A50),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   padding: const EdgeInsets.symmetric(
//                                     horizontal: 32,
//                                     vertical: 14,
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Send Reset Code',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                         const SizedBox(height: 16),

//                         TextButton(
//                           onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
//                           child: const Text(
//                             "Remember your password? Login",
//                             style: TextStyle(color: Color(0xFF0F2A50)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// lib/screens/auth/forgot_password_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
// --- Use Theme Imports ---
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/custom_button.dart'; // Use CustomButton
import '../../widgets/loading_indicator.dart'; // Use LoadingIndicator

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key}); // Use super parameter

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    const String baseUrl = kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";
    final url = Uri.parse('$baseUrl/api/auth/forgot-password');

    try {
      final response = await http.post( url, headers: {"Content-Type": "application/json"},
         body: jsonEncode({"email": _email}), );
      final responseData = jsonDecode(response.body);

       if (!mounted) return; // Check mounted after await

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(responseData['message'] ?? "Reset code sent"), backgroundColor: AppColors.success),);
        print("ForgotPasswordScreen: Navigating with email: $_email");
        Navigator.pushReplacementNamed(context, '/reset-password', arguments: _email );
      } else {
        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(responseData['message'] ?? "Failed to send code"), backgroundColor: AppColors.error),);
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
      // Add AppBar for back navigation consistency
      appBar: AppBar(
        //  title: const Text('Forgot Password'),
          elevation: 0,
          backgroundColor: Colors.transparent, // Make AppBar transparent
          foregroundColor: AppColors.textPrimary, // Use theme color for icon
       ),
       extendBodyBehindAppBar: true, // Body behind AppBar
      // backgroundColor: AppColors.background, // Inherited from theme
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24), // Consistent padding
          // *** Constrain the width ***
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Image.asset(
                    'assets/images/Forgotpassword.png', // Ensure this path is correct
                    height: 100, // Adjusted size
                 ),
                 const SizedBox(height: 30), // Consistent spacing
                 Text( "Forgot Password?", style: AppTextStyles.headline1), // Use theme text style
                 const SizedBox(height: 8),
                 Text( "Enter your email to receive a reset code.", style: AppTextStyles.bodyText2, textAlign: TextAlign.center,), // Use theme text style
                 const SizedBox(height: 30),

                 // Use Card Theme from main.dart
                 Card(
                    // elevation: 1.0, // Optional: Add elevation if theme doesn't
                    child: Padding(
                      padding: const EdgeInsets.all(24.0), // Consistent inner padding
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch button
                          children: [
                            // Email Field
                            TextFormField(
                              // Use theme decoration
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (value) => _email = value?.trim() ?? '',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter your email";
                                }
                                // More robust email regex
                                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value.trim())) {
                                  return "Enter a valid email address";
                                }
                                return null;
                              },
                               enabled: !_isLoading,
                            ),
                            const SizedBox(height: 24),

                            // Submit Button
                            _isLoading
                                ? const Center(child: LoadingIndicator()) // Use consistent loading indicator
                                : CustomButton( // Use CustomButton
                                    onPressed: _submit,
                                    text: 'Send Reset Code',
                                  ),
                          ],
                        ),
                      ),
                    ),
                 ),
                 const SizedBox(height: 20),

                 // Login Navigation Button
                 TextButton(
                   onPressed: _isLoading ? null : () => Navigator.pushReplacementNamed(context, '/login'),
                   child: const Text("Remember Password? Login"), // Use theme style
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}