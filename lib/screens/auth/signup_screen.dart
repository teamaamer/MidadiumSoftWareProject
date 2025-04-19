
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

import '../../config/app_colors.dart' show AppColors;
import '../../config/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_indicator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();
  final List<String> roles = ['student', 'teacher'];

  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  String _selectedRole = 'student';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);

    const String baseUrl = kIsWeb
        ? "http://localhost:5000"
        : "http://10.0.2.2:5000";

    final url = Uri.parse('$baseUrl/api/auth/signup');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _username,
          "email": _email,
          "password": _password,
          "role": _selectedRole,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        await _storage.write(key: "token", value: responseData['token']);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup successful!")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Signup failed")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(225, 230, 235, 1),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
           child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              //const SizedBox(height: 20),
              // const Text(
              //   "Create Account",
              //   style: TextStyle(
              //     fontSize: 26,
              //     fontWeight: FontWeight.bold,
              //     color: Color.fromARGB(255, 8, 24, 45),
              //   ),
              // ),
              Text( "Create Account", style: AppTextStyles.headline1),
              const SizedBox(height: 8),
              // const Text(
              //   "Sign up to get started",
              //   style: TextStyle(fontSize: 16, color: Colors.grey),
              // ),
              Text( "Sign up to get started", style: AppTextStyles.bodyText2),
              const SizedBox(height: 30),

              Card(
                color: const Color.fromARGB(255, 225, 230, 235),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch button
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            prefixIcon: const Icon(Icons.person, color: Color(0xFF5A7BB5)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF0F2A50)),
                            ),
                          ),
                          onSaved: (value) => _username = value?.trim() ?? '',
                           validator: (value) => value == null || value.trim().isEmpty ? 'Username required' : null,
                               enabled: !_isLoading,
                            ),
                            const SizedBox(height: 16),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email, color: Color(0xFF5A7BB5)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF0F2A50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (value) => _email  = value?.trim() ?? '',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Email required';
                                   if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value.trim())) return 'Enter a valid email';
                                   return null;
                                },
                                enabled: !_isLoading,
                            ),
                            const SizedBox(height: 16),
                            // Password
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Password', prefixIcon: const Icon(Icons.lock ,color: Color(0xFF5A7BB5),),
                                suffixIcon: IconButton(
                                   icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off , color: Color(0xFF5A7BB5),),
                                   onPressed: _togglePasswordVisibility, ),
                              ),
                              obscureText: _obscurePassword,
                              onSaved: (value) => _password = value ?? '',
                              validator: (value) { /* ... password validation ... */
                                  if (value == null || value.isEmpty) return 'Password required';
                                  if (value.length < 6) return 'Password must be at least 6 characters';
                                  return null;
                               },
                                enabled: !_isLoading,
                               // Update confirm password validation when this changes
                               onChanged: (value) => _password = value,
                            ),
                            const SizedBox(height: 16),
                            // Confirm Password
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Confirm Password', prefixIcon: const Icon(Icons.lock, color: Color(0xFF5A7BB5),),
                                 suffixIcon: IconButton(
                                     icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off , color: Color(0xFF5A7BB5),),
                                     onPressed: _toggleConfirmPasswordVisibility, ),
                              ),
                              obscureText: _obscureConfirmPassword,
                              onSaved: (value) => _confirmPassword = value ?? '',
                              validator: (value) { /* ... confirm password validation ... */
                                  if (value == null || value.isEmpty) return 'Please confirm your password';
                                  if (value != _password) return 'Passwords do not match';
                                  return null;
                                },
                                enabled: !_isLoading,
                            ),
                            const SizedBox(height: 16),

                        DropdownButtonFormField(
                          decoration: InputDecoration(
                            //labelText: 'Role',
                            prefixIcon: const Icon(Icons.group, color: Color(0xFF5A7BB5)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF0F2A50)),
                            ),
                          ),
                          value: _selectedRole,
                          items: roles.map((role) {
                            return DropdownMenuItem(
                              value: role,
                              
                              child: Text(role[0].toUpperCase() + role.substring(1),style: AppTextStyles.bodyText1, selectionColor: Color(0xFFE1E6EB)),
                            );
                          }).toList(),
                          onChanged: _isLoading ? null : (value) => setState(() => _selectedRole = value.toString()),
                        ),
                        const SizedBox(height: 24),

                        _isLoading
                           ? const Center(child: LoadingIndicator())
                                : CustomButton( // Use CustomButton
                                    onPressed: _submit,
                                    text: 'Sign Up',
                                  ),
                        const SizedBox(height:20),

                       
                      ],
                    ),
                  ),
                ),
              ),
             TextButton(
                          onPressed:_isLoading ? null :() => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(color: Color(0xFF0F2A50)),
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