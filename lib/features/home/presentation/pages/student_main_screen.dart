import 'package:flutter/material.dart';

// Import the pages we built
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/home/presentation/pages/student_home_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/your_assignments_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/student_courses_page.dart';

class StudentMainScreen extends StatefulWidget {
  const StudentMainScreen({super.key});

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _currentIndex = 0;

  // This list holds all the screens for the bottom nav
  final List<Widget> _pages = [
    const StudentHomePage(),     // Index 0: Home
    const StudentTasksPage(),    // Index 1: Tasks
    const StudentCoursesPage(),  // Index 2: Courses
    const Center(
      child: Text(
        'Profile Page Coming Soon',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ), // Index 3: Profile (Placeholder until we build it)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body changes based on which tab is selected
      body: _pages[_currentIndex],
      
      // The single, persistent bottom navigation bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index; // Changes the active tab
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF4354B4), // _primaryBlue
          unselectedItemColor: const Color(0xFF8A8D9F), // _textLight
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
