import 'package:flutter/foundation.dart';
import 'package:open_chat_flutter/data/model/chat_user_model.dart';

enum RoomType { direct, group, open, none }

@immutable
class ChatRoomModel {
  final String id;
  final RoomType type;
  final List<ChatUserModel> users;
  final String? name;
  final String? lastMsg;
  final String? imageUrl;

  const ChatRoomModel({
    required this.id,
    required this.type,
    required this.users,
    this.name,
    this.lastMsg,
    this.imageUrl,
  });

  ChatRoomModel copyWith({
    String? name,
    String? title,
    RoomType? type,
    List<ChatUserModel>? users,
    String? lastMsg,
    String? imageUrl,
  }) {
    return ChatRoomModel(
      id: id,
      type: type ?? this.type,
      users: users ?? this.users,
      name: name,
      lastMsg: lastMsg,
      imageUrl: imageUrl,
    );
  }

  @override
  String toString() {
    return 'ChatRoomModel{id: $id, type: $type, users: $users, name: $name, lastMsg: $lastMsg, imageUrl: $imageUrl}';
  }
}
