import 'package:open_chat_flutter/modules/view/create_open_chat_ctr.dart';
import 'package:open_chat_flutter/modules/widgets/basic_app_bar.dart';
import 'package:open_chat_flutter/modules/widgets/suffix_loading.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class CreateOpenChatView extends StatelessWidget {
  CreateOpenChatView({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<CreateOpenChatCtr>(
          init: CreateOpenChatCtr(),
          builder: (controller) {
            return Scaffold(
              appBar: const BasicAppbar(title: '오픈 채팅방 개설'),
              body: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 20.h),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(
                            () => TextFormField(
                              decoration: InputDecoration(
                                labelText: '채팅방 명',
                                border: const OutlineInputBorder(),
                                suffixIcon: SuffixLoading(busy: controller.isRoomBusy),
                                errorText: controller.isError.value ? '이미 존재하는 방이름 입니다.' : null,
                              ),
                              validator: (value) {},
                              onChanged: (text) {
                                controller.roomName.value = text;
                              },
                            ),
                          ),
                          Obx(
                            () => CButton(
                              margin: EdgeInsets.only(top: 10.h),
                              style: CButtonStyle.basic,
                              height: 60.h,
                              isDisabled: controller.isError.value,
                              color: primaryColor,
                              onTap: () async {
                                await controller.createOpenChat();
                                Get.back();
                              },
                              child: const CText('확인'),
                            ),
                          ),
                          controller.ss.loading,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
