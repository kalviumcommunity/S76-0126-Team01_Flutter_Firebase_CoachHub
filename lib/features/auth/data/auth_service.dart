import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Sign Up: Creates Auth account and then saves role to Firestore
  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String role, // Expected values: 'Teacher' or 'Student'
  }) async {
    try {
      // Create user in Firebase Authentication
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      // Store profile and role in the 'users' Firestore collection
      // Using .doc(res.user!.uid) ensures the Document ID matches the Auth UID
      await _db.collection('users').doc(res.user!.uid).set({
        'uid': res.user!.uid,
        'name': name,
        'email': email,
        'role': role, 
        'createdAt': FieldValue.serverTimestamp(),
      });
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message; // Returns specific errors like 'email-already-in-use'
    } catch (e) {
      return e.toString();
    }
  }

  // 2. Login: Authenticates the user
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 3. Get User Role: Fetches the 'role' field from Firestore for redirection
  Future<String?> getUserRole(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.get('role'); // Returns 'Teacher' or 'Student'
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // 4. Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}