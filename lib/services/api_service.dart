import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:5000/api/auth"; // Change 'localhost' to your machine's IP if using an emulator

  final storage = const FlutterSecureStorage();

  // Sign Up Function
  Future<Map<String, dynamic>> signUp(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(response.body);
  }

  // Login Function
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await storage.write(key: "token", value: responseData['token']);
    }

    return responseData;
  }

  // Get Token (for future API requests)
  Future<String?> getToken() async {
    return await storage.read(key: "token");
  }
}
