
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/foundation.dart';

// class ResetPasswordScreen extends StatefulWidget {
//   final String? resetToken;
//   final String? email;

//   const ResetPasswordScreen({Key? key, this.resetToken, this.email}) : super(key: key);

//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }

// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String _email;
//   String _resetCode = '';
//   String _password = '';
//   String _confirmPassword = '';
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _email = widget.email ?? '';
//     if (widget.resetToken != null) _resetCode = widget.resetToken!;
//   }

//   void _togglePasswordVisibility() => setState(() => _obscurePassword = !_obscurePassword);
//   void _toggleConfirmPasswordVisibility() => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();

//     if (_password != _confirmPassword) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Passwords do not match")),
//       );
//       return;
//     }

//     setState(() => _isLoading = true);

//     const String baseUrl = kIsWeb
//         ? "http://localhost:5000"
//         : "http://10.0.2.2:5000";

//     final url = Uri.parse('$baseUrl/api/auth/reset-password');

//     try {
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({
//           "email": _email,
//           "resetCode": _resetCode,
//           "password": _password,
//         }),
//       );

//       final responseData = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData['message'] ?? "Password reset successful")),
//         );
//         Navigator.pushReplacementNamed(context, '/login');
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData['message'] ?? "Password reset failed")),
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
//               Image.asset(
//                 'assets/images/resetpassword.png',
//                 width: 140,
//                 height: 140,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Reset Password",
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF0F2A50),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "Enter your new password",
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
//                         Text(
//                           "Reset for: $_email",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Color(0xFF0F2A50),
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         TextFormField(
//                           initialValue: widget.resetToken,
//                           decoration: InputDecoration(
//                             labelText: 'Reset Code',
//                             prefixIcon: const Icon(Icons.confirmation_number, color: Color(0xFF5A7BB5)),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(color: Color(0xFF0F2A50)),
//                             ),
//                           ),
//                           onSaved: (value) => _resetCode = value?.trim() ?? '',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) return "Please enter the reset code";
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'New Password',
//                             prefixIcon: const Icon(Icons.lock, color: Color(0xFF5A7BB5)),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(color: Color(0xFF0F2A50)),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword ? Icons.visibility : Icons.visibility_off,
//                                 color: const Color(0xFF5A7BB5),
//                               ),
//                               onPressed: _togglePasswordVisibility,
//                             ),
//                           ),
//                           obscureText: _obscurePassword,
//                           onSaved: (value) => _password = value ?? '',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) return "Please enter your new password";
//                             if (value.length < 6) return "Password must be at least 6 characters";
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 16),

