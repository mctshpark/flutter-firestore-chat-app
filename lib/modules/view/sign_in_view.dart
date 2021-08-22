import 'package:flutter/cupertino.dart';
import 'package:open_chat_flutter/modules/view/sign_in_ctr.dart';
import 'package:open_chat_flutter/modules/widgets/c_button.dart';
import 'package:open_chat_flutter/modules/widgets/c_text.dart';
import 'package:open_chat_flutter/modules/widgets/suffix_loading.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: GetBuilder<SignInCtr>(
            init: SignInCtr(),
            builder: (controller) {
              return Scaffold(
                body: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      margin: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: controller.idTc,
                            decoration: const InputDecoration(
                              labelText: '아이디',
                              border: OutlineInputBorder(),
                              suffixIcon: SuffixLoading(),
                            ),
                            onChanged: (text) {
                              controller.nick.value = text;
                            },
                          ),
                          SizedBox(height: 10.h),
                          TextField(
                            controller: controller.pwTc,
                            decoration: InputDecoration(
                              labelText: '비밀번호',
                              border: const OutlineInputBorder(),
                              errorText: (controller.checkPw ?? true) ? null : '비밀번호가 틀렸습니다.',
                            ),
                            onChanged: (text) {
                              controller.pw.value = text;
                            },
                          ),
                          Obx(
                            () => CButton(
                              margin: EdgeInsets.only(top: 10.h),
                              style: CButtonStyle.basic,
                              height: 60.h,
                              onTap: () => controller.trySignIn(),
                              isDisabled: controller.isDisable.value,
                              color: primaryColor,
                              child: const CText('확인'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
