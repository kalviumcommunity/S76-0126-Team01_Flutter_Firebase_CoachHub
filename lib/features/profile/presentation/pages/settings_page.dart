import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s76_0126_team01_flutter_firebase_coachhub/features/auth/data/auth_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  bool pushNotifications = true;
  bool emailUpdates = false;
  bool _isLoading = true;
  bool _isSaving = false;

  String _name = '';
  String _email = '';
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      final data = doc.data();
      if (!mounted) return;

      setState(() {
        _name = (data?['name'] as String?)?.trim().isNotEmpty == true
            ? data!['name'] as String
            : (user.displayName ?? 'User');
        _email = (data?['email'] as String?)?.trim().isNotEmpty == true
            ? data!['email'] as String
            : (user.email ?? '');
        _role = (data?['role'] as String?)?.trim().isNotEmpty == true
            ? data!['role'] as String
            : 'Student';
        pushNotifications = data?['pushNotifications'] as bool? ?? true;
        emailUpdates = data?['emailUpdates'] as bool? ?? false;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile: $e')),
      );
    }
  }

  Future<void> _saveUserFields(Map<String, dynamic> fields) async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      await _db.collection('users').doc(user.uid).set(fields, SetOptions(merge: true));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save settings: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _updatePreference({
    required String field,
    required bool value,
    required VoidCallback updateLocal,
  }) async {
    updateLocal();
    await _saveUserFields({field: value});
  }

  Future<void> _showEditNameDialog() async {
    final controller = TextEditingController(text: _name);
    final updatedName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Full Name'),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(hintText: 'Enter your full name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isEmpty) return;
                Navigator.pop(context, value);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (!mounted || updatedName == null || updatedName == _name) {
      return;
    }

    setState(() => _name = updatedName);
    await _saveUserFields({'name': updatedName});
  }

  Future<void> _handleChangePassword() async {
    final email = _email.trim().isNotEmpty ? _email.trim() : _auth.currentUser?.email;
    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No email found for this account.')),
      );
      return;
    }

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

  Future<void> _handleLogout() async {
    try {
      await AuthService().signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(child: CircularProgressIndicator()),
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
      body: SingleChildScrollView(
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
                        child: const Icon(Icons.person, size: 60, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _isSaving ? null : _showEditNameDialog,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4B56D2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _name.isEmpty ? 'User' : _name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Role: ${_role.isEmpty ? 'Student' : _role}',
                    style: const TextStyle(color: Color(0xFF4B56D2), fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildSectionTitle('ACCOUNT INFORMATION'),
            _buildInfoCard([
              _buildInfoTile(
                Icons.person_outline,
                'FULL NAME',
                _name.isEmpty ? 'Not set' : _name,
                onTap: _showEditNameDialog,
              ),
              _buildDivider(),
              _buildInfoTile(
                Icons.email_outlined,
                'EMAIL ADDRESS',
                _email.isEmpty ? 'Not set' : _email,
              ),
              _buildDivider(),
              _buildInfoTile(
                Icons.school_outlined,
                'ASSIGNED ROLE',
                _role.isEmpty ? 'Student' : _role,
                isVerified: true,
              ),
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('PREFERENCES'),
            _buildInfoCard([
              _buildSwitchTile(
                Icons.notifications_none,
                'Push Notifications',
                pushNotifications,
                (val) => _updatePreference(
                  field: 'pushNotifications',
                  value: val,
                  updateLocal: () => setState(() => pushNotifications = val),
                ),
                iconBg: const Color(0xFFFFF7E6),
                iconColor: Colors.orange,
              ),
              _buildDivider(),
              _buildSwitchTile(
                Icons.alternate_email,
                'Email Updates',
                emailUpdates,
                (val) => _updatePreference(
                  field: 'emailUpdates',
                  value: val,
                  updateLocal: () => setState(() => emailUpdates = val),
                ),
                iconBg: const Color(0xFFE8EAF6),
                iconColor: const Color(0xFF4B56D2),
              ),
              _buildDivider(),
              _buildNavigationTile(
                Icons.lock_outline,
                'Change Password',
                onTap: _handleChangePassword,
                iconBg: const Color(0xFFE6F7ED),
                iconColor: Colors.green,
              ),
            ]),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _isSaving ? null : _handleLogout,
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 12),
        child: Text(
          title,
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
      subtitle: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
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

  Widget _buildNavigationTile(
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
