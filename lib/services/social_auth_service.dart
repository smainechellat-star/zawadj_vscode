import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Social Media Authentication Service
class SocialAuthService {
  static final SocialAuthService _instance = SocialAuthService._internal();
  
  factory SocialAuthService() {
    return _instance;
  }
  
  SocialAuthService._internal();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  /// Helper method to build user-friendly error messages from Firebase Auth exceptions
  String _buildFirebaseAuthErrorMessage(FirebaseAuthException e, String provider) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your Firebase configuration';
      case 'operation-not-allowed':
        return '$provider Sign-In is not enabled in Firebase Console';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found with these credentials';
      case 'wrong-password':
        return 'Incorrect password';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
  
  /// Sign in with Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return {'success': false, 'message': 'Sign in aborted by user'};
      }
      
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user == null) {
        return {'success': false, 'message': 'Failed to sign in'};
      }
      
      // Save/update user data in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'firstName': user.displayName?.split(' ').first ?? 'User',
        'lastName': user.displayName?.split(' ').last ?? '',
        'photoURL': user.photoURL,
        'authMethod': 'google',
        'lastLogin': FieldValue.serverTimestamp(),
        'uid': user.uid,
      }, SetOptions(merge: true));
      
      return {
        'success': true,
        'message': 'Signed in with Google',
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
      };
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors using helper method
      return {
        'success': false, 
        'message': _buildFirebaseAuthErrorMessage(e, 'Google'),
        'code': e.code
      };
    } catch (e) {
      // Handle other errors (network, plugin, etc.)
      return {'success': false, 'message': e.toString()};
    }
  }
  
  /// Sign in with Facebook
  Future<Map<String, dynamic>> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );
      
      if (result.status != LoginStatus.success) {
        String message = 'Facebook sign in failed';
        if (result.status == LoginStatus.cancelled) {
          message = 'Sign in cancelled by user';
        } else if (result.status == LoginStatus.failed) {
          message = 'Sign in failed: ${result.message}';
        }
        return {'success': false, 'message': message};
      }
      
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      
      // Sign in to Firebase with the Facebook credential
      final userCredential = await _auth.signInWithCredential(facebookAuthCredential);
      final user = userCredential.user;
      
      if (user == null) {
        return {'success': false, 'message': 'Failed to sign in'};
      }
      
      // Get additional user data from Facebook
      final userData = await FacebookAuth.instance.getUserData();
      
      // Save/update user data in Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email ?? userData['email'],
        'firstName': userData['name']?.split(' ').first ?? 'User',
        'lastName': userData['name']?.split(' ').last ?? '',
        'photoURL': userData['picture']?['data']?['url'],
        'authMethod': 'facebook',
        'lastLogin': FieldValue.serverTimestamp(),
        'uid': user.uid,
      }, SetOptions(merge: true));
      
      return {
        'success': true,
        'message': 'Signed in with Facebook',
        'uid': user.uid,
        'email': user.email,
        'displayName': userData['name'],
      };
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors using helper method
      return {
        'success': false, 
        'message': _buildFirebaseAuthErrorMessage(e, 'Facebook'),
        'code': e.code
      };
    } catch (e) {
      // Handle other errors (network, plugin, etc.)
      return {'success': false, 'message': e.toString()};
    }
  }
  
  /// Sign out from all social providers
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
  }
  
  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
  
  /// Check if user is signed in
  bool isSignedIn() {
    return _auth.currentUser != null;
  }
}
