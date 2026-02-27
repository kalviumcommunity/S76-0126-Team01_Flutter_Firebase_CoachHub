import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/data/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  bool _isUpdating = false;
  bool _isUploadingPhoto = false;
  double _uploadProgress = 0;
  Uint8List? _localPreviewBytes;

  Future<void> _handleLogout() async {
    await AuthService().signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _updateUserFields(Map<String, dynamic> updates) async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isUpdating = true);
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _db.collection('users').doc(user.uid).set(updates, SetOptions(merge: true));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  Future<void> _showEditProfileDialog({
    required String currentName,
    required String currentEmail,
  }) async {
    final nameController = TextEditingController(text: currentName);
    final emailController = TextEditingController(text: currentEmail);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                if (name.isEmpty || email.isEmpty || !email.contains('@')) {
                  return;
                }
                Navigator.pop(context, {'name': name, 'email': email});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || result == null) return;
    final user = _auth.currentUser;
    if (user == null) return;

    final newName = result['name']!;
    final newEmail = result['email']!;

    await _updateUserFields({'name': newName});

    if (newEmail != currentEmail) {
      try {
        await user.verifyBeforeUpdateEmail(newEmail);
        await _updateUserFields({'email': newEmail});
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent to $newEmail')),
        );
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Could not update email right now.')),
        );
      }
    }
  }

  Future<void> _sendPasswordReset(String email) async {
    if (email.isEmpty) return;
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to $email')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send reset email: $e')),
      );
    }
  }

  Future<void> _pickAndUploadProfilePhoto() async {
    final user = _auth.currentUser;
    if (user == null || _isUploadingPhoto) return;

    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 65,
        maxWidth: 700,
      );
      if (pickedFile == null) return;

      setState(() {
        _isUploadingPhoto = true;
        _uploadProgress = 0;
      });

      final bytes = await pickedFile.readAsBytes();
      if (mounted) {
        setState(() => _localPreviewBytes = bytes);
      }
      final path = 'profile_photos/${user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(path);
      final photoVersion = DateTime.now().millisecondsSinceEpoch;
      final metadata = SettableMetadata(
        contentType: pickedFile.mimeType ?? 'image/jpeg',
        cacheControl: 'public,max-age=60',
      );

      Future<void> runUploadTask() async {
        final uploadTask = ref.putData(bytes, metadata);
        final sub = uploadTask.snapshotEvents.listen((snapshot) {
          if (!mounted) return;
          final total = snapshot.totalBytes;
          if (total > 0) {
            setState(() => _uploadProgress = snapshot.bytesTransferred / total);
          }
        }, onError: (_) {});

        try {
          // Allow slower networks; avoid failing too early.
          await uploadTask.timeout(const Duration(minutes: 3));
        } finally {
          await sub.cancel();
        }
      }

      try {
        await runUploadTask();
      } on TimeoutException {
        // Retry once on transient network stalls.
        await runUploadTask();
      }

      final photoUrl = await ref.getDownloadURL().timeout(const Duration(seconds: 30));

      await _db.collection('users').doc(user.uid).set({
        'photoUrl': photoUrl,
        'photoVersion': photoVersion,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updatePhotoURL(photoUrl);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated')),
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      final message = e.message ?? e.code;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $message')),
      );
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Upload not progressing. Check internet and Firebase Storage rules/bucket setup.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload photo: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingPhoto = false;
          _uploadProgress = 0;
          _localPreviewBytes = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to open settings.')),
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
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _db.collection('users').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data?.data() ?? <String, dynamic>{};
          final name = (data['name'] as String?)?.trim().isNotEmpty == true ? data['name'] as String : 'User';
          final email = (data['email'] as String?)?.trim().isNotEmpty == true
              ? data['email'] as String
              : (user.email ?? 'No Email');
          final role = (data['role'] as String?)?.trim().isNotEmpty == true ? data['role'] as String : 'Member';
          final pushNotifications = data['pushNotifications'] as bool? ?? true;
          final emailUpdates = data['emailUpdates'] as bool? ?? false;
          final photoUrl = (data['photoUrl'] as String?) ?? '';
          final photoVersion = data['photoVersion'] as int? ?? 0;
          final photoUrlWithVersion =
              photoUrl.isNotEmpty ? '$photoUrl${photoUrl.contains('?') ? '&' : '?'}v=$photoVersion' : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFEBD4C3),
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: ClipOval(
                              child: _localPreviewBytes != null
                                  ? Image.memory(
                                      _localPreviewBytes!,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  : photoUrlWithVersion.isNotEmpty
                                      ? Image.network(
                                      photoUrlWithVersion,
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                    )
                                      : const Icon(Icons.person, size: 60, color: Colors.white),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _isUpdating || _isUploadingPhoto ? null : _pickAndUploadProfilePhoto,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4B56D2),
                                  shape: BoxShape.circle,
                                ),
                                child: _isUploadingPhoto
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_isUploadingPhoto)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '${(_uploadProgress * 100).toStringAsFixed(0)}% uploading...',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(
                        role,
                        style: const TextStyle(color: Color(0xFF4B56D2), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                _buildSectionHeader('ACCOUNT INFORMATION'),
                _buildCardWrapper([
                  _buildInfoTile(
                    Icons.person_outline,
                    'FULL NAME',
                    name,
                    onTap: () => _showEditProfileDialog(currentName: name, currentEmail: email),
                  ),
                  _buildDivider(),
                  _buildInfoTile(Icons.email_outlined, 'EMAIL ADDRESS', email),
                  _buildDivider(),
                  _buildInfoTile(Icons.school_outlined, 'ASSIGNED ROLE', role, isVerified: true),
                ]),
                const SizedBox(height: 32),
                _buildSectionHeader('PREFERENCES'),
                _buildCardWrapper([
                  _buildSwitchTile(
                    Icons.notifications_none,
                    'Push Notifications',
                    pushNotifications,
                    (val) => _updateUserFields({'pushNotifications': val}),
                    iconBg: const Color(0xFFFFF7E6),
                    iconColor: Colors.orange,
                  ),
                  _buildDivider(),
                  _buildSwitchTile(
                    Icons.alternate_email,
                    'Email Updates',
                    emailUpdates,
                    (val) => _updateUserFields({'emailUpdates': val}),
                    iconBg: const Color(0xFFE8EAF6),
                    iconColor: const Color(0xFF4B56D2),
                  ),
                  _buildDivider(),
                  _buildNavTile(
                    Icons.lock_outline,
                    'Change Password',
                    onTap: () => _sendPasswordReset(email),
                    iconBg: const Color(0xFFE6F7ED),
                    iconColor: Colors.green,
                  ),
                ]),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: Color(0xFFE57373)),
                    label: const Text(
                      'Logout',
                      style: TextStyle(color: Color(0xFFE57373), fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFFEE7E7)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'COACHING PRO V2.4.0',
                  style: TextStyle(color: Colors.grey, fontSize: 10, letterSpacing: 1.2),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildCardWrapper(List<Widget> children) {
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
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String label,
    String value, {
    bool isVerified = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF5F6FF), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: const Color(0xFF4B56D2), size: 20),
      ),
      title: Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
      subtitle: Text(
        value,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      trailing: isVerified
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFF1F2FD), borderRadius: BorderRadius.circular(8)),
              child: const Text(
                'VERIFIED',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF4B56D2)),
              ),
            )
          : onTap != null
              ? const Icon(Icons.edit_outlined, size: 16, color: Colors.grey)
              : const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    bool value,
    ValueChanged<bool> onChanged, {
    required Color iconBg,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFF4B56D2),
      ),
    );
  }

  Widget _buildNavTile(
    IconData icon,
    String title, {
    required VoidCallback onTap,
    required Color iconBg,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 70, endIndent: 20, color: Color(0xFFF5F5F5));
}
