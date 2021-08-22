import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_chat_flutter/data/model/chat_user_model.dart';
import 'package:open_chat_flutter/routes/app_pages.dart';
import 'package:open_chat_flutter/service/state_service.dart';
import 'package:open_chat_flutter/service/user_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class SignInCtr extends GetxController {
  final ss = Get.put(StateService());
  final userService = Get.find<UserService>();
  TextEditingController idTc = TextEditingController();
  TextEditingController pwTc = TextEditingController();

  RxString nick = ''.obs;
  RxString pw = ''.obs;

  RxBool get isDisable => (nick.value.isEmpty || pw.value.isEmpty).obs;
  bool? checkPw;

  @override
  void onClose() {
    idTc.dispose();
    pwTc.dispose();
    super.onClose();
  }

  Future<void> trySignIn() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where('nickname', isEqualTo: idTc.value.text).get();

      if (query.docs.isEmpty) {
        lo('생성');
        await createUser(ChatUserModel(nickname: idTc.value.text, pw: pwTc.value.text));
        checkPw = true;
        userService.userId = idTc.value.text;
        Get.offAndToNamed(Routes.ChatRoomsView);
        return;
      }
      if (await query.docs.first.get('pw') == pwTc.value.text) {
        checkPw = true;
        userService.userId = idTc.value.text;
        Get.offAndToNamed(Routes.ChatRoomsView);
      } else {
        checkPw = false;
      }
    } catch (e) {
      checkPw = null;
      lo('에러1 $e');
    }
    update();
  }

  Future<bool> isAvailableNickname(String openChatName) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where('nickname', isEqualTo: openChatName).get();
    if (query.docs.isNotEmpty) {
      return false;
    }
    return true;
  }

  Future<void> createUser(ChatUserModel user) async {
    await FirebaseFirestore.instance.collection('users').doc().set({
      'nickname': user.nickname,
      'pw': user.pw,
    });
  }
}
