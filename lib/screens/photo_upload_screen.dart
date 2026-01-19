import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<PhotoUploadScreen> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  late String language;
  bool photoUploaded = false;
  bool photoHidden = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    language = 'ar';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
      

    return Scaffold(
      appBar: CustomAppBar(
        title: isArabic ? ArabicStrings.photo : EnglishStrings.photo,
        onBackPressed: () => Navigator.pop(context),
        showForwardButton: true,
        onForwardPressed: photoUploaded
            ? () => Navigator.pushReplacementNamed(context, '/home')
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Instructions
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isArabic ? 'قواعد الصورة' : 'Photo Rules',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildRule(
                    isArabic ? '✅ صورة حقيقية سيلفي' : '✅ Real Selfie',
                  ),
                  _buildRule(isArabic ? '✅ الوجه واضح' : '✅ Face is Clear'),
                  _buildRule(
                    isArabic ? '✅ لباس محترم' : '✅ Respectful Clothing',
                  ),
                  _buildRule(
                    isArabic ? '❌ لا لقطات الشاشة' : '❌ No Screenshots',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Photo Upload Area
          if (!photoUploaded)
            Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.shade50,
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  isArabic
                                      ? 'انقر لاختيار صورة'
                                      : 'Tap to select photo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: isArabic ? ArabicStrings.uploadPhoto : EnglishStrings.uploadPhoto,
                  onPressed: _selectedImage != null ? () { _uploadPhoto(); } : null,
                  backgroundColor: _selectedImage != null ? Colors.green : Colors.grey,
                ),
              ],
            )
          else
            Column(
              children: [
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade200,
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: photoHidden
                              ? Stack(
                                  children: [
                                    Image.file(
                                      _selectedImage!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                    Container(
                                      color: Colors.black54,
                                      child: const Center(
                                        child: Icon(
                                          Icons.visibility_off,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('👤', style: TextStyle(fontSize: 100)),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isArabic ? 'قيد المراجعة' : 'Under Review',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        label: photoHidden
                            ? isArabic ? ArabicStrings.showPhoto : EnglishStrings.showPhoto
                            : isArabic ? ArabicStrings.hidePhoto : EnglishStrings.hidePhoto,
                        onPressed: () {
                          setState(() => photoHidden = !photoHidden);
                        },
                        backgroundColor: photoHidden
                            ? Colors.blue
                            : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButton(
                        label: isArabic ? 'تحديث الصورة' : 'Update Photo',
                        onPressed: () {
                          setState(() {
                            photoUploaded = false;
                            _selectedImage = null;
                          });
                        },
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 30),

          // Privacy Notice
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              border: Border.all(color: Colors.red.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isArabic
                  ? '🔐 صورتك محمية بالكامل. لن تظهر إلا بموافقتك.'
                  : '🔐 Your photo is fully protected. It will only appear with your permission.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRule(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(rule, style: const TextStyle(fontSize: 13, height: 1.4)),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في اختيار الصورة / Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _uploadPhoto() async {
    if (_selectedImage == null) return;

    try {
      // هنا يجب إضافة رفع الصورة إلى Firebase Storage
      // في الوقت الحالي سيتم حفظ المسار محلياً
      setState(() {
        photoUploaded = true;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              language == 'ar'
                  ? 'تم رفع الصورة بنجاح وهي قيد المراجعة'
                  : 'Photo uploaded successfully and is under review',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في رفع الصورة / Upload error: ${e.toString()}')),
        );
      }
    }
  }
}
