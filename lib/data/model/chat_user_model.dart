import 'package:flutter/foundation.dart';

@immutable
class ChatUserModel {
  final String? nickname;
  final String? pw;

  const ChatUserModel({
    required this.nickname,
    this.pw,
  });

  ChatUserModel copyWith({
    String? nickname,
    String? pw,
  }) {
    return ChatUserModel(
      nickname: nickname,
      pw: pw,
    );
  }

  @override
  String toString() {
    return 'ChatUserModel{nickname: $nickname, pw: $pw}';
  }
}
