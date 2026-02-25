import 'package:flutter/material.dart';

class StudentTasksPage extends StatefulWidget {
  const StudentTasksPage({super.key});

  @override
  State<StudentTasksPage> createState() => _StudentTasksPageState();
}

class _StudentTasksPageState extends State<StudentTasksPage> {
  bool _isPendingSelected = true;

  // Colors based on the UI design
  final Color _bgColor = const Color(0xFFF8F9FB);
  final Color _primaryBlue = const Color(0xFF4354B4);
  final Color _textDark = const Color(0xFF1A1A1A);
  final Color _textLight = const Color(0xFF8A8D9F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildHeader(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSearchBar(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildSegmentedControl(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  _buildTaskCard(
                    title: "Solve Calculu...",
                    subtitle: "Mathematics • Advanced Level",
                    iconData: Icons.calculate_outlined,
                    iconColor: _primaryBlue,
                    iconBgColor: const Color(0xFFE8EBFA),
                    tagText: "DUE IN 2 DAYS",
                    tagTextColor: const Color(0xFFD9661A),
                    tagBgColor: const Color(0xFFFDE8D7),
                    buttonText: "Submit",
                    isPrimaryButton: true,
                    progress: 0.5,
                    progressColor: _primaryBlue,
                  ),
                  const SizedBox(height: 16),
                  _buildTaskCard(
                    title: "Biology Lab R...",
                    subtitle: "Science • Cellular Biology",
                    iconData: Icons.science_outlined,
                    iconColor: const Color(0xFF34A853),
                    iconBgColor: const Color(0xFFE9F5EC),
                    tagText: "DUE IN 5 DAYS",
                    tagTextColor: _textLight,
                    tagBgColor: const Color(0xFFF0F1F5),
                    buttonText: "Submit",
                    isPrimaryButton: true,
                    progress: 0.2,
                    progressColor: _primaryBlue,
                  ),
                  const SizedBox(height: 16),
                  _buildTaskCard(
                    title: "History Essay...",
                    subtitle: "Humanities • World War II",
                    iconData: Icons.history_edu,
                    iconColor: _textLight,
                    iconBgColor: const Color(0xFFF0F1F5),
                    tagText: "SUBMITTED",
                    tagTextColor: const Color(0xFF34A853),
                    tagBgColor: const Color(0xFFE9F5EC),
                    tagIcon: Icons.check_circle,
                    buttonText: "View Feedback",
                    isPrimaryButton: false,
                    progress: 1.0,
                    progressColor: const Color(0xFF34A853),
                  ),
                  const SizedBox(height: 16),
                  _buildTaskCard(
                    title: "Python Logic...",
                    subtitle: "CS • Programming 101",
                    iconData: Icons.code,
                    iconColor: const Color(0xFFD9661A),
                    iconBgColor: const Color(0xFFFDF0E7),
                    tagText: "DUE TOMORROW",
                    tagTextColor: const Color(0xFFEA4335),
                    tagBgColor: const Color(0xFFFCECEB),
                    buttonText: "Submit",
                    isPrimaryButton: true,
                    progress: 0.8,
                    progressColor: _primaryBlue,
                  ),
                  const SizedBox(height: 20), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Your Assignments",
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
            color: Colors.white,
          ),
          child: IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 24),
            color: _textDark,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search assignments...",
          hintStyle: TextStyle(color: _textLight, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: _textLight),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F5),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isPendingSelected = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isPendingSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: _isPendingSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: _isPendingSelected ? _primaryBlue : _textLight,
                      fontWeight: _isPendingSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isPendingSelected = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isPendingSelected
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: !_isPendingSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      color: !_isPendingSelected ? _primaryBlue : _textLight,
                      fontWeight: !_isPendingSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    required IconData iconData,
    required Color iconColor,
    required Color iconBgColor,
    required String tagText,
    required Color tagTextColor,
    required Color tagBgColor,
    IconData? tagIcon,
    required String buttonText,
    required bool isPrimaryButton,
    required double progress,
    required Color progressColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(iconData, color: iconColor, size: 24),
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
                                title,
                                style: TextStyle(
                                  color: _textDark,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tagBgColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (tagIcon != null) ...[
                                      Icon(
                                        tagIcon,
                                        size: 12,
                                        color: tagTextColor,
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                    Text(
                                      tagText,
                                      style: TextStyle(
                                        color: tagTextColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 9,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(color: _textLight, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pill-shaped button (80% width) + circular more options button
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPrimaryButton
                              ? _primaryBlue
                              : const Color(0xFFE8EBFA),
                          foregroundColor: isPrimaryButton
                              ? Colors.white
                              : _primaryBlue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE8E8E8)),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.more_horiz, size: 20),
                          color: _textLight,
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Bottom Progress Bar - FLUSH at bottom edge
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F5),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: progressColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
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
