// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter/foundation.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   String _password = '';
//   bool _obscurePassword = true;
//   bool _isLoading = false; // Add loading state

//   final _storage = const FlutterSecureStorage();

//   // Toggle password visibility
//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscurePassword = !_obscurePassword;
//     });
//   }

// Future<void> _submit() async {
//   if (!_formKey.currentState!.validate()) return;

//   _formKey.currentState!.save();
//   setState(() => _isLoading = true);
// const String baseUrl = kIsWeb
//     ? "http://localhost:5000"  // Web uses localhost
//     : "http://10.0.2.2:5000";  // Android Emulator uses 10.0.2.2

// final url = Uri.parse('$baseUrl/api/auth/login');

//   try {
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({"email": _email, "password": _password}),
//     );

//     final responseData = jsonDecode(response.body);

//     if (response.statusCode == 200) {
//       // Store JWT token securely
//       await _storage.write(key: "token", value: responseData['token']);

//       // Get the role from the response. Assuming your API returns:
//       // { token: '...', user: { id: '...', username: '...', email: '...', role: 'teacher' } }
//       final String role = responseData['user']['role'];

//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Login successful!")));

//       // Role-based navigation:
//       if (role == 'admin') {
//         Navigator.pushReplacementNamed(context, '/admin-dashboard');
//       } else if (role == 'teacher') {
//         Navigator.pushReplacementNamed(context, '/teacher-dashboard');
//       } else if (role == 'student') {
//         Navigator.pushReplacementNamed(context, '/student-dashboard');
//       } else {
//         // Fallback to a generic home screen if needed.
//         Navigator.pushReplacementNamed(context, '/home');
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(responseData['message'] ?? "Login failed")),
//       );
//     }
//   } catch (error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("An error occurred: $error")),
//     );
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // Email field
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Email',
//                   prefixIcon: Icon(Icons.email),
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 onSaved: (value) => _email = value ?? '',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your email";
//                   }
//                   if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                     return "Enter a valid email address";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               // Password field
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   prefixIcon: const Icon(Icons.lock),
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _obscurePassword
//                           ? Icons.visibility
//                           : Icons.visibility_off,
//                     ),
//                     onPressed: _togglePasswordVisibility,
//                   ),
//                 ),
//                 obscureText: _obscurePassword,
//                 onSaved: (value) => _password = value ?? '',
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Please enter your password";
//                   }
//                   if (value.length < 6) {
//                     return "Password must be at least 6 characters";
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               // Login button
//               _isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                     onPressed: _submit,
//                     child: const Text('Login'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//               const SizedBox(height: 16),
//               // Forgot password link
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/forgot-password');
//                 },
//                 child: const Text("Forgot your password?"),
//               ),
//               // Sign-up navigation
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/signup');
//                 },
//                 child: const Text("Don't have an account? Sign Up"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';
import '../../config/app_colors.dart'; // Use AppColors
import '../../config/app_text_styles.dart'; // Use AppTextStyles
import '../../widgets/custom_button.dart'; // Use CustomButton if preferred
import '../../widgets/loading_indicator.dart'; // Use LoadingIndicator

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _isLoading = false;

  final _storage = const FlutterSecureStorage();

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    const String baseUrl = kIsWeb
        ? "http://localhost:5000"
        : "http://10.0.2.2:5000";

    final url = Uri.parse('$baseUrl/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": _email, "password": _password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await _storage.write(key: "token", value: responseData['token']);
        final String role = responseData['user']['role'];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful!"),backgroundColor: AppColors.success),
        );

        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else if (role == 'teacher') {
          Navigator.pushReplacementNamed(context, '/teacher-dashboard');
        } else if (role == 'student') {
          Navigator.pushReplacementNamed(context, '/student-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Login failed"),backgroundColor: AppColors.error),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error"), backgroundColor: AppColors.error),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Light background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
            child: Container(
             constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/logo.png', // Replace with your actual logo
                width: 140,
                height: 140,
              ),
              const SizedBox(height: 30),

              Text("Welcome Back", style: AppTextStyles.headline1),
                const SizedBox(height: 8),
                Text("Login to continue", style: AppTextStyles.bodyText2),
                const SizedBox(height: 30),


              // Card for Login Form
              Card(
                color: AppColors.background,
                elevation: 0, // Adds shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF5A7BB5)), // Light Blue
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF0F2A50)), // Dark Blue
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _email = value ?? '',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return "Enter a valid email address";
                            }
                            return null;
                          },
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock, color: Color(0xFF5A7BB5)), // Light Blue
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF0F2A50)), // Dark Blue
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                color: const Color(0xFF5A7BB5), // Light Blue
                              ),
                              onPressed: _togglePasswordVisibility,
                            ),
                          ),
                          obscureText: _obscurePassword,
                          onSaved: (value) => _password = value ?? '',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                              enabled: !_isLoading,
                        ),
                      //  const SizedBox(height: 2),
                          // Forgot Password
                              Padding(
                            padding: const EdgeInsets.only(top:1.0),
                           child:  Align(
                                 alignment: Alignment.centerLeft,
                                 child: TextButton(
                                     onPressed: _isLoading ? null : () => Navigator.pushNamed(context, '/forgot-password'),
                                     child: const Text("Forgot Password?",style: TextStyle(fontSize: 12),)// Use theme style
                                   ),
                               ),
                            ),
                            const SizedBox(height: 2),
                            // Login Button
                            _isLoading
                                ? const Center(child: LoadingIndicator())
                                : CustomButton(
                                    onPressed: _submit,
                                    text: 'Login',
                                  ),
                          ],
                        ),
                      ),
                    ),
                 ),
                const SizedBox(height: 20),

              // Sign-up Navigation
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pushReplacementNamed(context, '/signup'),
                  child: const Text("Don't have an account? Sign Up",
                  style: TextStyle(color: Color(0xFF0F2A50)), // Dark Blue
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
