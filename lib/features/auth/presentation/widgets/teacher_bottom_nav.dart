import 'package:flutter/material.dart';

class TeacherBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const TeacherBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF4E65FF),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          label: 'Classes',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
