import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _currentIndex = 0;

  // Colors based on the UI design
  final Color _bgColor = const Color(0xFFF8F9FB);
  final Color _primaryBlue = const Color(0xFF4354B4);
  final Color _textDark = const Color(0xFF1A1A1A);
  final Color _textLight = const Color(0xFF8A8D9F);
  final Color _orange = const Color(0xFFE88B2E);
  final Color _successBlue = const Color(0xFF4A80F0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildWeeklyGoalCard(),
              const SizedBox(height: 28),
              _buildUpcomingClassesHeader(),
              const SizedBox(height: 16),
              _buildUpcomingClassCard(),
              const SizedBox(height: 28),
              _buildActiveAssignmentsHeader(),
              const SizedBox(height: 16),
              _buildAssignmentCard(
                title: "Algebra Homework",
                dueDate: "Due: tomorrow, 10:00 AM",
                status: "IN PROGRESS",
                statusColor: _successBlue,
                statusBgColor: const Color(0xFFDCE8FF),
                progress: 0.6,
                indicatorColor: _successBlue,
              ),
              const SizedBox(height: 12),
              _buildAssignmentCard(
                title: "History Essay",
                dueDate: "Due: Oct 25, 2023",
                status: "PENDING",
                statusColor: const Color(0xFFD9661A),
                statusBgColor: const Color(0xFFFDE8D7),
                progress: 0.0,
                indicatorColor: _orange,
                isPending: true,
              ),
              const SizedBox(height: 12),
              _buildAssignmentCard(
                title: "Chemistry Lab Report",
                dueDate: "Due: Friday, 5:00 PM",
                status: "IN PROGRESS",
                statusColor: _successBlue,
                statusBgColor: const Color(0xFFDCE8FF),
                progress: 0.3,
                indicatorColor: _successBlue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MY LEARNING",
              style: TextStyle(
                color: _primaryBlue,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Hi, Student!",
              style: TextStyle(
                color: _textDark,
                fontWeight: FontWeight.w800,
                fontSize: 24,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_outlined, size: 28),
                  color: _textDark,
                  onPressed: () {},
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                      border: Border.all(color: _bgColor, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE8E8E8), width: 2),
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFFFDE8D7),
                child: Icon(Icons.person, color: Color(0xFF4A5568)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5162C3), Color(0xFF3F4BAA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Weekly Goal",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "You're doing great! Keep it up.",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        "Continue Lesson",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.78,
                  strokeWidth: 8,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const Text(
                "78%",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClassesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Upcoming Classes",
          style: TextStyle(
            color: _textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "View All",
            style: TextStyle(color: _primaryBlue, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingClassCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF1FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.videocam, color: _primaryBlue, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Advanced Physics",
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Today, 14:00 - 15:00",
                  style: TextStyle(color: _textLight, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF1FA),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_outward, color: _primaryBlue, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveAssignmentsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Active Assignments",
          style: TextStyle(
            color: _textDark,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "3 Tasks",
            style: TextStyle(
              color: _textDark,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String dueDate,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required double progress,
    required Color indicatorColor,
    bool isPending = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Left color border strip - flush with edge
                Container(
                  width: 4,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isPending ? _orange : indicatorColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dueDate,
                        style: TextStyle(color: _textLight, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Progress bar sits completely FLUSH at bottom edge
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: isPending ? 0 : progress,
              child: Container(
                decoration: BoxDecoration(
                  color: indicatorColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
