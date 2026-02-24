import 'package:flutter/material.dart';

class StudentCoursesPage extends StatefulWidget {
  const StudentCoursesPage({super.key});

  @override
  State<StudentCoursesPage> createState() => _StudentCoursesPageState();
}

class _StudentCoursesPageState extends State<StudentCoursesPage> {
  final int _currentIndex = 2; // 2 = Courses tab
  int _selectedTabIndex = 0; // 0: Ongoing, 1: Completed, 2: Wishlist

  // Design Colors
  final Color _primaryBlue = const Color(0xFF4354B4);
  final Color _textDark = const Color(0xFF1A1A1A);
  final Color _textLight = const Color(0xFF8A8D9F);
  final Color _bgColor = const Color(0xFFF8F9FB);
  final Color _liveRed = const Color(0xFFEA4335);

  // Mock Data for the Grid
  final List<Map<String, dynamic>> _courses = [
    {
      "title": "Algebra Foundations",
      "instructor": "Dr. Sarah Smith",
      "progress": 0.75,
      "isLive": true,
      "imageColor": const Color(0xFF2C3E50),
      "icon": Icons.calculate,
    },
    {
      "title": "World History",
      "instructor": "Prof. James Wilson",
      "progress": 0.30,
      "isLive": false,
      "imageColor": const Color(0xFF3A6B7E),
      "icon": Icons.public,
    },
    {
      "title": "Advanced Biology",
      "instructor": "Dr. Elena Ross",
      "progress": 0.90,
      "isLive": false,
      "imageColor": const Color(0xFFE8F5E9),
      "icon": Icons.biotech,
      "iconColor": const Color(0xFF2E7D32),
    },
    {
      "title": "Quantum Physics",
      "instructor": "Prof. Alan Turing",
      "progress": 0.10,
      "isLive": true,
      "imageColor": const Color(0xFF0D1B2A),
      "icon": Icons.science,
    },
    {
      "title": "Organic Chemistry",
      "instructor": "Dr. Marie Curie",
      "progress": 0.55,
      "isLive": false,
      "imageColor": const Color(0xFF2E4F4F),
      "icon": Icons.science_outlined,
    },
    {
      "title": "Modern Literature",
      "instructor": "Prof. Maya Angelou",
      "progress": 0.20,
      "isLive": false,
      "imageColor": const Color(0xFF5C4033),
      "icon": Icons.menu_book,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: _buildHeader(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: _buildTabs(),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68, // Adjusts height of the cards
                ),
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return _buildCourseCard(course);
                },
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
          "My Courses",
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE8E8E8)),
          ),
          child: IconButton(
            icon: Icon(Icons.search, color: _primaryBlue),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTabButton(title: "Ongoing", index: 0),
        const SizedBox(width: 8),
        _buildTabButton(title: "Completed", index: 1),
        const SizedBox(width: 8),
        _buildTabButton(title: "Wishlist", index: 2),
      ],
    );
  }

  Widget _buildTabButton({required String title, required int index}) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _primaryBlue : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected ? _primaryBlue : const Color(0xFFE8E8E8),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: _primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : _textLight,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Image Area
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: course['imageColor'],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Icon(
                    course['icon'],
                    size: 48,
                    color: course.containsKey('iconColor')
                        ? course['iconColor']
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
                if (course['isLive'])
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _liveRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "LIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Bottom Text Area
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'],
                        style: TextStyle(
                          color: _textDark,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['instructor'],
                        style: TextStyle(color: _textLight, fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${(course['progress'] * 100).toInt()}% Complete",
                        style: TextStyle(
                          color: _primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F1F5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: course['progress'],
                          child: Container(
                            decoration: BoxDecoration(
                              color: _primaryBlue,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
