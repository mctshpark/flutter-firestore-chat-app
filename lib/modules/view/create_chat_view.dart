import 'package:open_chat_flutter/data/model/chat_user_model.dart';
import 'package:open_chat_flutter/modules/view/create_chat_ctr.dart';
import 'package:open_chat_flutter/modules/widgets/basic_app_bar.dart';
import 'package:open_chat_flutter/modules/widgets/user_avatar.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class CreateChatView extends StatelessWidget {
  const CreateChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: GetBuilder<CreateChatCtr>(
            init: CreateChatCtr(),
            builder: (controller) {
              return Scaffold(
                appBar: BasicAppbar(
                  title: '대화상대 초대',
                  action: controller.selectedUsers.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.done),
                            onPressed: () async {
                              controller.createChat(controller.selectedUsers);
                            },
                          ),
                        ]
                      : null,
                ),
                body: StreamBuilder<List<ChatUserModel>>(
                  stream: controller.users(),
                  initialData: const [],
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          bottom: 200,
                        ),
                        child: const Text('No users'),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final user = snapshot.data![index];
                        return ListTile(
                          leading: Container(
                            margin: EdgeInsets.only(bottom: 10.h, top: 10.h),
                            child: UserAvatar(),
                          ),
                          selected: controller.selectedUsers.contains(user.nickname),
                          title: CText('${user.nickname ?? ''}'),
                          selectedTileColor: Colors.blue.withOpacity(0.5),
                          onTap: () {
                            controller.selectUser(user.nickname ?? '');
                          },
                        );
                      },
                    );
                  },
                ),
              );
            }),
      ),
    );
  }
}
