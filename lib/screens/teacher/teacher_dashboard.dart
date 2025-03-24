import 'package:flutter/material.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teacher Dashboard")),
      body: const Center(
        child: Text(
          "Welcome, Teacher!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
