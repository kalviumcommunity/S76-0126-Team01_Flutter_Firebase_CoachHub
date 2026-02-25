import 'package:flutter/material.dart';

class AssignmentDetailPage extends StatefulWidget {
  const AssignmentDetailPage({super.key});

  @override
  State<AssignmentDetailPage> createState() => _AssignmentDetailPageState();
}

class _AssignmentDetailPageState extends State<AssignmentDetailPage> {
  final int _currentIndex = 1; // 1 = Tasks tab

  // Design Colors
  final Color _primaryBlue = const Color(0xFF4354B4);
  final Color _textDark = const Color(0xFF1A1A1A);
  final Color _textLight = const Color(0xFF8A8D9F);
  final Color _bgColor = const Color(0xFFF8F9FB);
  final Color _dangerColor = const Color(0xFFEA4335);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // Prevents color change on scroll
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Assignment Detail",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTags(),
                    const SizedBox(height: 20),
                    Text(
                      "Calculus Problem Set #4",
                      style: TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Complete problems 1-15 on page 42. Please show all your work for partial credit. Ensure your scan is clear and legible.",
                      style: TextStyle(
                        color: _textDark.withValues(alpha: 0.8),
                        height: 1.5,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Attach Work",
                      style: TextStyle(
                        color: _textDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildUploadBox(),
                    const SizedBox(height: 32),
                    _buildPrivateComments(),
                  ],
                ),
              ),
            ),
            // Fixed Turn In Button
            _buildTurnInButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Row(
      children: [
        // Due Date Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFCECEB),
            borderRadius: BorderRadius.circular(20), // Pill shape
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: 14, color: _dangerColor),
              const SizedBox(width: 4),
              Text(
                "DUE: TOMORROW",
                style: TextStyle(
                  color: _dangerColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Subject Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8EBFA),
            borderRadius: BorderRadius.circular(20), // Pill shape
          ),
          child: Text(
            "CALCULUS",
            style: TextStyle(
              color: _primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _primaryBlue.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Icon(Icons.add, color: _primaryBlue, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            "Add File",
            style: TextStyle(
              color: _primaryBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "PDF, JPG or PNG up to 10MB",
            style: TextStyle(color: _textLight, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivateComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: _textDark, size: 20),
                const SizedBox(width: 8),
                Text(
                  "Private Comments",
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            Text(
              "Visible only to teacher",
              style: TextStyle(color: _textLight, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Add a comment for your teacher...",
              hintStyle: TextStyle(color: _textLight, fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTurnInButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: const BoxDecoration(color: Colors.white),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Turn In",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.send_outlined, size: 20),
          ],
        ),
      ),
    );
  }
}
