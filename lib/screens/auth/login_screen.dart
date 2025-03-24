import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true;
  bool _isLoading = false; // Add loading state

  final _storage = const FlutterSecureStorage();

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Send login request to backend
  // Future<void> _submit() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   _formKey.currentState!.save();
  //   setState(() => _isLoading = true);

  //   final url = Uri.parse(
  //     'http://10.0.2.2:5000/api/auth/login',
  //   ); // Change 'localhost' to your IP if using an emulator

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

  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text("Login successful!")));

  //       // Navigate to home screen
  //       Navigator.pushReplacementNamed(context, '/home');
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(responseData['message'] ?? "Login failed")),
  //       );
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("An error occurred: $error")));
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }
Future<void> _submit() async {
  if (!_formKey.currentState!.validate()) return;

  _formKey.currentState!.save();
  setState(() => _isLoading = true);

  final url = Uri.parse(
    'http://10.0.2.2:5000/api/auth/login',
  ); // Use your backend's URL/IP

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": _email, "password": _password}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Store JWT token securely
      await _storage.write(key: "token", value: responseData['token']);

      // Get the role from the response. Assuming your API returns:
      // { token: '...', user: { id: '...', username: '...', email: '...', role: 'teacher' } }
      final String role = responseData['user']['role'];

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login successful!")));

      // Role-based navigation:
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else if (role == 'teacher') {
        Navigator.pushReplacementNamed(context, '/teacher-dashboard');
      } else if (role == 'student') {
        Navigator.pushReplacementNamed(context, '/student-dashboard');
      } else {
        // Fallback to a generic home screen if needed.
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? "Login failed")),
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
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
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
              ),
              const SizedBox(height: 16),
              // Password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
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
              ),
              const SizedBox(height: 24),
              // Login button
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
              // Forgot password link
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: const Text("Forgot your password?"),
              ),
              // Sign-up navigation
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
