import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _selectedFilterIndex = 0; // 0: All, 1: Assignments, 2: Grades, etc.

  // Design Colors
  final Color _primaryBlue = const Color(0xFF4354B4);
  final Color _textDark = const Color(0xFF1A1A1A);
  final Color _textLight = const Color(0xFF8A8D9F);
  final Color _bgColor = Colors.white; // Background seems to be pure white here
  final Color _dangerRed = const Color(0xFFEA4335);

  final List<String> _filters = [
    "All",
    "Assignments",
    "Grades",
    "Announcements",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () {
            // Navigator.pop(context); // Un-comment when routing is ready
          },
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Mark all as read",
              style: TextStyle(
                color: _primaryBlue,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCriticalAlert(),
                const SizedBox(height: 20),
                _buildFilterTabs(),
                const SizedBox(height: 24),
                _buildNotificationItem(
                  icon: Icons.description_outlined,
                  iconColor: _primaryBlue,
                  iconBgColor: const Color(0xFFE8EBFA),
                  title: "New Assignment: Advanced Calculus",
                  description:
                      "Module 5: Integration Methods has been published.",
                  time: "2h ago",
                  isUnread: true,
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  icon: Icons.star_border,
                  iconColor: const Color(0xFFD9661A), // Orange
                  iconBgColor: const Color(0xFFFDF0E7),
                  title: "Grade Posted: Physics Midterm",
                  description:
                      "Your results for the Physics 101 midterm are now available.",
                  time: "4h ago",
                  isUnread: true,
                ),
                const SizedBox(height: 16),
                _buildNotificationItem(
                  icon: Icons.campaign_outlined,
                  iconColor: const Color(0xFF34A853), // Green
                  iconBgColor: const Color(0xFFE9F5EC),
                  title: "Campus Update: Library Hours",
                  description:
                      "Main library will be open 24/7 during finals week starting Monday.",
                  time: "Yesterday",
                  isUnread: false,
                ),
                const SizedBox(height: 32),
                _buildBottomIllustration(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCriticalAlert() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // Light red background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFECACA),
          width: 1,
        ), // Soft red border
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _dangerRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "CRITICAL ALERT",
                      style: TextStyle(
                        color: _dangerRed,
                        fontWeight: FontWeight.w800,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "1h left",
                      style: TextStyle(
                        color: _dangerRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  "Assignment due in 1 hour!",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Immediate action required for Advanced Calculus: Module 4 Problem Set.",
                  style: TextStyle(
                    color: _textDark.withValues(alpha: 0.7),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          bool isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilterIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? _primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? _primaryBlue : const Color(0xFFE8E8E8),
                  ),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : _textLight,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F1F5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: _textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                    ),
                    if (isUnread) ...[
                      const SizedBox(width: 8),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _primaryBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: _textLight,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  time,
                  style: TextStyle(
                    color: _textLight.withValues(alpha: 0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIllustration() {
    return Column(
      children: [
        // Placeholder for the graphic (Laptop guy illustration)
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF5F6F9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(
              Icons.laptop_mac,
              size: 48,
              color: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Stay updated with your academic journey.\nCoachub is here to help you succeed.",
          textAlign: TextAlign.center,
          style: TextStyle(color: _textLight, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }
}
