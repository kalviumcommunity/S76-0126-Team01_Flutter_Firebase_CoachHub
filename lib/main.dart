import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'firebase_options.dart';

// Import all your pages
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/login_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/signup_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B56D2)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      // AuthCheck automatically redirects users based on their login status
      home: const AuthCheck(), 
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/onboarding': (context) => const OnboardingPage(),
        '/teacher_home': (context) => const _TeacherHomePlaceholderPage(),
        '/student_home': (context) => const _StudentHomePlaceholderPage(),
      },
    );
  }
}

/// This widget decides whether to show the Login screen or the Dashboard
/// based on whether a user is currently signed into Firebase.
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const OnboardingPage();
          } else {
            // Returns LoginPage which handles the role-fetching logic
            return const LoginPage(); 
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

// Placeholder pages for testing navigation
class _TeacherHomePlaceholderPage extends StatelessWidget {
  const _TeacherHomePlaceholderPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teacher Dashboard')),
      body: const Center(child: Text('Welcome, Teacher!')),
    );
  }
}

class _StudentHomePlaceholderPage extends StatelessWidget {
  const _StudentHomePlaceholderPage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: const Center(child: Text('Welcome, Student!')),
    );
  }
}