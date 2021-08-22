import 'package:open_chat_flutter/utils/base_view_import.dart';

class BasicAppbar extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final List<Widget>? action;
  const BasicAppbar({Key? key, this.title, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryColor,
      title: CText(
        title ?? '',
        color: cBlack,
        fontSize: 16.sp,
      ),
      elevation: 0.0,
      iconTheme: const IconThemeData(color: cBlack),
      actions: action,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60.h);
}
