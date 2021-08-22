import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum ChatMessageType { text, image, file, video, none }

@immutable
class ChatMessageModel {
  final String? avatarUrl;
  final String? nickname;
  final Timestamp? createdAt;
  final String? text;
  final String? type;
  final String? imageUrl;

  const ChatMessageModel({
    required this.nickname,
    required this.type,
    this.avatarUrl,
    this.text,
    this.createdAt,
    this.imageUrl,
  });

  ChatMessageModel.fromJson(Map<String, dynamic> json)
      : avatarUrl = json['avatarUrl'] as String?,
        nickname = json['nickname'] as String?,
        createdAt = json['createdAt'] as Timestamp?,
        text = json['text'] as String?,
        imageUrl = json['imageUrl'] as String?,
        type = json['type'] as String?;

  ChatMessageModel copyWith({
    String? avatarUrl,
    String? nickname,
  }) {
    return ChatMessageModel(
      type: type,
      avatarUrl: avatarUrl,
      nickname: nickname,
      text: text ?? '',
      createdAt: createdAt,
      imageUrl: imageUrl,
    );
  }
}
