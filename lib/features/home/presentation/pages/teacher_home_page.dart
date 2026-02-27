import 'package:flutter/material.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/classroom/presentation/pages/notifications_page.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/profile/presentation/pages/settings_page.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildStatsRow(),
              const SizedBox(height: 28),
              _buildSectionTitle('Upcoming Classes'),
              const SizedBox(height: 12),
              _buildClassCard(
                'Mathematics – Grade 10',
                'Today, 10:00 AM',
                Icons.calculate_outlined,
                const Color(0xFF4B56D2),
              ),
              _buildClassCard(
                'Physics – Grade 11',
                'Today, 12:30 PM',
                Icons.science_outlined,
                const Color(0xFF26C6DA),
              ),
              _buildClassCard(
                'Chemistry – Grade 9',
                'Tomorrow, 9:00 AM',
                Icons.biotech_outlined,
                const Color(0xFF66BB6A),
              ),
              const SizedBox(height: 28),
              _buildSectionTitle('Recent Assignments'),
              const SizedBox(height: 12),
              _buildAssignmentTile('Algebra Homework', 'Due: 24 Feb', 18, 24),
              _buildAssignmentTile(
                'Newton\'s Laws Quiz',
                'Due: 25 Feb',
                10,
                20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning! 👋',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            const Text(
              'Teacher Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, size: 28),
              color: const Color(0xFF1A1A2E),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
            ),
            const SizedBox(width: 6),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 28),
              color: const Color(0xFF1A1A2E),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard(
          'Classes',
          '6',
          Icons.class_outlined,
          const Color(0xFF4B56D2),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Students',
          '124',
          Icons.people_outline,
          const Color(0xFF26C6DA),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          'Tasks',
          '8',
          Icons.assignment_outlined,
          const Color(0xFFFF7043),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildClassCard(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildAssignmentTile(
    String title,
    String due,
    int submitted,
    int total,
  ) {
    final double progress = submitted / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$submitted/$total',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4B56D2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(due, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE8EAF6),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF4B56D2),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
