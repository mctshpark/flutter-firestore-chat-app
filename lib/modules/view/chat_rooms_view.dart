import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_chat_flutter/data/model/chat_room_model.dart';
import 'package:open_chat_flutter/modules/view/chat_rooms_ctr.dart';
import 'package:open_chat_flutter/modules/widgets/c_tab_view.dart';
import 'package:open_chat_flutter/modules/widgets/c_text.dart';
import 'package:open_chat_flutter/modules/widgets/chat_type_bottom_sheet.dart';
import 'package:open_chat_flutter/routes/app_pages.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChatRoomsView extends StatelessWidget {
  const ChatRoomsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<ChatRoomsCtr>(
          init: ChatRoomsCtr(),
          builder: (controller) {
            return CTabView(
              tabBar: TabBar(
                labelColor: Colors.white,
                indicatorColor: Colors.red,
                isScrollable: true,
                tabs: const [
                  Tab(text: '오픈 채팅'),
                  Tab(text: '일반 채팅'),
                ],
                onTap: (value) {},
              ),
              widgets: [
                openRoom(controller),
                groupRoom(controller),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget openRoom(ChatRoomsCtr controller) {
    return StreamBuilder<List<ChatRoomModel>?>(
      stream: controller.openRooms(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              isExtended: true,
              child: const Icon(Icons.chat),
              onPressed: () {
                Get.bottomSheet(const ChatTypeBottomSheet());
              },
            ),
            body: Container(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              isExtended: true,
              child: const Icon(Icons.chat),
              onPressed: () {
                Get.bottomSheet(const ChatTypeBottomSheet());
              },
            ),
            body: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No rooms'),
            ),
          );
        }

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            isExtended: true,
            child: const Icon(Icons.chat),
            onPressed: () {
              Get.bottomSheet(const ChatTypeBottomSheet());
            },
          ),
          body: ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              ChatRoomModel data = snapshot.data![index];
              return ListTile(
                title: ChatRoomTitle(title: data.name ?? '', type: data.type),
                subtitle: CText(data.lastMsg ?? ''),
                onTap: () async {
                  await Get.toNamed(Routes.ChattingView, arguments: {'roomId': data.id});
                  controller.update();
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget groupRoom(ChatRoomsCtr controller) {
    return StreamBuilder<List<ChatRoomModel>?>(
      stream: controller.groupRooms(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              isExtended: true,
              child: const Icon(Icons.chat),
              onPressed: () {
                Get.bottomSheet(const ChatTypeBottomSheet());
              },
            ),
            body: Container(),
          );
        }

        if (snapshot.data!.isEmpty) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              isExtended: true,
              child: const Icon(Icons.chat),
              onPressed: () {
                Get.bottomSheet(const ChatTypeBottomSheet());
              },
            ),
            body: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                bottom: 200,
              ),
              child: const Text('No rooms'),
            ),
          );
        }
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            isExtended: true,
            child: const Icon(Icons.chat),
            onPressed: () {
              Get.bottomSheet(const ChatTypeBottomSheet());
            },
          ),
          body: ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              ChatRoomModel data = snapshot.data![index];
              return ListTile(
                title: ChatRoomTitle(title: data.name ?? '', type: data.type),
                subtitle: CText(data.lastMsg ?? ''),
                onTap: () async {
                  await Get.toNamed(Routes.ChattingView, arguments: {'roomId': data.id});
                  controller.update();
                },
              );
            },
          ),
        );
      },
    );
  }
}

class ChatRoomTitle extends StatelessWidget {
  final String title;
  final RoomType type;

  const ChatRoomTitle({Key? key, required this.title, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CText(title, fontSize: 20.sp),
        SizedBox(width: 5.w),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: primaryColor,
          ),
          child: CText(describeEnum(type).toUpperCase(), color: cWhite),
        ),
      ],
    );
  }
}
