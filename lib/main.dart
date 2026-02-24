import 'package:flutter/material.dart';

import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/login_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/onboarding_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/home/presentation/pages/student_home_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/your_assignments_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/assignment_detail_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/student_courses_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/notifications_page.dart'; 

// Import the new Main Screen
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/home/presentation/pages/student_main_screen.dart';

void main() {
  runApp(const CoachubApp());
}

class CoachubApp extends StatelessWidget {
  const CoachubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coachub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4B56D2),
        useMaterial3: true,
        fontFamily: 'Inter', 
      ),
      
      // Launch the wrapper screen first!
      initialRoute: '/student_main', 
      
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        
        // This is the new route for the nav bar controller
        '/student_main': (context) => const StudentMainScreen(),
        
        // You still keep these so you can navigate to them normally if needed
        '/student_home': (context) => const StudentHomePage(),
        '/tasks': (context) => const StudentTasksPage(), 
        '/assignment_detail': (context) => const AssignmentDetailPage(),
        '/courses': (context) => const StudentCoursesPage(),
        '/notifications': (context) => const NotificationsPage(),
      },
    );
  }
}