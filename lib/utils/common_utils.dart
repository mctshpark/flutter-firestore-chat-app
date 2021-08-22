import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:open_chat_flutter/data/model/chat_message_model.dart';
import 'package:open_chat_flutter/data/model/chat_room_model.dart';
import 'package:open_chat_flutter/data/model/chat_user_model.dart';

class ReleaseLogShow extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

void lo(String str, {bool err = false, bool isGetX = false}) {
  final logger = Logger(
    filter: ReleaseLogShow(),
    printer: PrettyPrinter(
      methodCount: 0,
      colors: true,
      printEmojis: false,
      printTime: false,
      lineLength: 180,
    ),
  );
  if (err) {
    logger.e('👿 $str');
  } else if (isGetX) {
    logger.v('👓 $str');
  } else {
    logger.w(str);
  }
}

CatcherOptions slackCatCherConfig() {
  String platform = '';
  try {
    platform = Platform.isAndroid ? 'Android' : 'iOS';
  } catch (e) {
    platform = 'Web';
  }
  return CatcherOptions(
    SilentReportMode(),
    [
      SlackHandler(
        'https://hooks.slack.com/services/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',
        "#dev",
        username: "dev",
        iconEmoji: ":doge2:",
        enableApplicationParameters: true,
        enableCustomParameters: true,
        enableStackTrace: false,
        printLogs: true,
      ),
    ],
    customParameters: {
      "Build Mode": kReleaseMode ? 'release' : 'debug',
      "Platform": platform,
    },
  );
}

Future<List<ChatRoomModel>> processRoomsQuery(
  String uid,
  QuerySnapshot query,
) async {
  final futures = query.docs.map((doc) async {
    String? name;
    try {
      name = doc.get('name') as String?;
    } catch (e) {}
    final type = doc.get('type') as String;
    late List userIds;
    if (type == 'open') {
      userIds = doc.get('openUserIds') as List<dynamic>;
    } else {
      userIds = doc.get('userIds') as List<dynamic>;
    }

    final users = userIds.map((userId) => ChatUserModel(nickname: userId)).toList();
    if (type == 'direct') {
      try {
        final otherUser = users.firstWhere(
          (u) => u.nickname != uid,
        );

        name = otherUser.nickname;
      } catch (e) {}
    }
    try {
      var lastItem = (await FirebaseFirestore.instance.collection('rooms/${doc.id}/messages').orderBy("createdAt", descending: true).limit(1).get()).docs.first;

      String lastChat = '';
      if (lastItem['type'] == 'text') {
        lastChat = lastItem['text'] ?? '';
      } else if (lastItem['type'] == 'image') {
        lastChat = 'Image';
      } else {
        lastChat = '';
      }

      final room = ChatRoomModel(
        id: doc.id,
        type: checkRoomType(type),
        users: users,
        name: name,
        lastMsg: lastChat,
      );

      return room;
    } catch (e) {
      return ChatRoomModel(
        id: doc.id,
        type: checkRoomType(type),
        users: users,
        name: name,
      );
    }
  });

  return await Future.wait(futures);
}

Future<ChatUserModel> fetchUser(String nick) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(nick).get();
  return processUserDocument(doc);
}

ChatUserModel processUserDocument(DocumentSnapshot doc) {
  final nickname = doc.get('nickname') as String?;

  final user = ChatUserModel(
    nickname: nickname,
  );

  return user;
}

RoomType checkRoomType(String type) {
  switch (type) {
    case 'direct':
      return RoomType.direct;
    case 'group':
      return RoomType.group;
    case 'open':
      return RoomType.open;
    default:
      return RoomType.none;
  }
}

ChatMessageType checkMessageType(String type) {
  switch (type) {
    case 'text':
      return ChatMessageType.text;
    case 'image':
      return ChatMessageType.image;
    case 'file':
      return ChatMessageType.file;
    case 'video':
      return ChatMessageType.video;
    default:
      return ChatMessageType.none;
  }
}

void showToast(String msg, {ToastGravity? gravity = ToastGravity.BOTTOM}) {
  Fluttertoast.showToast(msg: msg, gravity: gravity, backgroundColor: Colors.white, textColor: Colors.black);
}

Future<XFile?> cPickImageFile({double? maxWidth, double? maxHeight, int imageQuality = 100}) async {
  XFile? xFile;
  const size10mb = 10485760;
  final ImagePicker _imagePicker = ImagePicker();

  try {
    if (maxWidth == null && maxHeight == null) {
      xFile = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: imageQuality);
    } else if (maxWidth != null && maxHeight == null) {
      xFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, imageQuality: imageQuality);
    } else if (maxWidth == null && maxHeight != null) {
      xFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxHeight: maxHeight, imageQuality: imageQuality);
    } else {
      xFile = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight, imageQuality: imageQuality);
    }

    if (xFile == null) {
      return null;
    }

    int pickedFileSize = File(xFile.path).lengthSync();
    if (size10mb < pickedFileSize) {
      showToast('10MB 이상의 파일은 업로드 할 수 없습니다.');
      return null;
    }
  } catch (e) {
    lo('cPickImageFile Error ${xFile?.path} $e');
  }

  return xFile;
}
