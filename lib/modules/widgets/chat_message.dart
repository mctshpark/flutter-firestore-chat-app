import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:open_chat_flutter/data/model/chat_message_model.dart';
import 'package:open_chat_flutter/modules/widgets/c_provider_image.dart';
import 'package:open_chat_flutter/modules/widgets/user_avatar.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChatMessage extends StatelessWidget {
  final bool isMe;
  final bool isDiffDay;
  final ChatMessageModel currentItem;
  final String? text;

  const ChatMessage({
    required this.currentItem,
    this.isMe = true,
    this.text = '',
    this.isDiffDay = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDiffDay) {
      return Column(
        children: [
          DifferentDayLine(currentItem),
          isMe ? MyChat(currentItem: currentItem, text: text) : YourChat(currentItem: currentItem, text: text),
        ],
      );
    } else {
      return isMe ? MyChat(currentItem: currentItem, text: text) : YourChat(currentItem: currentItem, text: text);
    }
  }
}

class DifferentDayLine extends StatelessWidget {
  final ChatMessageModel currentItem;

  const DifferentDayLine(this.currentItem);

  @override
  Widget build(BuildContext context) {
    if (currentItem.createdAt?.toDate() == null) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10.h, top: 20.h),
      child: Row(
        children: [
          const SizedBox(width: 10),
          const Expanded(child: Divider(color: Colors.white)),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: CText('${DateFormat.yMMMMd().format(currentItem.createdAt!.toDate())}'),
          ),
          const Expanded(child: Divider(color: Colors.white)),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class MyChat extends StatelessWidget {
  final ChatMessageModel currentItem;
  final String? text;

  const MyChat({
    required this.currentItem,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    if (checkMessageType(currentItem.type ?? '') == ChatMessageType.text) {
      return Container(
        margin: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (currentItem.createdAt?.toDate() != null)
              CText(
                '${DateFormat.jm().format(currentItem.createdAt!.toDate())}',
                fontSize: 12,
                color: cBlack,
              ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: BoxConstraints(
                maxWidth: Get.width * 0.65,
              ),
              child: Text(
                text ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      );
    } else if (checkMessageType(currentItem.type ?? '') == ChatMessageType.image) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (currentItem.createdAt?.toDate() != null)
            Container(
              margin: const EdgeInsets.only(right: 3, bottom: 6),
              child: CText(
                '${DateFormat.jm().format(currentItem.createdAt!.toDate())}',
                fontSize: 12,
                color: cBlack,
              ),
            ),
          Container(
            width: 150,
            height: 150,
            margin: const EdgeInsets.only(top: 10, right: 15, bottom: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CProviderImage(
                width: 150,
                height: 150,
                url: currentItem.imageUrl ?? '',
                fit: BoxFit.cover,
                align: Alignment.center,
              ),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class YourChat extends StatelessWidget {
  final ChatMessageModel currentItem;
  final String? text;

  const YourChat({
    required this.currentItem,
    this.text = '',
  });

  @override
  Widget build(BuildContext context) {
    if (checkMessageType(currentItem.type ?? '') == ChatMessageType.text) {
      return Container(
        margin: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              size: 30,
              urlImage: currentItem.avatarUrl,
              margin: const EdgeInsets.only(left: 3, right: 5),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  '${currentItem.nickname ?? ''}',
                  color: Colors.white,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5, top: 5),
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 5, top: 5),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: BoxConstraints(
                        maxWidth: Get.width * 0.5,
                      ),
                      child: Text(
                        '$text',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    if (currentItem.createdAt?.toDate() != null)
                      CText(
                        '${DateFormat.jm().format(currentItem.createdAt!.toDate())}',
                        fontSize: 12,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    } else if (checkMessageType(currentItem.type ?? '') == ChatMessageType.image) {
      return Column(
        children: [
          Row(
            children: [
              UserAvatar(
                size: 35,
                urlImage: currentItem.avatarUrl,
                margin: const EdgeInsets.only(left: 8, right: 5),
              ),
              CText(
                '${currentItem.nickname ?? ''}',
                color: Colors.white,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 150,
                height: 150,
                margin: const EdgeInsets.only(top: 10, left: 50, bottom: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CProviderImage(
                    width: 150,
                    height: 150,
                    url: currentItem.imageUrl ?? '',
                    fit: BoxFit.cover,
                    align: Alignment.center,
                  ),
                ),
              ),
              if (currentItem.createdAt?.toDate() != null)
                Container(
                  margin: const EdgeInsets.only(left: 3, bottom: 6),
                  child: CText(
                    '${DateFormat.jm().format(currentItem.createdAt!.toDate())}',
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
