// Authentication Service with Firebase Phone Authentication
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';
import 'dart:developer' as developer;
// OTP service removed - using direct authentication instead
// import 'social_media_otp_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  // Firebase Auth instance
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;
  
  // Social Media OTP Service - REMOVED (no longer using OTP)
  // final SocialMediaOTPService _socialMediaService = SocialMediaOTPService();
  
  // Mock user storage
  final Map<String, User> _users = {};
  String? _currentUserId;
  
  // For phone authentication
  String? _verificationId;
  int? _resendToken;
  
  // For email authentication (fallback to mock)
  final Map<String, String> _otpStorage = {};
  
  // Generate random 6-digit OTP for email
  String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Register new user with phone using Firebase Auth or messaging platforms
  Future<bool> registerWithPhone(String phoneNumber, [String platform = 'sms']) async {
    try {
      developer.log('Starting phone verification for: $phoneNumber via $platform', name: 'AuthService');
      
      // For SMS, use Firebase Phone Authentication
      if (platform == 'sms') {
        // Show toast to indicate process started
        Fluttertoast.showToast(
          msg: "Sending OTP to $phoneNumber via SMS...",
          toastLength: Toast.LENGTH_SHORT,
        );
        
        String? errorMessage;
        
        await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (firebase_auth.PhoneAuthCredential credential) async {
            developer.log('Auto-verification completed', name: 'AuthService');
            try {
              await _firebaseAuth.signInWithCredential(credential);
              _currentUserId = _firebaseAuth.currentUser?.uid;
              Fluttertoast.showToast(
                msg: "Phone verified automatically!",
                toastLength: Toast.LENGTH_LONG,
              );
            } catch (e) {
              developer.log('Error in auto verification: $e', name: 'AuthService');
            }
          },
          verificationFailed: (firebase_auth.FirebaseAuthException e) {
            developer.log('Verification failed: ${e.code} - ${e.message}', name: 'AuthService');
            errorMessage = e.message;
            
            if (e.code == 'invalid-phone-number') {
              Fluttertoast.showToast(
                msg: "Invalid phone number format",
                toastLength: Toast.LENGTH_LONG,
              );
            } else if (e.code == 'too-many-requests') {
              Fluttertoast.showToast(
                msg: "Too many attempts. Try again later.",
                toastLength: Toast.LENGTH_LONG,
              );
            } else {
              Fluttertoast.showToast(
                msg: "Error: ${e.message}",
                toastLength: Toast.LENGTH_LONG,
              );
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            developer.log('Code sent! Verification ID: $verificationId', name: 'AuthService');
            _verificationId = verificationId;
            _resendToken = resendToken;
            
            Fluttertoast.showToast(
              msg: "OTP sent via SMS! Check your messages",
              toastLength: Toast.LENGTH_LONG,
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            developer.log('Auto retrieval timeout: $verificationId', name: 'AuthService');
            _verificationId = verificationId;
          },
          forceResendingToken: _resendToken,
        );
        
        await Future.delayed(const Duration(seconds: 2));
        return errorMessage == null;
        
      } else {
        // Platform-based OTP delivery removed - redirecting to test mode
        final otp = _generateOTP();
        _otpStorage[phoneNumber] = otp;
        
        developer.log('TEST MODE - OTP for $phoneNumber via $platform: $otp', name: 'AuthService');
        
        Fluttertoast.showToast(
          msg: "TEST MODE - Your OTP: $otp",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        
        await Future.delayed(const Duration(seconds: 1));
        return true;
      }
    } catch (e) {
      developer.log('Error in registerWithPhone: $e', name: 'AuthService');
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  // Register new user with email (mock implementation)
  Future<bool> registerWithEmail(String email) async {
    try {
      // Generate and store OTP
      final otp = _generateOTP();
      _otpStorage[email] = otp;
      
      // In production, send OTP via Email
      // For testing: OTP is logged and shown via toast
      developer.log('OTP for Email ($email): $otp', name: 'AuthService');
      
      // Show OTP in toast for testing
      Fluttertoast.showToast(
        msg: "TEST MODE - Your OTP: $otp",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );
      
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      developer.log('Error in registerWithEmail: $e', name: 'AuthService');
      return false;
    }
  }

  // Verify OTP for phone authentication  
  Future<String?> verifyOTP(String identifier, String otp) async {
    try {
      // First check if it's a platform-based OTP (stored in _otpStorage)
      final storedOTP = _otpStorage[identifier];
      
      if (storedOTP != null) {
        // Platform-based authentication (Messenger, Telegram, Viber, Instagram, or Email)
        developer.log('Verifying platform OTP: $otp for $identifier', name: 'AuthService');
        developer.log('Stored OTP: $storedOTP', name: 'AuthService');
        
        if (storedOTP == otp) {
          _currentUserId = identifier;
          _otpStorage.remove(identifier);
          
          Fluttertoast.showToast(
            msg: "Verified successfully!",
            toastLength: Toast.LENGTH_LONG,
          );
          
          return _currentUserId;
        } else {
          Fluttertoast.showToast(
            msg: "Invalid OTP code",
            toastLength: Toast.LENGTH_LONG,
          );
          return null;
        }
      }
      
      // Check if it's Firebase phone authentication (SMS)
      if (_verificationId != null && identifier.contains('+')) {
        developer.log('Verifying Firebase SMS OTP: $otp for verification ID: $_verificationId', name: 'AuthService');
        
        firebase_auth.PhoneAuthCredential credential = firebase_auth.PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otp,
        );
        
        final userCredential = await _firebaseAuth.signInWithCredential(credential);
        _currentUserId = userCredential.user?.uid;
        
        developer.log('Phone verification successful! User ID: $_currentUserId', name: 'AuthService');
        
        Fluttertoast.showToast(
          msg: "Phone verified successfully!",
          toastLength: Toast.LENGTH_LONG,
        );
        
        // Clear verification ID after successful verification
        _verificationId = null;
        _resendToken = null;
        
        return _currentUserId;
      }
      
      return null;
    } catch (e) {
      developer.log('Error in verifyOTP: $e', name: 'AuthService');
      
      if (e is firebase_auth.FirebaseAuthException) {
        if (e.code == 'invalid-verification-code') {
          Fluttertoast.showToast(
            msg: "Invalid OTP code. Please try again.",
            toastLength: Toast.LENGTH_LONG,
          );
        } else if (e.code == 'session-expired') {
          Fluttertoast.showToast(
            msg: "OTP expired. Please request a new one.",
            toastLength: Toast.LENGTH_LONG,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Error: ${e.message}",
            toastLength: Toast.LENGTH_LONG,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Error: ${e.toString()}",
          toastLength: Toast.LENGTH_LONG,
        );
      }
      
      return null;
    }
  }

  // Create user profile after registration
  Future<bool> createUserProfile({
    required String userId,
    required String firstName,
    required String phoneNumber,
    required int age,
    required String gender,
    required String country,
    required String state,
  }) async {
    try {
      // Save user to mock database
      _currentUserId = userId;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _currentUserId;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _currentUserId != null;
  }

  // Logout
  Future<void> logout() async {
    _currentUserId = null;
    _users.clear();
  }

  // Get user by ID
  User? getUserById(String userId) {
    return _users[userId];
  }

  // Update user
  Future<bool> updateUser(User user) async {
    try {
      _users[user.uid] = user;
      return true;
    } catch (e) {
      return false;
    }
  }
}
