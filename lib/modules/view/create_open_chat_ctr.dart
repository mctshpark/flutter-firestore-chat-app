import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_chat_flutter/service/state_service.dart';
import 'package:open_chat_flutter/service/user_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class CreateOpenChatCtr extends GetxController {
  RxBool isDisable = true.obs;
  final ss = Get.find<StateService>();
  final userService = Get.find<UserService>();
  RxString roomName = ''.obs;
  RxBool isError = false.obs;
  RxBool isRoomBusy = false.obs;

  @override
  void onInit() {
    debounce(roomName, (_) => validateRoomName(), time: const Duration(milliseconds: 500));
    super.onInit();
  }

  Future<void> validateRoomName() async {
    if (roomName.value.isEmpty) return;

    isRoomBusy.value = true;
    if ((await FirebaseFirestore.instance.collection('rooms').where('name', isEqualTo: roomName.value).get()).size > 0) {
      isError.value = true;
    } else {
      isError.value = false;
    }

    isRoomBusy.value = false;
  }

  Future<void> createOpenChat() async {
    try {
      ss.busy();
      await FirebaseFirestore.instance.collection('rooms').add({
        'name': roomName.value,
        'type': 'open',
        'openUserIds': [userService.userId],
      });
      ss.idle();
    } catch (e) {
      ss.idle();
    }
  }
}
