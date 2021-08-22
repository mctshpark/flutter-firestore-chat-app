import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:open_chat_flutter/data/model/chat_message_model.dart';
import 'package:open_chat_flutter/data/model/chat_room_model.dart';
import 'package:open_chat_flutter/service/state_service.dart';
import 'package:open_chat_flutter/service/user_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChattingCtr extends GetxController {
  final userService = Get.find<UserService>();
  final ss = Get.find<StateService>();

  String anotherUserNickName = '';
  late String roomId;
  late StreamSubscription chatSubscription;
  late Rx<List<ChatMessageModel>> messages = Rx([]);
  late QueryDocumentSnapshot<Map<String, dynamic>> last;
  int limit = 50;
  bool isFinish = false;
  RxBool scrollBlock = false.obs;
  RxBool isBottomMenuHide = true.obs;

  @override
  void onInit() {
    roomId = Get.arguments['roomId'];
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    try {
      FirebaseFirestore.instance.collection('rooms').doc(roomId).get().then((value) {
        if (checkRoomType(value['type']) == RoomType.direct) {
          (value['userIds'] as List<dynamic>).forEach((element) {
            if (userService.userId != element.toString()) {
              FirebaseFirestore.instance.collection('users').doc('$element').get().then((value) {
                anotherUserNickName = value['nickname'];
                update();
              });
            }
          });
        }
      });

      chatSubscription = FirebaseFirestore.instance.collection('rooms/$roomId/messages').orderBy('createdAt', descending: true).limit(50).snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          last = event.docs[event.docs.length - 1];
        }

        update();
        messages.value = event.docs.map((e) => ChatMessageModel.fromJson(e.data())).toList();
      });
    } catch (e) {
      lo('Error : $e');
    }
  }

  @override
  void onClose() {
    chatSubscription.cancel();
    super.onClose();
  }

  Future<void> sendMessage(String text) async {
    ss.busy();
    await FirebaseFirestore.instance.collection('rooms/$roomId/messages').add({
      'type': describeEnum(ChatMessageType.text),
      'nickname': userService.userId,
      'text': text,
      'avatarUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
    ss.idle();
  }

  Future<void> sendImageMessage(String imageUrl) async {
    try {
      ss.busy();
      await FirebaseFirestore.instance.collection('rooms/$roomId/messages').add({
        'type': describeEnum(ChatMessageType.image),
        'nickname': userService.userId,
        'imageUrl': imageUrl,
        'avatarUrl': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      ss.idle();
    } catch (e) {
      showToast('요청에 실패했습니다.');
    }
  }

  Future<bool> nextData(ScrollNotification scrollInfo) async {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && scrollInfo.metrics.axis == Axis.vertical) {
      if (!scrollBlock.value && !isFinish) {
        scrollBlock.value = true;
        await addChatMessages();
        scrollBlock.value = false;
      }
    }
    return false;
  }

  Future<void> addChatMessages() async {
    try {
      await FirebaseFirestore.instance.collection('rooms/$roomId/messages').orderBy('createdAt', descending: true).startAfterDocument(last).limit(50).get().then((value) {
        if (value.docs.isEmpty) {
          isFinish = true;
        }
        last = value.docs.last;
        update();
        value.docs.forEach((e) {
          messages.value.add(ChatMessageModel.fromJson(e.data()));
        });
      });
    } catch (e) {}
  }
}