//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Confirm Password',
//                             prefixIcon: const Icon(Icons.lock, color: Color(0xFF5A7BB5)),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                               borderSide: const BorderSide(color: Color(0xFF0F2A50)),
//                             ),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
//                                 color: const Color(0xFF5A7BB5),
//                               ),
//                               onPressed: _toggleConfirmPasswordVisibility,
//                             ),
//                           ),
//                           obscureText: _obscureConfirmPassword,
//                           onSaved: (value) => _confirmPassword = value ?? '',
//                           validator: (value) {
//                             if (value == null || value.isEmpty) return "Please confirm your password";
//                             if (value != _password) return "Passwords do not match";
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
//                                   'Reset Password',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
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
// lib/screens/auth/reset_password_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../config/app_colors.dart';
import '../../config/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String? resetToken; // From potential deep link
  final String? email;      // Passed from ForgotPasswordScreen

  const ResetPasswordScreen({super.key, this.resetToken, this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _resetCodeController;
  String _password = '';
  // No need for _confirmPassword state variable
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _resetCodeController = TextEditingController(text: widget.resetToken ?? '');
    // Show error immediately if email is missing
     WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.email == null || widget.email!.isEmpty) {
           if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Error: Email address not provided for reset. Please go back and try again."), backgroundColor: AppColors.error, duration: Duration(seconds: 5)));
           }
        }
     });
  }

   @override
  void dispose() {
    _resetCodeController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() => setState(() => _obscurePassword = !_obscurePassword);
  void _toggleConfirmPasswordVisibility() => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);

  Future<void> _submit() async {
    // *** Directly use widget.email and add validation ***
    final String currentEmail = widget.email ?? ''; // Get email directly from widget property
    if (currentEmail.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email is missing. Cannot proceed."), backgroundColor: AppColors.error));
       return;
    }

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save(); // Saves _password

    final String currentResetCode = _resetCodeController.text.trim();

    setState(() => _isLoading = true);
     const String baseUrl = kIsWeb ? "http://localhost:5000" : "http://10.0.2.2:5000";
     final url = Uri.parse('$baseUrl/api/auth/reset-password');

     try {
         // *** Send currentEmail (from widget.email) ***
         final response = await http.put( url, headers: {"Content-Type": "application/json"},
            body: jsonEncode({ "email": currentEmail, "resetCode": currentResetCode, "password": _password, }), );
          final responseData = jsonDecode(response.body);
          if (!mounted) return;

           if (response.statusCode == 200) {
               ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(responseData['message'] ?? "Password reset successful"), backgroundColor: AppColors.success),);
               Navigator.pushReplacementNamed(context, '/login');
           } else {
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(responseData['message'] ?? "Password reset failed"), backgroundColor: AppColors.error),);
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
       appBar: AppBar(
        //title: const Text('Reset Password'),
         elevation: 0, backgroundColor: Colors.transparent, foregroundColor: AppColors.textPrimary,),
       extendBodyBehindAppBar: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
             constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/resetpassword.png', height: 100,),
                const SizedBox(height: 30),
                Text("Reset Password", style: AppTextStyles.headline1),
                const SizedBox(height: 8),
                Text("Enter the code sent to your email and set a new password.", style: AppTextStyles.bodyText2, textAlign: TextAlign.center,),
                 Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    // *** Display email directly from widget property ***
                    child: Text( "Resetting for: ${widget.email ?? 'Error: No Email Provided'}", style: AppTextStyles.subtitle1,),
                  ),

                 Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                             // Reset Code
                             TextFormField(
                              controller: _resetCodeController,
                              decoration: const InputDecoration( labelText: 'Reset Code', prefixIcon: Icon(Icons.confirmation_number_outlined)),
                              validator: (value) => value == null || value.trim().isEmpty ? 'Reset code required' : null,
                               enabled: !_isLoading,
                             ),
                             const SizedBox(height: 16),
                             // New Password
                             TextFormField(
                              decoration: InputDecoration( labelText: 'New Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton( icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: _togglePasswordVisibility, ),),
                              obscureText: _obscurePassword,
                              onSaved: (value) => _password = value ?? '', // Save to _password state
                               validator: (value) {
                                   if (value == null || value.isEmpty) return 'New password required';
                                   if (value.length < 6) return 'Password must be at least 6 characters';
                                   return null;
                                },
                                enabled: !_isLoading,
                                onChanged: (value) => _password = value, // Update _password state for validator
                             ),
                             const SizedBox(height: 16),
                             // Confirm New Password
                              TextFormField(
                                decoration: InputDecoration( labelText: 'Confirm New Password', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton( icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: _toggleConfirmPasswordVisibility, ),),
                                obscureText: _obscureConfirmPassword,
                                validator: (value) {
                                    if (value == null || value.isEmpty) return 'Please confirm your password';
                                    if (value != _password) return "Passwords do not match"; // Compare with current _password state
                                    return null;
                                 },
                                enabled: !_isLoading,
                              ),
                             const SizedBox(height: 24),
                             // Submit Button
                              _isLoading
                                  ? const Center(child: LoadingIndicator())
                                  : CustomButton(
                                          onPressed: 
                                          //(widget.email == null || widget.email!.isEmpty)
                                        //   ? null // Assign null if email is missing
                                        //   : _submit, // Assign the async function directly *if not null*
                                               // OR if the above still fails try:
                                            () => _submit(), // Wrap in non-nullable void Function()

                                      text: 'Reset Password',
                                    ),
                          ],
                        ),
                      ),
                    ),
                 ),
                 const SizedBox(height: 20),
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text("Back to Login"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}