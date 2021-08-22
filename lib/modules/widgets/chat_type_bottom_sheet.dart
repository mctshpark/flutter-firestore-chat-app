import 'package:open_chat_flutter/routes/app_pages.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChatTypeBottomSheet extends StatelessWidget {
  const ChatTypeBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.w),
          topRight: Radius.circular(15.w),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BottomSheetContainer(
                title: '일반채팅',
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CreateChatView);
                }),
            BottomSheetContainer(
                title: '오픈채팅',
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.CreateOpenChatView);
                }),
          ],
        ),
      ),
    );
  }
}

class BottomSheetContainer extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const BottomSheetContainer({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CButton(
      height: 56.h,
      padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 8.h),
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: CText(
          title,
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
