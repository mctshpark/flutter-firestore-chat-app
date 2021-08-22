import 'package:get/get.dart';
import 'package:open_chat_flutter/modules/view/chat_rooms_view.dart';
import 'package:open_chat_flutter/modules/view/chatting_view.dart';
import 'package:open_chat_flutter/modules/view/create_chat_view.dart';
import 'package:open_chat_flutter/modules/view/create_open_chat_view.dart';
import 'package:open_chat_flutter/modules/view/sign_in_view.dart';
import 'package:open_chat_flutter/modules/widgets/edit_image_view.dart';
import 'package:open_chat_flutter/modules/widgets/slide_out_image_view.dart';

part 'app_routes.dart';

const Duration pageAnimationDuration = Duration(milliseconds: 210);

class AppPages {
  static const Initial = Routes.SignInView;

  static final routes = [
    GetPage(
      name: Routes.SignInView,
      page: () => const SignInView(),
      transitionDuration: pageAnimationDuration,
      gestureWidth: (context) => Get.width * 0.5,
    ),
    GetPage(
      name: Routes.ChatRoomsView,
      page: () => const ChatRoomsView(),
      transitionDuration: pageAnimationDuration,
      gestureWidth: (context) => Get.width * 0.5,
    ),
    GetPage(
      name: Routes.CreateChatView,
      page: () => const CreateChatView(),
      transitionDuration: pageAnimationDuration,
      gestureWidth: (context) => Get.width * 0.5,
    ),
    GetPage(
      name: Routes.CreateOpenChatView,
      page: () => CreateOpenChatView(),
      transitionDuration: pageAnimationDuration,
      gestureWidth: (context) => Get.width * 0.5,
    ),
    GetPage(
      name: Routes.ChattingView,
      page: () => ChattingView(),
      transitionDuration: pageAnimationDuration,
      gestureWidth: (context) => Get.width * 0.5,
    ),
    GetPage(
      name: Routes.EditImageView,
      page: () => const EditImageView(),
      transitionDuration: pageAnimationDuration,
      gestureWidth: (context) => Get.width * 0.5,
    ),
    GetPage(
      name: Routes.SlideOutImageView,
      page: () => const SlideOutImageView(),
      transitionDuration: Duration.zero,
      gestureWidth: (context) => Get.width * 0.5,
      opaque: false,
      transition: Transition.noTransition,
      fullscreenDialog: true,
    ),
    GetPage(
      name: Routes.EditImageView,
      page: () => const EditImageView(),
      transitionDuration: pageAnimationDuration,
    ),
  ];
}
