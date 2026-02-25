import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

// Import all your pages
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/login_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/signup_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/presentation/pages/onboarding_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/home/presentation/pages/home_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/home/presentation/pages/student_main_screen.dart';

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
        '/teacher_home': (context) => const TeacherDashboardPage(),
        '/student_home': (context) => const StudentMainScreen(),
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
        if (snapshot.connectionState != ConnectionState.active) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const OnboardingPage();
        }

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!roleSnapshot.hasData || !roleSnapshot.data!.exists) {
              return const LoginPage();
            }

            final role = (roleSnapshot.data!.data()?['role'] as String?) ?? '';
            if (role == 'Teacher') {
              return const TeacherDashboardPage();
            }
            if (role == 'Student') {
              return const StudentMainScreen();
            }
            return const LoginPage();
          },
        );
      },
    );
  }
}
