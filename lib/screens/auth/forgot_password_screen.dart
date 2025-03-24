import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

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

  setState(() {
    _isLoading = true;
  });

  // Update the URL accordingly (use your backend IP/URL)
  final url = Uri.parse('http://10.0.2.2:5000/api/auth/forgot-password');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": _email}),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? "Reset code sent to email")),
      );
      // Navigate to the Reset Password screen for testing purposes.
      Navigator.pushReplacementNamed(context, '/reset-password', arguments: _email);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'] ?? "Failed to send email")),
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
      appBar: AppBar(title: const Text("Forgot Password")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Enter your email address to receive password reset instructions.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value?.trim() ?? '',
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
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text("Send Reset Email"),
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
