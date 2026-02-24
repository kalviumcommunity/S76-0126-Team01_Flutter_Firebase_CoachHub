import 'package:flutter/material.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/login_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/onboarding_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/home/presentation/pages/home_page.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4B56D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      initialRoute: '/dashboard', // TODO: revert to '/' before release
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/dashboard': (context) => const TeacherDashboardPage(),
      },
    );
  }
}
