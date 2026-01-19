import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import '../services/captcha_service.dart';
import '../services/password_auth_service.dart';
import '../services/social_auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  late String language;
  late TabController _tabController;

  // Registration controllers
  final emailRegController = TextEditingController();
  final usernameRegController = TextEditingController();
  final passwordRegController = TextEditingController();
  final confirmPasswordRegController = TextEditingController();

  // Login controllers
  final usernameLoginController = TextEditingController();
  final passwordLoginController = TextEditingController();

  // Forgot password controller
  final emailForgotController = TextEditingController();

  bool _isLoading = false;
  bool _captchaVerified = false;
  bool _obscurePasswordReg = true;
  bool _obscureConfirmPasswordReg = true;
  bool _obscurePasswordLogin = true;
  bool _showForgotPassword = false;

  @override
  void initState() {
    super.initState();
    language = 'ar';
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    emailRegController.dispose();
    usernameRegController.dispose();
    passwordRegController.dispose();
    confirmPasswordRegController.dispose();
    usernameLoginController.dispose();
    passwordLoginController.dispose();
    emailForgotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() => language = value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'ar', child: Text('العربية')),
              const PopupMenuItem(value: 'en', child: Text('English')),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  isArabic ? 'عربي' : 'EN',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.favorite, size: 60, color: Colors.red),
                ),
              ),
              const SizedBox(height: 30),
              // Title
              Text(
                isArabic ? ArabicStrings.appName : EnglishStrings.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Tab Bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(text: isArabic ? 'تسجيل جديد' : 'New Registration'),
                  Tab(text: isArabic ? 'تسجيل الدخول' : 'Login'),
                ],
              ),
              const SizedBox(height: 30),
              // Tab Content
              SizedBox(
                height: 650,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // New Registration Tab
                    _buildRegistrationForm(context, isArabic),
                    // Login Tab
                    _buildLoginForm(context, isArabic),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            isArabic ? 'إنشاء حساب جديد' : 'Create a New Account',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Email Field
          CustomTextField(
            label: isArabic ? 'البريد الإلكتروني' : 'Email',
            controller: emailRegController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email,
          ),
          const SizedBox(height: 15),

          // Username Field
          CustomTextField(
            label: isArabic ? 'اسم المستخدم' : 'Username',
            controller: usernameRegController,
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 15),

          // Password Field
          TextField(
            controller: passwordRegController,
            obscureText: _obscurePasswordReg,
            decoration: InputDecoration(
              labelText: isArabic ? 'كلمة المرور' : 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePasswordReg ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _obscurePasswordReg = !_obscurePasswordReg),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Confirm Password Field
          TextField(
            controller: confirmPasswordRegController,
            obscureText: _obscureConfirmPasswordReg,
            decoration: InputDecoration(
              labelText: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPasswordReg
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () => setState(
                  () =>
                      _obscureConfirmPasswordReg = !_obscureConfirmPasswordReg,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Captcha v3
          CaptchaWidget(
            isArabic: isArabic,
            onVerified: (verified) {
              setState(() => _captchaVerified = verified);
            },
          ),
          const SizedBox(height: 25),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      // احصل على القيم من TextEditingController
                      String email = emailRegController.text;
                      String password = passwordRegController.text;

                      // استدعي دالة التسجيل
                      handleSignUp(
                        email,
                        password,
                        context,
                        isArabic,
                        usernameRegController.text,
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isArabic ? 'تسجيل' : 'Register',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 25),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade400)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  isArabic ? 'أو سجل عبر' : 'Other method for Login',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 20),

          // Social Login Buttons
          _buildSocialButton(
            icon: Icons.g_mobiledata,
            label: 'Gmail',
            color: Colors.red,
            onPressed: _handleGoogleSignIn,
          ),
          const SizedBox(height: 10),
          _buildSocialButton(
            icon: Icons.facebook,
            label: 'Facebook',
            color: const Color(0xFF1877F2),
            onPressed: _handleFacebookSignIn,
          ),
          const SizedBox(height: 10),
          _buildSocialButton(
            icon: Icons.camera_alt,
            label: 'Instagram',
            color: const Color(0xFFE4405F),
            onPressed: _handleInstagramSignIn,
          ),
          const SizedBox(height: 10),
          _buildSocialButton(
            icon: Icons.music_note,
            label: 'TikTok',
            color: Colors.black,
            onPressed: _handleTikTokSignIn,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          if (!_showForgotPassword) ...[
            Text(
              isArabic ? 'تسجيل الدخول' : 'Login to Your Account',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Username Field
            CustomTextField(
              label: isArabic ? 'اسم المستخدم' : 'Username',
              controller: usernameLoginController,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 15),

            // Password Field
            TextField(
              controller: passwordLoginController,
              obscureText: _obscurePasswordLogin,
              decoration: InputDecoration(
                labelText: isArabic ? 'كلمة المرور' : 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePasswordLogin
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => setState(
                    () => _obscurePasswordLogin = !_obscurePasswordLogin,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Forgot Password Link
            Align(
              alignment: isArabic
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => _showForgotPassword = true),
                child: Text(
                  isArabic ? 'نسيت كلمة المرور؟' : 'Forgot your password?',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button
            CustomButton(
              label: isArabic ? 'دخول' : 'Login',
              onPressed: _handleLogin,
              isLoading: _isLoading,
              backgroundColor: Colors.red,
            ),
          ] else ...[
            // Forgot Password Section
            Text(
              isArabic ? 'استعادة كلمة المرور' : 'Reset Your Password',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              isArabic
                  ? 'أدخل بريدك الإلكتروني واضغط على إرسال لاستلام رابط إعادة تعيين كلمة المرور'
                  : 'Enter your email and click on send to receive the link to reset your password',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // Email Field for Password Reset
            CustomTextField(
              label: isArabic ? 'البريد الإلكتروني' : 'Email',
              controller: emailForgotController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 20),

            // Send Reset Link Button
            CustomButton(
              label: isArabic ? 'إرسال' : 'Send',
              onPressed: _handleForgotPassword,
              isLoading: _isLoading,
              backgroundColor: Colors.red,
            ),
            const SizedBox(height: 15),

            // Back to Login
            TextButton(
              onPressed: () => setState(() => _showForgotPassword = false),
              child: Text(
                isArabic ? 'العودة إلى تسجيل الدخول' : 'Back to Login',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24),
        label: Text(label, style: const TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // دالة معالجة التسجيل مع عرض الأخطاء التفصيلية
  Future<void> handleSignUp(
    String email,
    String password,
    BuildContext context,
    bool isArabic,
    String username,
  ) async {
    if (!mounted) return;

    // تأكد من أن الحقول غير فارغة
    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'الرجاء إدخال البريد الإلكتروني وكلمة المرور'
                : 'Please enter email and password',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // محاولة التسجيل
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(), // إزالة المسافات
            password: password,
          );

      debugPrint('✅ تم التسجيل بنجاح! User ID: ${credential.user?.uid}');

      // رسالة نجاح
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'تم التسجيل بنجاح! 🎉' : 'Registration successful! 🎉',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Clear fields
      emailRegController.clear();
      usernameRegController.clear();
      passwordRegController.clear();
      confirmPasswordRegController.clear();

      if (!mounted) return;
      setState(() => _captchaVerified = false);

      // الانتقال للشاشة الرئيسية
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      // طباعة الخطأ في Console
      debugPrint('❌ Error Code: ${e.code}');
      debugPrint('❌ Error Message: ${e.message}');

      // تحديد رسالة الخطأ بناءً على نوع المشكلة
      String errorMessage = '';

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = isArabic
              ? 'هذا البريد الإلكتروني مُستخدم بالفعل'
              : 'This email is already in use';
          break;
        case 'invalid-email':
          errorMessage = isArabic
              ? 'البريد الإلكتروني غير صحيح'
              : 'Invalid email address';
          break;
        case 'weak-password':
          errorMessage = isArabic
              ? 'كلمة المرور ضعيفة جداً. يجب أن تكون 6 أحرف على الأقل'
              : 'Password is too weak. Must be at least 6 characters';
          break;
        case 'operation-not-allowed':
          errorMessage = isArabic
              ? 'التسجيل بالبريد الإلكتروني غير مفعّل في Firebase'
              : 'Email registration is not enabled in Firebase';
          break;
        case 'network-request-failed':
          errorMessage = isArabic
              ? 'مشكلة في الاتصال بالإنترنت'
              : 'Network connection problem';
          break;
        default:
          errorMessage = isArabic
              ? 'خطأ: ${e.code}\n${e.message}'
              : 'Error: ${e.code}\n${e.message}';
      }

      // عرض رسالة الخطأ على الشاشة
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      // أي خطأ آخر
      debugPrint('❌ Unknown Error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic
                ? 'حدث خطأ غير متوقع: $e'
                : 'Unexpected error occurred: $e',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLogin() async {
    final isArabic = language == 'ar';

    // Validate username
    if (usernameLoginController.text.isEmpty) {
      _showMessage(
        isArabic ? 'أدخل اسم المستخدم' : 'Please enter your username',
        Colors.red,
      );
      return;
    }

    // Validate password
    if (passwordLoginController.text.isEmpty) {
      _showMessage(
        isArabic ? 'أدخل كلمة المرور' : 'Please enter your password',
        Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Since we're using username, we need to convert it to email
      // For now, we'll treat username as email
      final passwordService = PasswordAuthService();
      final result = await passwordService.loginWithEmailPassword(
        email: usernameLoginController.text.trim(),
        password: passwordLoginController.text,
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        _showMessage(result['message'], Colors.green);
        // Clear fields
        usernameLoginController.clear();
        passwordLoginController.clear();

        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        _showMessage(result['message'], Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error: ${e.toString()}', Colors.red);
    }
  }

  void _handleForgotPassword() async {
    final isArabic = language == 'ar';
    final email = emailForgotController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        isArabic ? 'أدخل بريدك الإلكتروني' : 'Please enter your email address',
        Colors.red,
      );
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showMessage(
        isArabic
            ? 'البريد الإلكتروني غير صالح'
            : 'Please enter a valid email address',
        Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await PasswordAuthService().sendPasswordResetEmail(email);

      setState(() => _isLoading = false);

      if (result['success']) {
        _showMessage(result['message'], Colors.green);
        emailForgotController.clear();
        // Wait 2 seconds then go back to login
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          setState(() => _showForgotPassword = false);
        }
      } else {
        _showMessage(result['message'], Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final isArabic = language == 'ar';
    setState(() => _isLoading = true);

    try {
      final result = await SocialAuthService().signInWithGoogle();

      setState(() => _isLoading = false);

      if (result['success']) {
        _showMessage(result['message'], Colors.green);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Provide more helpful error messages
        String errorMessage = result['message'];
        
        if (errorMessage.contains('sign_in_failed') || errorMessage.contains('PlatformException')) {
          errorMessage = isArabic
              ? 'خطأ في تسجيل الدخول عبر Google. يرجى التأكد من:\n'
                '1. تفعيل Google Sign-In في Firebase Console\n'
                '2. إضافة SHA-1 و SHA-256 في إعدادات التطبيق\n'
                '3. تحديث ملف google-services.json'
              : 'Google Sign-In error. Please ensure:\n'
                '1. Google Sign-In is enabled in Firebase Console\n'
                '2. SHA-1 and SHA-256 fingerprints are added\n'
                '3. google-services.json is up to date';
        } else if (errorMessage.contains('Sign in aborted')) {
          errorMessage = isArabic
              ? 'تم إلغاء تسجيل الدخول'
              : 'Sign in cancelled';
        }
        
        _showMessage(errorMessage, Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      String errorMessage = isArabic
          ? 'خطأ غير متوقع: ${e.toString()}\n'
            'الرجاء التحقق من إعدادات Firebase'
          : 'Unexpected error: ${e.toString()}\n'
            'Please check Firebase configuration';
      
      _showMessage(errorMessage, Colors.red);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    final isArabic = language == 'ar';
    setState(() => _isLoading = true);

    try {
      final result = await SocialAuthService().signInWithFacebook();

      setState(() => _isLoading = false);

      if (result['success']) {
        _showMessage(result['message'], Colors.green);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Provide more helpful error messages
        String errorMessage = result['message'];
        
        if (errorMessage.contains('MissingPluginException')) {
          errorMessage = isArabic
              ? 'خطأ: إضافة Facebook غير مفعلة بشكل صحيح.\n'
                'يرجى التأكد من:\n'
                '1. تثبيت flutter_facebook_auth بشكل صحيح\n'
                '2. إضافة Facebook App ID في AndroidManifest.xml\n'
                '3. تفعيل Facebook Login في Firebase Console'
              : 'Error: Facebook plugin not properly configured.\n'
                'Please ensure:\n'
                '1. flutter_facebook_auth is properly installed\n'
                '2. Facebook App ID is added to AndroidManifest.xml\n'
                '3. Facebook Login is enabled in Firebase Console';
        } else if (errorMessage.contains('CANCELLED') || errorMessage.contains('cancelled')) {
          errorMessage = isArabic
              ? 'تم إلغاء تسجيل الدخول'
              : 'Sign in cancelled';
        }
        
        _showMessage(errorMessage, Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      String errorMessage = e.toString();
      
      if (errorMessage.contains('MissingPluginException')) {
        errorMessage = isArabic
            ? 'Facebook Login غير مفعل. يرجى اتباع تعليمات الإعداد في FIREBASE_SETUP.md'
            : 'Facebook Login not configured. Please follow setup instructions in FIREBASE_SETUP.md';
      } else {
        errorMessage = isArabic
            ? 'خطأ غير متوقع: ${e.toString()}'
            : 'Unexpected error: ${e.toString()}';
      }
      
      _showMessage(errorMessage, Colors.red);
    }
  }

  Future<void> _handleInstagramSignIn() async {
    final isArabic = language == 'ar';
    _showMessage(
      isArabic
          ? 'تسجيل الدخول عبر Instagram قيد التطوير'
          : 'Instagram login is under development',
      Colors.orange,
    );
  }

  Future<void> _handleTikTokSignIn() async {
    final isArabic = language == 'ar';
    _showMessage(
      isArabic
          ? 'تسجيل الدخول عبر TikTok قيد التطوير'
          : 'TikTok login is under development',
      Colors.orange,
    );
  }

  void _showMessage(String message, Color color) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
