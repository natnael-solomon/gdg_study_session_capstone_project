import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? photoUrl,
  }) async {
    try {
      final normalizedUsername = username.toLowerCase();

      // Check if username exists
      final usernameDoc =
          await _firestore
              .collection('usernames')
              .doc(normalizedUsername)
              .get();

      if (usernameDoc.exists) {
        throw AuthException('Username already taken');
      }

      // Create user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Batch write to ensure atomic operations
      final batch = _firestore.batch();

      // Set username mapping
      batch.set(_firestore.collection('usernames').doc(normalizedUsername), {
        'email': email,
        'uid': uid,
      });

      // Create user profile
      batch.set(_firestore.collection('users').doc(uid), {
        'username': normalizedUsername,
        'email': email,
        'fullName': fullName,
        'photoUrl': photoUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      // Update auth profile
      await userCredential.user!.updateDisplayName(fullName);
      if (photoUrl != null && photoUrl.isNotEmpty) {
        await userCredential.user!.updatePhotoURL(photoUrl);
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    } on FirebaseException catch (e) {
      throw AuthException(_getFirestoreErrorMessage(e));
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> signIn(String username, String password) async {
    try {
      final normalizedUsername = username.toLowerCase();
      final doc =
          await _firestore
              .collection('usernames')
              .doc(normalizedUsername)
              .get();

      if (!doc.exists) throw AuthException('Username not found');

      final email = doc['email'] as String;

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    } on FirebaseException catch (e) {
      throw AuthException(_getFirestoreErrorMessage(e));
    } catch (e) {
      throw AuthException('An unexpected error occurred: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-not-found':
        return 'User not found.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }

  String _getFirestoreErrorMessage(FirebaseException e) {
    return 'Database operation failed: ${e.message}';
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
