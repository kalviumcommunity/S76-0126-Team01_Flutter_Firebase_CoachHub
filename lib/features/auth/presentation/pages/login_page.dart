import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String selectedRole = 'Teacher';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8EAF6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school, color: Color(0xFF4B56D2), size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text("COACHUB", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF4B56D2), letterSpacing: 1.5)),
                  const Text("Empowering the next generation", style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            const Text("Welcome Back", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Please enter your details to login", style: TextStyle(color: Colors.grey, fontSize: 15)),

            const SizedBox(height: 40),
            _buildInputField("Email Address", "name@school.edu", icon: Icons.email_outlined),
            _buildInputField("Password", "••••••••", icon: Icons.lock_outline, isPassword: true, showForgot: true),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Dashboard on Login
                  Navigator.pushReplacementNamed(context, '/dashboard');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B56D2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: const Color(0xFF4B56D2).withValues(alpha: 0.4),
                ),
                child: const Text("Login to Account", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 40),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("SELECT YOUR ROLE", style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildRoleMiniCard('Teacher', 'Manage Class', Icons.record_voice_over_outlined)),
                const SizedBox(width: 16),
                Expanded(child: _buildRoleMiniCard('Student', 'Start Learning', Icons.menu_book_outlined)),
              ],
            ),

            const SizedBox(height: 40),
            // --- FIXED NAVIGATION SECTION ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ", style: TextStyle(color: Colors.black54)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: const Text("Sign Up", style: TextStyle(color: Color(0xFF4B56D2), fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleMiniCard(String role, String subtitle, IconData icon) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF4B56D2) : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? const Color(0xFFE8EAF6) : const Color(0xFFF5F5F5),
              child: Icon(icon, color: isSelected ? const Color(0xFF4B56D2) : Colors.grey, size: 20),
            ),
            const SizedBox(height: 12),
            Text(role, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {required IconData icon, bool isPassword = false, bool showForgot = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              if (showForgot)
                Text("Forgot?", style: TextStyle(color: Colors.blue[800], fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: Colors.grey, size: 20),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: isPassword ? const Icon(Icons.visibility_outlined, color: Colors.grey, size: 20) : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ],
      ),
    );
  }
}
