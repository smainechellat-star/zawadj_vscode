import 'package:flutter/material.dart';
import '../l10n/arabic_strings.dart';
import '../l10n/english_strings.dart';
import '../widgets/common_widgets.dart';
import '../services/chat_service.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String language;
  final messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  late String currentUserId;
  late String otherUserId;
  late String chatRoomId;
  List<ChatMessage> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    language = 'ar';
    // These should be passed from previous screen
    currentUserId = 'user_123';  // Replace with actual user ID
    otherUserId = 'user_456';    // Replace with actual partner ID
    _initChat();
  }

  Future<void> _initChat() async {
    try {
      final chatRoom = await _chatService.createChatRoom(currentUserId, otherUserId);
      chatRoomId = chatRoom.id;
      await _loadMessages();
    } catch (e) {
      debugPrint('Error initializing chat: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadMessages() async {
    try {
      final loadedMessages = await _chatService.getMessages(chatRoomId);
      setState(() {
        messages = loadedMessages;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading messages: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final success = await _chatService.sendMessage(
      chatRoomId,
      currentUserId,
      otherUserId,
      messageController.text.trim(),
    );

    if (success) {
      messageController.clear();
      await _loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = language == 'ar';
      

    return Scaffold(
      appBar: CustomAppBar(
        title: 'أحمد محمود',
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Column(
        children: [
          // Days Counter (First 3 days only)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.orange.shade700,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isArabic ? 'أيام متبقية: 2' : 'Days Remaining: 2',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Messages List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          isArabic ? 'لا توجد رسائل بعد' : 'No messages yet',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          final isMe = message.senderId == currentUserId;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isMe ? Colors.blue : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      message.message,
                                      style: TextStyle(
                                        color: isMe ? Colors.white : Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatTime(message.timestamp),
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),

          // Connection Request Panel (After 3 days)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? 'لا يحدث أي تبادل للمعلومات الشخصية دون موافقة الطرفين'
                      : 'No personal information exchange without mutual approval',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                _buildConnectionOption(
                  isArabic ? '📱 طلب رقم الولي' : '📱 Request Guardian Phone',
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildConnectionOption(
                  isArabic ? '☎️ طلب رقم الهاتف' : '☎️ Request Phone Number',
                  Colors.green,
                ),
                const SizedBox(height: 8),
                _buildConnectionOption(
                  isArabic ? '📱 وسائل التواصل' : '📱 Social Media',
                  Colors.green,
                ),
              ],
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: isArabic ? ArabicStrings.typeMessage : EnglishStrings.typeMessage,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildConnectionOption(String label, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(label)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
