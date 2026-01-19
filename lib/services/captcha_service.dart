import 'dart:math';
import 'package:flutter/material.dart';

/// Simple Mathematical CAPTCHA Service for User Verification
class CaptchaService {
  static final CaptchaService _instance = CaptchaService._internal();
  
  factory CaptchaService() {
    return _instance;
  }
  
  CaptchaService._internal();
  
  final Random _random = Random();
  String? _currentAnswer;
  String? _currentQuestion;
  
  /// Generate a simple mathematical CAPTCHA
  Map<String, String> generateMathCaptcha() {
    final operations = ['+', '-', '*'];
    final operation = operations[_random.nextInt(operations.length)];
    
    int num1, num2, answer;
    
    switch (operation) {
      case '+':
        num1 = _random.nextInt(20) + 1;
        num2 = _random.nextInt(20) + 1;
        answer = num1 + num2;
        break;
      case '-':
        num1 = _random.nextInt(30) + 10;
        num2 = _random.nextInt(num1);
        answer = num1 - num2;
        break;
      case '*':
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
        answer = num1 * num2;
        break;
      default:
        num1 = 5;
        num2 = 3;
        answer = 8;
    }
    
    _currentQuestion = '$num1 $operation $num2 = ?';
    _currentAnswer = answer.toString();
    
    return {
      'question': _currentQuestion!,
      'answer': _currentAnswer!,
    };
  }
  
  /// Verify CAPTCHA answer
  bool verifyCaptcha(String userAnswer) {
    if (_currentAnswer == null) return false;
    return userAnswer.trim() == _currentAnswer;
  }
  
  /// Get current CAPTCHA question
  String? getCurrentQuestion() => _currentQuestion;
  
  /// Reset CAPTCHA
  void reset() {
    _currentAnswer = null;
    _currentQuestion = null;
  }
}

/// CAPTCHA Widget for displaying the challenge
class CaptchaWidget extends StatefulWidget {
  final Function(bool) onVerified;
  final bool isArabic;
  
  const CaptchaWidget({
    super.key,
    required this.onVerified,
    this.isArabic = true,
  });
  
  @override
  State<CaptchaWidget> createState() => _CaptchaWidgetState();
}

class _CaptchaWidgetState extends State<CaptchaWidget> {
  final CaptchaService _captchaService = CaptchaService();
  final TextEditingController _answerController = TextEditingController();
  String _question = '';
  bool _isVerified = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _generateNewCaptcha();
  }
  
  void _generateNewCaptcha() {
    final captcha = _captchaService.generateMathCaptcha();
    setState(() {
      _question = captcha['question']!;
      _errorMessage = null;
      _answerController.clear();
    });
  }
  
  void _verifyCaptcha() {
    final isCorrect = _captchaService.verifyCaptcha(_answerController.text);
    
    setState(() {
      _isVerified = isCorrect;
      if (isCorrect) {
        _errorMessage = null;
        widget.onVerified(true);
      } else {
        _errorMessage = widget.isArabic 
            ? 'الإجابة خاطئة، حاول مرة أخرى'
            : 'Wrong answer, try again';
        _generateNewCaptcha();
        widget.onVerified(false);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  _isVerified ? Icons.check_circle : Icons.security,
                  color: _isVerified ? Colors.green : Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.isArabic ? 'التحقق البشري' : 'Human Verification',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            
            // CAPTCHA Question Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200, width: 2),
              ),
              child: Center(
                child: Text(
                  _question,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Answer Input
            TextField(
              controller: _answerController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              decoration: InputDecoration(
                labelText: widget.isArabic ? 'أدخل الإجابة' : 'Enter Answer',
                hintText: widget.isArabic ? 'اكتب الناتج' : 'Type the result',
                prefixIcon: const Icon(Icons.edit),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                errorText: _errorMessage,
              ),
              enabled: !_isVerified,
            ),
            const SizedBox(height: 15),
            
            // Verify Button
            if (!_isVerified)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _verifyCaptcha,
                      icon: const Icon(Icons.check),
                      label: Text(
                        widget.isArabic ? 'تحقق' : 'Verify',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _generateNewCaptcha,
                    icon: const Icon(Icons.refresh),
                    tooltip: widget.isArabic ? 'سؤال جديد' : 'New Question',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      widget.isArabic ? 'تم التحقق بنجاح!' : 'Verified Successfully!',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }
}
