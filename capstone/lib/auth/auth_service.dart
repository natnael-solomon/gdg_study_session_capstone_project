import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal() {
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String fullName,
    String? photoUrl,
  }) async {
    try {
      final normalizedUsername = username.toLowerCase();

      final usernameDoc =
          await _firestore
              .collection('usernames')
              .doc(normalizedUsername)
              .get();

      if (usernameDoc.exists) {
        throw AuthException('Username already taken');
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final batch = _firestore.batch();

      batch.set(_firestore.collection('usernames').doc(normalizedUsername), {
        'email': email,
        'uid': uid,
      });

      batch.set(_firestore.collection('users').doc(uid), {
        'username': normalizedUsername,
        'email': email,
        'fullName': fullName,
        'photoUrl': photoUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      await userCredential.user!.updateDisplayName(fullName);
      if (photoUrl != null && photoUrl.isNotEmpty) {
        await userCredential.user!.updatePhotoURL(photoUrl);
      }

      _currentUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    } on FirebaseException catch (e) {
      throw AuthException(_getFirestoreErrorMessage(e));
    } catch (e) {
      throw AuthException(
        'Registration failed. Please try again.',
      ); 
    }
  }

  Future<void> signIn(String username, String password) async {
    try {
      final normalizedUsername = username.toLowerCase();

      final email = await _getEmailForUsername(normalizedUsername);

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e));
    } on FirebaseException catch (e) {
      throw AuthException(_getFirestoreErrorMessage(e));
    } catch (e) {
      throw AuthException(
        'Login failed. Please try again.',
      ); 
    }
  }

  Future<String> _getEmailForUsername(String username) async {
    try {
      final doc = await _firestore.collection('usernames').doc(username).get();

      if (doc.exists) {
        return doc['email'] as String;
      }
      /*a dummy email if username doesn't exist to prevent enumeration*/
      return 'invalid_${DateTime.now().millisecondsSinceEpoch}@dummy.com';
    } catch (e) {
      throw AuthException('Login service unavailable');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
    } catch (e) {
      throw AuthException('Could not sign out. Please try again.');
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'An account with this email already exists';
      case 'weak-password':
        return 'Password must be at least 6 characters';
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'wrong-password':
      case 'user-not-found':
        return 'Invalid credentials'; 
      case 'user-disabled':
        return 'This account has been disabled. Contact support';
      case 'operation-not-allowed':
        return 'Login is currently unavailable. Try again later';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Invalid credentials'; 
    }
  }

  String _getFirestoreErrorMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Operation not permitted';
      case 'unavailable':
        return 'Service unavailable. Try again later';
      case 'aborted':
        return 'Operation aborted';
      case 'data-loss':
        return 'Data loss occurred';
      default:
        return 'Database operation failed. Please try again';
    }
  }
}
