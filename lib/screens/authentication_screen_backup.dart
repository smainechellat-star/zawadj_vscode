import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../providers/auth_provider.dart';
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
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _selectedCountryCode = '+213'; // Algeria by default
  String _authMethod = 'email'; // 'phone', 'email', or 'password'
  String _selectedPlatform = 'messenger'; // 'messenger', 'telegram', 'viber', 'instagram' (SMS removed)
  String _verificationType = 'otp'; // 'otp' or 'captcha'
  bool _captchaVerified = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _passwordComplexity = 'simple'; // 'simple' or 'complex'
  
  // Country codes list
  final Map<String, String> countryCodes = {
    '+213': 'Algeria 🇩🇿',
    '+1': 'USA/Canada 🇺🇸',
    '+44': 'UK 🇬🇧',
    '+33': 'France 🇫🇷',
    '+49': 'Germany 🇩🇪',
    '+91': 'India 🇮🇳',
    '+966': 'Saudi Arabia 🇸🇦',
    '+971': 'UAE 🇦🇪',
    '+20': 'Egypt 🇪🇬',
    '+212': 'Morocco 🇲🇦',
    '+216': 'Tunisia 🇹🇳',
    '+218': 'Libya 🇱🇾',
    '+221': 'Senegal 🇸🇳',
    '+234': 'Nigeria 🇳🇬',
    '+250': 'Rwanda 🇷🇼',
    '+256': 'Uganda 🇺🇬',
    '+92': 'Pakistan 🇵🇰',
    '+39': 'Italy 🇮🇹',
    '+34': 'Spain 🇪🇸',
  };

  @override
  void initState() {
    super.initState();
    language = 'ar';
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    phoneController.dispose();
    emailController.dispose();
    otpController.dispose();
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
                  Tab(text: isArabic ? ArabicStrings.login : EnglishStrings.login),
                  Tab(text: isArabic ? ArabicStrings.signUp : EnglishStrings.signUp),
                ],
              ),
              const SizedBox(height: 30),
              // Tab Content
              SizedBox(
                height: 400,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Login Tab
                    _buildLoginForm(context, isArabic),
                    // Sign Up Tab
                    _buildSignUpForm(context, isArabic),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Method selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _authMethod = 'phone'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _authMethod == 'phone' ? Colors.red : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? 'رقم الهاتف' : 'Phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _authMethod == 'phone' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _authMethod = 'email'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _authMethod == 'email' ? Colors.red : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? 'البريد الإلكتروني' : 'Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _authMethod == 'email' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Verification Type Selector (OTP or CAPTCHA)
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Text(
                  isArabic ? 'اختر طريقة التحقق' : 'Choose Verification Method',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _verificationType = 'otp';
                          _captchaVerified = false;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _verificationType == 'otp' ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _verificationType == 'otp' ? Colors.blue : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sms,
                                color: _verificationType == 'otp' ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic ? 'رمز OTP' : 'OTP Code',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _verificationType == 'otp' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _verificationType = 'captcha';
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _verificationType == 'captcha' ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _verificationType == 'captcha' ? Colors.green : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.security,
                                color: _verificationType == 'captcha' ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'CAPTCHA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _verificationType == 'captcha' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Phone login
          if (_authMethod == 'phone') ...[
            Text(
              isArabic ? 'أدخل رقم الهاتف للدخول' : 'Enter phone number to login',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCountryCode,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'الدولة' : 'Country',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.public),
                    ),
                    items: countryCodes.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCountryCode = value ?? '+213');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: CustomTextField(
                    label: isArabic ? ArabicStrings.phoneNumber : EnglishStrings.phoneNumber,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (_verificationType == 'otp') ...[
              Text(
                isArabic ? 'اختر طريقة استلام الرمز' : 'Choose OTP delivery method',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildPlatformChip('messenger', 'Messenger', Icons.messenger, Colors.blue),
                  _buildPlatformChip('telegram', 'Telegram', Icons.telegram, Colors.lightBlue),
                  _buildPlatformChip('viber', 'Viber', Icons.phone_in_talk, Colors.purple),
                  _buildPlatformChip('instagram', 'Instagram', Icons.camera_alt, Colors.pink),
                ],
              ),
            ] else ...[
              CaptchaWidget(
                isArabic: isArabic,
                onVerified: (verified) {
                  setState(() => _captchaVerified = verified);
                },
              ),
            ],
          ] else ...[
            Text(
              isArabic ? 'أدخل بريدك الإلكتروني للدخول' : 'Enter your email to login',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: isArabic ? ArabicStrings.email : EnglishStrings.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 15),
            // Password Field
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: isArabic ? 'كلمة المرور' : 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          // Forgot Password Link
          Align(
            alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/forgot-password'),
              child: Text(
                isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            label: isArabic ? ArabicStrings.login : EnglishStrings.login,
            onPressed: _handleLogin,
            isLoading: _isLoading,
            backgroundColor: Colors.red,
          ),
          const SizedBox(height: 20),
          // Social Login Buttons
          Text(
            isArabic ? 'أو سجل الدخول عبر' : 'Or sign in with',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.g_mobiledata,
                label: 'Google',
                color: Colors.red,
                onPressed: _handleGoogleSignIn,
              ),
              const SizedBox(width: 15),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Facebook',
                color: Colors.blue,
                onPressed: _handleFacebookSignIn,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            isArabic
                ? 'لا تملك حسابًا؟ انقر على "تسجيل"'
                : 'Don\'t have an account? Click "Sign Up"',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context, bool isArabic) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Method selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _authMethod = 'phone'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _authMethod == 'phone' ? Colors.red : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? 'رقم الهاتف' : 'Phone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _authMethod == 'phone' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _authMethod = 'email'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _authMethod == 'email' ? Colors.red : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isArabic ? 'البريد الإلكتروني' : 'Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _authMethod == 'email' ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Verification Type Selector (OTP or CAPTCHA) for Sign Up
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Text(
                  isArabic ? 'اختر طريقة التحقق' : 'Choose Verification Method',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _verificationType = 'otp';
                          _captchaVerified = false;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _verificationType == 'otp' ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _verificationType == 'otp' ? Colors.blue : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sms,
                                color: _verificationType == 'otp' ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isArabic ? 'رمز OTP' : 'OTP Code',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _verificationType == 'otp' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _verificationType = 'captcha';
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _verificationType == 'captcha' ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _verificationType == 'captcha' ? Colors.green : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.security,
                                color: _verificationType == 'captcha' ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'CAPTCHA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _verificationType == 'captcha' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Phone signup
          if (_authMethod == 'phone') ...[
            Text(
              isArabic ? 'أدخل رقم الهاتف للتسجيل' : 'Enter phone number to sign up',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCountryCode,
                    decoration: InputDecoration(
                      labelText: isArabic ? 'الدولة' : 'Country',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.public),
                    ),
                    items: countryCodes.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedCountryCode = value ?? '+213');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 5,
                  child: CustomTextField(
                    label: isArabic ? ArabicStrings.phoneNumber : EnglishStrings.phoneNumber,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              isArabic ? 'أدخل بريدك الإلكتروني للتسجيل' : 'Enter your email to sign up',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: isArabic ? ArabicStrings.email : EnglishStrings.email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
            ),
          ],
          const SizedBox(height: 15),
          // First Name Field
          CustomTextField(
            label: isArabic ? ArabicStrings.firstName : EnglishStrings.firstName,
            controller: TextEditingController(),
            prefixIcon: Icons.person,
          ),
          const SizedBox(height: 15),
          // Password Complexity Selector
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.purple.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'تعقيد كلمة المرور' : 'Password Complexity',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _passwordComplexity = 'simple'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _passwordComplexity == 'simple' ? Colors.green : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _passwordComplexity == 'simple' ? Colors.green : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: _passwordComplexity == 'simple' ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic ? 'بسيطة' : 'Simple',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _passwordComplexity == 'simple' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                isArabic ? '6+ حروف/أرقام' : '6+ letters/numbers',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _passwordComplexity == 'simple' ? Colors.white : Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _passwordComplexity = 'complex'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _passwordComplexity == 'complex' ? Colors.orange : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _passwordComplexity == 'complex' ? Colors.orange : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.security,
                                color: _passwordComplexity == 'complex' ? Colors.white : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isArabic ? 'معقدة' : 'Complex',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _passwordComplexity == 'complex' ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                isArabic ? '8+ حروف+أرقام+رموز' : '8+ letters+numbers+symbols',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _passwordComplexity == 'complex' ? Colors.white : Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          // Password Field
          TextField(
            controller: passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: isArabic ? 'كلمة المرور' : 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Confirm Password Field
          TextField(
            controller: confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 15),
          if (_verificationType == 'captcha') ...[
            CaptchaWidget(
              isArabic: isArabic,
              onVerified: (verified) {
                setState(() => _captchaVerified = verified);
              },
            ),
            const SizedBox(height: 15),
          ],
          const SizedBox(height: 30),
          CustomButton(
            label: isArabic ? ArabicStrings.signUp : EnglishStrings.signUp,
            onPressed: _handleSignUp,
            isLoading: _isLoading,
            backgroundColor: Colors.red,
          ),
          const SizedBox(height: 20),
          // Social Sign Up Buttons
          Text(
            isArabic ? 'أو سجل عبر' : 'Or sign up with',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(
                icon: Icons.g_mobiledata,
                label: 'Google',
                color: Colors.red,
                onPressed: _handleGoogleSignIn,
              ),
              const SizedBox(width: 15),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'Facebook',
                color: Colors.blue,
                onPressed: _handleFacebookSignIn,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            isArabic
                ? 'هل لديك حسابًا بالفعل؟ انقر على "تسجيل الدخول"'
                : 'Already have an account? Click "Login"',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformChip(String value, String label, IconData icon, Color color) {
    final isSelected = _selectedPlatform == value;
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      onSelected: (selected) {
        setState(() => _selectedPlatform = value);
      },
      selectedColor: color,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  void _handleLogin() async {
    final isArabic = language == 'ar';
    String identifier = '';

    // Check CAPTCHA verification if selected
    if (_verificationType == 'captcha' && !_captchaVerified) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic ? 'يرجى حل CAPTCHA أولاً' : 'Please solve CAPTCHA first'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    // Email/Password Login
    if (_authMethod == 'email' && passwordController.text.isNotEmpty) {
      if (emailController.text.isEmpty) {
        _showMessage(isArabic ? 'أدخل بريدك الإلكتروني' : 'Please enter your email', Colors.red);
        return;
      }
      if (passwordController.text.isEmpty) {
        _showMessage(isArabic ? 'أدخل كلمة المرور' : 'Please enter your password', Colors.red);
        return;
      }

      setState(() => _isLoading = true);
      try {
        final result = await PasswordAuthService().loginWithEmailPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (result['success']) {
          _showMessage(result['message'], Colors.green);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          _showMessage(result['message'], Colors.red);
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showMessage('Error: ${e.toString()}', Colors.red);
      }
      return;
    }

    // OTP Method (existing code)
    if (_authMethod == 'phone') {
      if (phoneController.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isArabic ? 'أدخل رقم الهاتف' : 'Please enter phone number')),
          );
        }
        return;
      }
      identifier = '$_selectedCountryCode${phoneController.text}';
    } else {
      if (emailController.text.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isArabic ? 'أدخل بريدك الإلكتروني' : 'Please enter your email')),
          );
        }
        return;
      }
      identifier = emailController.text;
    }

    setState(() => _isLoading = true);
    try {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success;
      
      // If CAPTCHA is used, skip OTP and go directly to profile
      if (_verificationType == 'captcha' && _captchaVerified) {
        // Direct login with CAPTCHA verification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isArabic 
                ? 'تم التحقق بنجاح! يتم تسجيل الدخول...' 
                : 'Verified successfully! Logging in...'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // Simulate login
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        setState(() => _isLoading = false);
        Navigator.pushReplacementNamed(context, '/profile');
        return;
      }
      
      // OTP Method
      if (_authMethod == 'phone') {
        success = await authProvider.authService.registerWithPhone(identifier, _selectedPlatform);
      } else {
        success = await authProvider.authService.registerWithEmail(identifier);
      }

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        _showOTPDialog(identifier, _authMethod);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isArabic 
                ? 'حدث خطأ أثناء الإرسال. تحقق من رقم الهاتف والاتصال بالإنترنت' 
                : 'Failed to send OTP. Check phone number and internet connection'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic 
              ? 'خطأ: ${e.toString()}' 
              : 'Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _handleSignUp() async {
    final isArabic = language == 'ar';

    // Validate email
    if (emailController.text.isEmpty) {
      _showMessage(isArabic ? 'أدخل بريدك الإلكتروني' : 'Please enter your email', Colors.red);
      return;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      _showMessage(isArabic ? 'أدخل كلمة المرور' : 'Please enter your password', Colors.red);
      return;
    }

    // Check password strength based on selected complexity
    final passwordService = PasswordAuthService();
    bool isValid = false;
    String errorMessage = '';
    
    if (_passwordComplexity == 'simple') {
      isValid = passwordService.isPasswordSimple(passwordController.text);
      errorMessage = isArabic
          ? 'كلمة المرور ضعيفة! يجب أن تحتوي على 6 أحرف على الأقل (حروف أو أرقام)'
          : 'Weak password! Must contain at least 6 characters (letters or numbers)';
    } else {
      isValid = passwordService.isPasswordComplex(passwordController.text);
      errorMessage = isArabic
          ? 'كلمة المرور ضعيفة! يجب أن تحتوي على 8 أحرف على الأقل مع حروف كبيرة وصغيرة وأرقام ورموز'
          : 'Weak password! Must contain at least 8 characters with uppercase, lowercase, numbers, and symbols';
    }
    
    if (!isValid) {
      _showMessage(errorMessage, Colors.orange);
      return;
    }

    // Confirm password
    if (passwordController.text != confirmPasswordController.text) {
      _showMessage(
        isArabic ? 'كلمات المرور غير متطابقة' : 'Passwords do not match',
        Colors.red,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await passwordService.registerWithEmailPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
        firstName: 'User', // You can add a firstName field
      );

      setState(() => _isLoading = false);

      if (result['success']) {
        _showMessage(result['message'], Colors.green);
        // Clear fields
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
        // Navigate to home
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

  Future<void> _handleGoogleSignIn() async {
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
        _showMessage(result['message'], Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error: ${e.toString()}', Colors.red);
    }
  }

  Future<void> _handleFacebookSignIn() async {
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
        _showMessage(result['message'], Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error: ${e.toString()}', Colors.red);
    }
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
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

  void _showOTPDialog(String identifier, String method) {
    final isArabic = language == 'ar';
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'التحقق من OTP' : 'OTP Verification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isArabic
                  ? 'أدخل رمز التحقق المرسل إلى ${method == 'phone' ? 'رقم الهاتف' : 'بريدك الإلكتروني'}'
                  : 'Enter the verification code sent to your ${method == 'phone' ? 'phone' : 'email'}',
            ),
            const SizedBox(height: 15),
            CustomTextField(
              label: isArabic ? 'رمز OTP' : 'OTP Code',
              controller: otpController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          CustomButton(
            label: isArabic ? 'التحقق' : 'Verify',
            onPressed: () async {
              _verifyOTPAndNavigate(identifier);
            },
          ),
        ],
      ),
    );
  }

  void _verifyOTPAndNavigate(String identifier) async {
    final isArabic = language == 'ar';
    final otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isArabic ? 'أدخل رمز OTP' : 'Please enter OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyOTP(identifier, otp);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (success) {
        otpController.clear();
        phoneController.clear();
        emailController.clear();
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isArabic
                ? 'رمز OTP غير صحيح'
                : 'Invalid OTP code'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isArabic
              ? 'حدث خطأ: ${e.toString()}'
              : 'Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
