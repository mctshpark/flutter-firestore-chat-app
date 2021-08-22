import 'package:open_chat_flutter/service/state_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class SuffixLoading extends StatelessWidget {
  final RxBool? busy;

  const SuffixLoading({Key? key, this.busy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Visibility(
        visible: busy == null ? Get.find<StateService>().isBusy : busy!.value,
        child: Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 15.w),
          child: SizedBox(
            width: 15.w,
            height: 15.w,
            child: const CircularProgressIndicator(
              strokeWidth: 1.5,
              color: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
