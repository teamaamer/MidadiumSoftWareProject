import 'package:flutter/material.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({Key? key}) : super(key: key);

  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const DashboardHomePage(),
    const CoursesPage(),
    const InteractiveContentPage(),
    const ChatPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        backgroundColor: Colors.teal,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Courses",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories),
            label: "Interactive",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// Example of a Home Page in Student Dashboard
class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Overview",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Example: Progress card
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Text(
                    "Course Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  LinearProgressIndicator(value: 0.7),
                  SizedBox(height: 4),
                  Text("70% completed"),
                ],
              ),
            ),
          ),
          // Add additional overview widgets...
        ],
      ),
    );
  }
}

// Example of Courses Page
class CoursesPage extends StatelessWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This page should display the list of enrolled courses.
    return Center(
      child: Text("Courses List", style: Theme.of(context).textTheme.headline5),
    );
  }
}

extension on TextTheme {
  get headline5 => null;
}

// Example of Interactive Content Page
class InteractiveContentPage extends StatelessWidget {
  const InteractiveContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This page will list interactive content options (flashcards, game, etc.)
    return Center(
      child: Text("Interactive Content", style: Theme.of(context).textTheme.headline5),
    );
  }
}

// Example of Chat Page
class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This page will implement chat functionality.
    return Center(
      child: Text("Chat with Teachers", style: Theme.of(context).textTheme.headline5),
    );
  }
}

// Example of Profile Page
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This page will show the student's profile and progress.
    return Center(
      child: Text("Student Profile", style: Theme.of(context).textTheme.headline5),
    );
  }
}
