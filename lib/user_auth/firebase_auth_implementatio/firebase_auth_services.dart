import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String name, String password) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create a document in Firestore to store user history
      await _firestore.collection('sign_data').doc(credential.user!.uid).set({
        'name': name,
        'uid': credential.user!.uid,
        'email': email,
        'signup_time': DateTime.now(),
        // Add any other initial user history data you want to store
      });

      return credential.user;
    } catch (e) {
      print("Error signing up: $e");
      throw e; // Throw the error to handle it in UI
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update email in Firestore if it's different from the one stored
      await _firestore
          .collection('user_history')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'email': email,
        'signup_time': DateTime.now(),
        // Add any other initial user history data you want to store
      });

      return credential.user;
    } catch (e) {
      print("Error signing in: $e");
      throw e; // Throw the error to handle it in UI
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Error resetting password: $e");
      throw e; // Throw the error to handle it in UI
    }
  }

  Future<void> saveChatMessage(
      String uid, String email, String password, String _messages) async {
    try {
      await _firestore
          .collection('user_history')
          .doc(uid)
          .collection('chat_history')
          .add({
        'email': email,
        'message': _messages,
        'timestamp': DateTime.now(),
      });
    } catch (e) {
      print("Error saving chat message: $e");
      throw e; // Throw the error to handle it in UI
    }
  }
}
