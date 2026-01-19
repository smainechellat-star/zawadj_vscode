import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Password Authentication Service
class PasswordAuthService {
  static final PasswordAuthService _instance = PasswordAuthService._internal();
  
  factory PasswordAuthService() {
    return _instance;
  }
  
  PasswordAuthService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Hash password using SHA256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  /// Register user with email and password
  Future<Map<String, dynamic>> registerWithEmailPassword({
    required String email,
    required String password,
    required String firstName,
  }) async {
    try {
      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        return {'success': false, 'message': 'Failed to create user'};
      }
      
      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': email,
        'firstName': firstName,
        'passwordHash': _hashPassword(password),
        'authMethod': 'password',
        'createdAt': FieldValue.serverTimestamp(),
        'uid': user.uid,
      });
      
      return {
        'success': true,
        'message': 'Registration successful',
        'uid': user.uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  
  /// Login with email and password
  Future<Map<String, dynamic>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = userCredential.user;
      if (user == null) {
        return {'success': false, 'message': 'Failed to login'};
      }
      
      return {
        'success': true,
        'message': 'Login successful',
        'uid': user.uid,
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else if (e.code == 'user-disabled') {
        message = 'This user has been disabled';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  
  /// Send password reset email
  Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent successfully',
      };
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  
  /// Verify password strength (simple - at least 6 characters, letters or numbers)
  bool isPasswordSimple(String password) {
    // At least 6 characters, contains letters or numbers
    if (password.length < 6) return false;
    
    final hasLetters = password.contains(RegExp(r'[a-zA-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    
    return hasLetters || hasDigits;
  }
  
  /// Verify password strength (complex - at least 8 characters with mixed requirements)
  bool isPasswordComplex(String password) {
    // At least 8 characters, contains uppercase, lowercase, number, special char
    if (password.length < 8) return false;
    
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUppercase && hasLowercase && hasDigits && hasSpecialCharacters;
  }
  
  /// Verify password strength (legacy method - kept for backward compatibility)
  bool isPasswordStrong(String password) {
    return isPasswordComplex(password);
  }
  
  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
