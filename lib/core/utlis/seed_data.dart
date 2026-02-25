import 'package:cloud_firestore/cloud_firestore.dart';

class SeedData {
  static Future<void> seedClasses(String teacherId) async {
    final db = FirebaseFirestore.instance;
    
    // Data matching your "Active Classes" UI design
    final List<Map<String, dynamic>> dummyClasses = [
      {'className': 'Advanced Mathematics', 'subject': 'Math', 'studentCount': 24, 'teacherId': teacherId},
      {'className': 'Physics Grade 12', 'subject': 'Science', 'studentCount': 18, 'teacherId': teacherId},
    ];

    for (var data in dummyClasses) {
      await db.collection('classes').add(data);
    }
  }
}