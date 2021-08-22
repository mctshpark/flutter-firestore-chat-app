import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_chat_flutter/data/model/chat_room_model.dart';
import 'package:open_chat_flutter/data/model/chat_user_model.dart';
import 'package:open_chat_flutter/routes/app_pages.dart';
import 'package:open_chat_flutter/service/user_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class CreateChatCtr extends GetxController {
  final userService = Get.find<UserService>();

  final selectedUsers = [];

  Stream<List<ChatUserModel>> users() {
    return FirebaseFirestore.instance.collection('users').where('nickname', isNotEqualTo: userService.userId).snapshots().map(
          (snapshot) => snapshot.docs.fold<List<ChatUserModel>>(
            [],
            (previousValue, element) {
              if (userService.userId == element.id) return previousValue;

              return [...previousValue, processUserDocument(element)];
            },
          ),
        );
  }

  Future<void> createChat(List otherUser) async {
    if (otherUser.length == 1) {
      final room = await createDirectRoom(ChatUserModel(nickname: otherUser[0]));
      Get.back();
      Get.toNamed(Routes.ChattingView, arguments: {'roomId': room.id});
    } else if ((otherUser.length > 1)) {
      final room = await createGroupRoom(otherUser.map((e) => ChatUserModel(nickname: e)).toList());
      Get.back();
      Get.toNamed(Routes.ChattingView, arguments: {'roomId': room.id});
    }
  }

  Future<ChatRoomModel> createDirectRoom(ChatUserModel otherUser) async {
    final query = await FirebaseFirestore.instance.collection('rooms').where('userIds', arrayContains: userService.userId).get();

    final rooms = await processRoomsQuery(userService.userId, query);

    try {
      return rooms.firstWhere((room) {
        if (room.type == RoomType.direct) {
          final userIds = room.users.map((u) => u.nickname);
          return userIds.contains(userService.userId) && userIds.contains(otherUser.nickname);
        }
        return false;
      });
    } catch (e) {}

    final currentUser = ChatUserModel(nickname: userService.userId);
    final users = [currentUser, otherUser];

    final room = await FirebaseFirestore.instance.collection('rooms').add({
      'imageUrl': null,
      'name': otherUser.nickname,
      'type': 'direct',
      'userIds': users.map((u) => u.nickname).toList(),
    });

    return ChatRoomModel(
      id: room.id,
      type: RoomType.direct,
      users: users,
    );
  }

  Future<ChatRoomModel> createGroupRoom(List<ChatUserModel> otherUser) async {
    final query = await FirebaseFirestore.instance.collection('rooms').where('userIds', arrayContains: userService.userId).get();

    final rooms = await processRoomsQuery(userService.userId, query);

    try {
      return rooms.firstWhere((room) {
        if (room.type == RoomType.group) {
          final userIds = room.users.map((u) => u.nickname);
          return userIds.contains(userService.userId) && otherUser.every((e) => userIds.contains(e.nickname));
        }
        return false;
      });
    } catch (e) {}

    final currentUser = ChatUserModel(nickname: userService.userId);
    List<ChatUserModel> users = [currentUser, ...otherUser];
    final room = await FirebaseFirestore.instance.collection('rooms').add({
      'imageUrl': null,
      'name': users.map((e) => e.nickname).toList().join(", "),
      'type': 'group',
      'userIds': users.map((u) => u.nickname).toList(),
    });

    return ChatRoomModel(
      id: room.id,
      type: RoomType.group,
      users: users,
    );
  }

  void selectUser(String nickname) {
    if (selectedUsers.contains(nickname)) {
      selectedUsers.remove(nickname);
    } else {
      selectedUsers.add(nickname);
    }
    update();
  }
}
