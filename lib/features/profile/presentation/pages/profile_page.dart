import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/profile/presentation/pages/settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view profile.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Profile',
            style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data?.data();
          final String name = (userData?['name'] as String?)?.trim().isNotEmpty == true
              ? userData!['name'] as String
              : 'User';
          final String role = (userData?['role'] as String?)?.trim().isNotEmpty == true
              ? userData!['role'] as String
              : 'Member';
          final String email = (userData?['email'] as String?)?.trim().isNotEmpty == true
              ? userData!['email'] as String
              : (user.email ?? 'No Email');
          final String photoUrl = ((userData?['photoUrl'] as String?) ?? '').trim();
          final int photoVersion = userData?['photoVersion'] as int? ?? 0;
          final String photoUrlWithVersion = photoUrl.isNotEmpty
              ? '$photoUrl${photoUrl.contains('?') ? '&' : '?'}v=$photoVersion'
              : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildProfileHeader(name, role, photoUrlWithVersion),
                const SizedBox(height: 32),
                _buildSectionLabel('PERSONAL INFORMATION'),
                _buildInfoCard([
                  _buildProfileTile(Icons.person_outline, 'Full Name', name),
                  _buildDivider(),
                  _buildProfileTile(Icons.email_outlined, 'Email', email),
                  _buildDivider(),
                  _buildProfileTile(Icons.verified_user_outlined, 'Role', role, isLocked: true),
                ]),
                const SizedBox(height: 32),
                _buildSectionLabel('STATISTICS'),
                _buildStatsGrid(role, user.uid),
                const SizedBox(height: 40),
                _buildPrimaryButton(
                  'Edit In Settings',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(String name, String role, String photoUrl) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFE8EAF6),
            backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
            child: photoUrl.isEmpty
                ? const Icon(Icons.person, size: 50, color: Color(0xFF4B56D2))
                : null,
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(color: Color(0xFF4B56D2), fontWeight: FontWeight.w600, letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String value, {bool isLocked = false}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4B56D2), size: 22),
      title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      trailing: isLocked
          ? const Icon(Icons.lock_outline, size: 16, color: Colors.grey)
          : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }

  Widget _buildStatsGrid(String role, String uid) {
    final classStream = role == 'Teacher'
        ? FirebaseFirestore.instance.collection('classes').where('teacherId', isEqualTo: uid).snapshots()
        : FirebaseFirestore.instance.collection('classes').snapshots();

    return Row(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: classStream,
            builder: (context, snapshot) {
              final count = snapshot.data?.docs.length ?? 0;
              return _buildStatItem(role == 'Teacher' ? 'Classes' : 'Courses', '$count');
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? const [];
              final unread = docs.where((doc) {
                final data = doc.data();
                final readBy = (data['readBy'] as List<dynamic>?) ?? const [];
                final targetRole = data['targetRole'] as String?;
                final targetUserId = data['targetUserId'] as String?;
                final visibleByRole = targetRole == null || targetRole == role || targetRole == 'All';
                final visibleByUser = targetUserId == null || targetUserId == uid;
                return visibleByRole && visibleByUser && !readBy.contains(uid);
              }).length;
              return _buildStatItem('Unread Alerts', '$unread');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4B56D2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(String label, VoidCallback? onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B56D2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 60, endIndent: 20, color: Color(0xFFF5F5F5));
}
