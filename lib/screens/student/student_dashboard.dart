import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: const Center(
        child: Text(
          "Welcome, Student!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
