import '../models/chat_model.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();

  factory ChatService() {
    return _instance;
  }

  ChatService._internal();

  final Map<String, ChatRoom> _chatRooms = {};
  final Map<String, List<ChatMessage>> _messages = {};
  final Map<String, List<ConnectionRequest>> _connectionRequests = {};

  // Create or get chat room
  Future<ChatRoom> createChatRoom(String userId1, String userId2) async {
    final roomId = _generateRoomId(userId1, userId2);

    if (!_chatRooms.containsKey(roomId)) {
      final room = ChatRoom(
        id: roomId,
        userId1: userId1,
        userId2: userId2,
        createdAt: DateTime.now(),
        lastMessageAt: DateTime.now(),
      );
      _chatRooms[roomId] = room;
      _messages[roomId] = [];
    }

    return _chatRooms[roomId]!;
  }

  // Send message
  Future<bool> sendMessage(
    String roomId,
    String senderId,
    String receiverId,
    String message,
  ) async {
    try {
      final msg = ChatMessage(
        id: _generateMessageId(),
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now(),
      );

      if (_messages[roomId] == null) {
        _messages[roomId] = [];
      }
      _messages[roomId]!.add(msg);

      // Update room last message
      if (_chatRooms[roomId] != null) {
        _chatRooms[roomId] = ChatRoom(
          id: _chatRooms[roomId]!.id,
          userId1: _chatRooms[roomId]!.userId1,
          userId2: _chatRooms[roomId]!.userId2,
          createdAt: _chatRooms[roomId]!.createdAt,
          lastMessageAt: DateTime.now(),
          lastMessage: message,
          user1Blocked: _chatRooms[roomId]!.user1Blocked,
          user2Blocked: _chatRooms[roomId]!.user2Blocked,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get messages from room
  Future<List<ChatMessage>> getMessages(String roomId) async {
    return _messages[roomId] ?? [];
  }

  // Get all chat rooms for user
  Future<List<ChatRoom>> getChatRooms(String userId) async {
    return _chatRooms.values
        .where((room) => room.userId1 == userId || room.userId2 == userId)
        .toList();
  }

  // Create connection request
  Future<bool> createConnectionRequest({
    required String senderId,
    required String receiverId,
    required ConnectionRequestType type,
    String? senderInfo,
  }) async {
    try {
      final request = ConnectionRequest(
        id: _generateRequestId(),
        senderId: senderId,
        receiverId: receiverId,
        type: type,
        createdAt: DateTime.now(),
        senderInfo: senderInfo,
      );

      if (_connectionRequests[receiverId] == null) {
        _connectionRequests[receiverId] = [];
      }
      _connectionRequests[receiverId]!.add(request);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get pending connection requests
  Future<List<ConnectionRequest>> getPendingRequests(String userId) async {
    return (_connectionRequests[userId] ?? [])
        .where((req) => !req.accepted && !req.declined)
        .toList();
  }

  // Accept connection request
  Future<bool> acceptConnectionRequest(String requestId, String userId) async {
    try {
      for (var requests in _connectionRequests.values) {
        for (var i = 0; i < requests.length; i++) {
          if (requests[i].id == requestId && requests[i].receiverId == userId) {
            requests[i] = ConnectionRequest(
              id: requests[i].id,
              senderId: requests[i].senderId,
              receiverId: requests[i].receiverId,
              type: requests[i].type,
              createdAt: requests[i].createdAt,
              accepted: true,
              declined: false,
              senderInfo: requests[i].senderInfo,
            );
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Decline connection request
  Future<bool> declineConnectionRequest(String requestId, String userId) async {
    try {
      for (var requests in _connectionRequests.values) {
        for (var i = 0; i < requests.length; i++) {
          if (requests[i].id == requestId && requests[i].receiverId == userId) {
            requests[i] = ConnectionRequest(
              id: requests[i].id,
              senderId: requests[i].senderId,
              receiverId: requests[i].receiverId,
              type: requests[i].type,
              createdAt: requests[i].createdAt,
              accepted: false,
              declined: true,
              senderInfo: requests[i].senderInfo,
            );
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  String _generateRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  String _generateMessageId() {
    return 'msg_${DateTime.now().millisecondsSinceEpoch}';
  }

  String _generateRequestId() {
    return 'req_${DateTime.now().millisecondsSinceEpoch}';
  }
}
