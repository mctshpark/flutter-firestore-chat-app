import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_chat_flutter/data/model/chat_room_model.dart';
import 'package:open_chat_flutter/service/user_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChatRoomsCtr extends GetxController {
  Stream<List<ChatRoomModel>>? rooms;
  final userService = Get.find<UserService>();

  @override
  Future<void> onReady() async {
    rooms = openRooms();
    update();
    super.onReady();
  }

  Stream<List<ChatRoomModel>> openRooms() {
    return FirebaseFirestore.instance.collection('rooms').where('type', isEqualTo: 'open').snapshots().asyncMap(
          (query) => processRoomsQuery(userService.userId, query),
        );
  }

  Stream<List<ChatRoomModel>> groupRooms() {
    return FirebaseFirestore.instance.collection('rooms').where('userIds', arrayContains: userService.userId).snapshots().asyncMap((query) {
      return processRoomsQuery(userService.userId, query);
    });
  }
}
