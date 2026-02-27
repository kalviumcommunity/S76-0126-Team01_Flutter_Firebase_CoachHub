import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  int _selectedFilterIndex = 0; // 0: All, 1: Assignments, 2: System
  bool _isMarkingAll = false;

  final List<String> _filters = const ['All', 'Assignments', 'System'];

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view notifications.')),
      );
    }

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _db.collection('users').doc(user.uid).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F9FA),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = (userSnapshot.data?.data()?['role'] as String?) ?? 'Student';
        return _buildPage(user.uid, role);
      },
    );
  }

  Widget _buildPage(String uid, String role) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _isMarkingAll ? null : () => _markAllAsRead(uid, role),
            child: Text(
              _isMarkingAll ? 'Marking...' : 'Mark all as read',
              style: const TextStyle(color: Color(0xFF4B56D2), fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _db
            .collection('notifications')
            .orderBy('createdAt', descending: true)
            .limit(200)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Failed to load notifications.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];
          final notifications = docs
              .map((doc) => _NotificationItem.fromDoc(doc))
              .where((item) => item.isVisibleTo(uid: uid, role: role))
              .where((item) => _matchesFilter(item))
              .toList();

          final unreadCount = notifications.where((n) => !n.isReadBy(uid)).length;

          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildFilterChip('All', isSelected: _selectedFilterIndex == 0),
                    _buildFilterChip('Assignments', isSelected: _selectedFilterIndex == 1),
                    _buildFilterChip('System', isSelected: _selectedFilterIndex == 2),
                  ],
                ),
              ),
              if (unreadCount > 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '$unreadCount unread',
                      style: const TextStyle(
                        color: Color(0xFF4B56D2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: notifications.isEmpty
                    ? const Center(
                        child: Text(
                          'No notifications yet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: notifications.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          return _buildNotificationCard(uid: uid, item: item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _matchesFilter(_NotificationItem item) {
    if (_selectedFilterIndex == 0) return true;
    if (_selectedFilterIndex == 1) return item.category == 'Assignments';
    return item.category == 'System';
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = _filters.indexOf(label);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4B56D2) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required String uid,
    required _NotificationItem item,
  }) {
    final isUnread = !item.isReadBy(uid);
    final iconColor = item.category == 'Assignments' ? Colors.orange : const Color(0xFF4B56D2);
    final icon = item.category == 'Assignments' ? Icons.assignment_outlined : Icons.settings_outlined;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _markAsRead(uid: uid, notificationId: item.id),
      child: Container(
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.body} • ${_formatRelativeTime(item.createdAt)}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isUnread)
              const CircleAvatar(
                radius: 4,
                backgroundColor: Color(0xFF4B56D2),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAsRead({
    required String uid,
    required String notificationId,
  }) async {
    try {
      await _db.collection('notifications').doc(notificationId).update({
        'readBy': FieldValue.arrayUnion([uid]),
      });
    } catch (_) {}
  }

  Future<void> _markAllAsRead(String uid, String role) async {
    if (_isMarkingAll) return;
    setState(() => _isMarkingAll = true);
    try {
      final docs = await _db
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(200)
          .get();

      final batch = _db.batch();
      for (final doc in docs.docs) {
        final item = _NotificationItem.fromDoc(doc);
        if (!item.isVisibleTo(uid: uid, role: role) || item.isReadBy(uid) || !_matchesFilter(item)) {
          continue;
        }
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([uid]),
        });
      }
      await batch.commit();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark as read: $e')),
      );
    } finally {
      if (mounted) setState(() => _isMarkingAll = false);
    }
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return 'yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}

class _NotificationItem {
  final String id;
  final String title;
  final String body;
  final String category; // Assignments | System
  final DateTime createdAt;
  final List<dynamic> readBy;
  final String? targetRole;
  final String? targetUserId;

  const _NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.createdAt,
    required this.readBy,
    required this.targetRole,
    required this.targetUserId,
  });

  factory _NotificationItem.fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final timestamp = data['createdAt'];
    final createdAt =
        timestamp is Timestamp ? timestamp.toDate() : (timestamp is DateTime ? timestamp : DateTime.now());

    return _NotificationItem(
      id: doc.id,
      title: (data['title'] as String?)?.trim().isNotEmpty == true ? data['title'] as String : 'Notification',
      body: (data['body'] as String?)?.trim().isNotEmpty == true ? data['body'] as String : 'Update available',
      category: (data['category'] as String?) == 'Assignments' ? 'Assignments' : 'System',
      createdAt: createdAt,
      readBy: (data['readBy'] as List<dynamic>?) ?? const [],
      targetRole: data['targetRole'] as String?,
      targetUserId: data['targetUserId'] as String?,
    );
  }

  bool isReadBy(String uid) {
    return readBy.contains(uid);
  }

  bool isVisibleTo({required String uid, required String role}) {
    final matchesUser = targetUserId == null || targetUserId == uid;
    final matchesRole = targetRole == null || targetRole == role || targetRole == 'All';
    return matchesUser && matchesRole;
  }
}
