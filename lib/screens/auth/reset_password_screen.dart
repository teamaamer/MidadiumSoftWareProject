import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String? resetToken;
  final String? email; // Received from the Forgot Password screen

  const ResetPasswordScreen({Key? key, this.resetToken, this.email}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  // We'll use the email passed in and not ask the user to re-enter it.
  late String _email;
  String _resetCode = '';
  String _password = '';
  String _confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set _email from widget.email; if not provided, you might show an error or ask the user.
    _email = widget.email ?? '';
    // If a reset token is provided via deep linking, pre-fill the reset code.
    if (widget.resetToken != null) {
      _resetCode = widget.resetToken!;
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
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

    setState(() {
      _isLoading = true;
    });

    // Update URL accordingly (adjust host/IP as needed)
    final url = Uri.parse('http://10.0.2.2:5000/api/auth/reset-password');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": _email,
          "resetCode": _resetCode,
          "password": _password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Password reset successful")),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? "Password reset failed")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: $error")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Enter the reset code from your email and your new password.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Display email (optional, read-only)
              Text(
                "Reset for: $_email",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Reset Code field
              TextFormField(
                initialValue: widget.resetToken, // Pre-fill if provided
                decoration: const InputDecoration(
                  labelText: "Reset Code",
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _resetCode = value?.trim() ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the reset code";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // New Password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscurePassword,
                onSaved: (value) => _password = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your new password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Confirm New Password field
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                onSaved: (value) => _confirmPassword = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your new password";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Reset Password"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
