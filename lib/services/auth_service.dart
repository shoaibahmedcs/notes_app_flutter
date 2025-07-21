import 'package:firebase_auth/firebase_auth.dart';

// Result class for sign-in operations
class SignInResult {
  final bool isSuccess;
  final bool isCancelled;
  final String? errorMessage;
  final UserCredential? userCredential;

  SignInResult._({
    required this.isSuccess,
    required this.isCancelled,
    this.errorMessage,
    this.userCredential,
  });

  factory SignInResult.success(UserCredential userCredential) {
    return SignInResult._(
      isSuccess: true,
      isCancelled: false,
      userCredential: userCredential,
    );
  }

  factory SignInResult.cancelled() {
    return SignInResult._(isSuccess: false, isCancelled: true);
  }

  factory SignInResult.error(String errorMessage) {
    return SignInResult._(
      isSuccess: false,
      isCancelled: false,
      errorMessage: errorMessage,
    );
  }
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is currently signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Initialize and check authentication state
  Future<User?> getCurrentUser() async {
    // Wait for Firebase Auth to initialize and check for persisted user
    await _auth.authStateChanges().first;
    return _auth.currentUser;
  }

  // Sign in with email and password
  Future<SignInResult> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return SignInResult.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return SignInResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Error signing in with email/password: $e');
      return SignInResult.error(e.toString());
    }
  }

  // Create account with email and password
  Future<SignInResult> createAccountWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return SignInResult.success(userCredential);
    } on FirebaseAuthException catch (e) {
      return SignInResult.error(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Error creating account with email/password: $e');
      return SignInResult.error(e.toString());
    }
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (e) {
      print('Error sending password reset email: $e');
      return false;
    }
  }

  // Get user-friendly error messages
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
