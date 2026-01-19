class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      message: map['message'],
      timestamp: DateTime.parse(map['timestamp']),
      isRead: map['isRead'] ?? false,
    );
  }
}

class ChatRoom {
  final String id;
  final String userId1;
  final String userId2;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final String? lastMessage;
  final bool user1Blocked;
  final bool user2Blocked;

  ChatRoom({
    required this.id,
    required this.userId1,
    required this.userId2,
    required this.createdAt,
    required this.lastMessageAt,
    this.lastMessage,
    this.user1Blocked = false,
    this.user2Blocked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId1': userId1,
      'userId2': userId2,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'lastMessage': lastMessage,
      'user1Blocked': user1Blocked,
      'user2Blocked': user2Blocked,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      userId1: map['userId1'],
      userId2: map['userId2'],
      createdAt: DateTime.parse(map['createdAt']),
      lastMessageAt: DateTime.parse(map['lastMessageAt']),
      lastMessage: map['lastMessage'],
      user1Blocked: map['user1Blocked'] ?? false,
      user2Blocked: map['user2Blocked'] ?? false,
    );
  }
}

class ConnectionRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final ConnectionRequestType type;
  final DateTime createdAt;
  final bool accepted;
  final bool declined;
  final String? senderInfo; // Phone, email, etc.

  ConnectionRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.createdAt,
    this.accepted = false,
    this.declined = false,
    this.senderInfo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type.toString(),
      'createdAt': createdAt.toIso8601String(),
      'accepted': accepted,
      'declined': declined,
      'senderInfo': senderInfo,
    };
  }

  factory ConnectionRequest.fromMap(Map<String, dynamic> map) {
    return ConnectionRequest(
      id: map['id'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      type: ConnectionRequestType.values.firstWhere(
        (e) => e.toString() == map['type'],
      ),
      createdAt: DateTime.parse(map['createdAt']),
      accepted: map['accepted'] ?? false,
      declined: map['declined'] ?? false,
      senderInfo: map['senderInfo'],
    );
  }
}

enum ConnectionRequestType { guardianPhone, personalPhone, socialMedia }
