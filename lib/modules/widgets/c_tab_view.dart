import 'package:flutter/cupertino.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class CTabView extends StatelessWidget {
  final PreferredSizeWidget tabBar;
  final List<Widget> widgets;
  final TabController? tc;

  const CTabView({Key? key, required this.widgets, required this.tabBar, this.tc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tc != null) {
      return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              CupertinoIcons.chevron_back,
            ),
          ),
          elevation: 0,
          bottom: tabBar,
        ),
        body: TabBarView(
          controller: tc,
          children: widgets,
        ),
      );
    }
    return DefaultTabController(
      length: widgets.length,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Get.back(),
            child: const Icon(
              CupertinoIcons.chevron_back,
              color: Colors.black,
            ),
          ),
          elevation: 0,
          bottom: tabBar,
        ),
        body: TabBarView(
          children: widgets,
        ),
      ),
    );
  }
}
