import 'package:open_chat_flutter/data/model/chat_message_model.dart';
import 'package:open_chat_flutter/modules/view/chatting_ctr.dart';
import 'package:open_chat_flutter/modules/widgets/chat_input.dart';
import 'package:open_chat_flutter/modules/widgets/chat_message.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChattingView extends StatelessWidget {
  ChattingView({Key? key}) : super(key: key);
  final controller = Get.put(ChattingCtr());
  final ScrollController sc = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<ChattingCtr>(
          builder: (controller) {
            return Scaffold(
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  controller.nextData(scrollInfo);
                  return false;
                },
                child: Container(
                  color: const Color.fromRGBO(155, 187, 212, 1),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        Obx(
                          () => Expanded(
                            child: controller.messages.value.isEmpty
                                ? _emptyChat()
                                : GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      controller.isBottomMenuHide.value = true;
                                    },
                                    child: ListView.builder(
                                      reverse: true,
                                      itemCount: controller.messages.value.length,
                                      controller: sc,
                                      itemBuilder: (context, index) {
                                        ChatMessageModel currentItem = controller.messages.value[index];
                                        ChatMessageModel? prevItem = index != controller.messages.value.length - 1 ? controller.messages.value[index + 1] : null;

                                        DateTime? prevTime = prevItem?.createdAt?.toDate();
                                        DateTime? currentTime = currentItem.createdAt?.toDate();

                                        String currentMsg = currentItem.text ?? '';
                                        bool isMe = controller.messages.value[index].nickname == controller.userService.userId;
                                        bool diffDay = _checkDiffDay(currentTime: currentTime, prevTime: prevTime);

                                        lo('current ${currentItem.imageUrl}');
                                        return ChatMessage(
                                          text: currentMsg,
                                          currentItem: currentItem,
                                          isMe: isMe,
                                          isDiffDay: diffDay,
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        ChatInput(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _checkDiffDay({required DateTime? currentTime, required DateTime? prevTime}) {
    if (currentTime != null && prevTime != null) {
      return currentTime.day != prevTime.day;
    }
    return false;
  }

  Widget _emptyChat() {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        controller.isBottomMenuHide.value = true;
      },
      child: const SizedBox.expand(),
    );
  }
}
