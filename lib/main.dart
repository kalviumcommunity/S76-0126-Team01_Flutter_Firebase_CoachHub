import 'package:flutter/material.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/login_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/onboarding_page.dart';

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
        fontFamily: 'Inter', // If you have added Inter to pubspec.yaml
      ),
      // Define the starting page
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/dashboard': (context) => const LoginPage(),
      },
    );
  }
}
