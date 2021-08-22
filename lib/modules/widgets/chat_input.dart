import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:open_chat_flutter/modules/view/chatting_ctr.dart';
import 'package:open_chat_flutter/modules/widgets/round_box.dart';
import 'package:open_chat_flutter/service/state_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

class ChatInput extends StatefulWidget {
  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _chatCtr = Get.find<ChattingCtr>();
  final ss = Get.find<StateService>();
  final _textController = TextEditingController();
  bool _sendButtonVisible = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _textController.addListener(() {
      setState(() {
        _sendButtonVisible = _textController.text != '';
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 20.h,
                      bottom: 20.h + MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
                    ),
                    child: Row(
                      children: [
                        Visibility(
                          visible: !kIsWeb,
                          child: InkWell(
                            onTap: () async {
                              _chatCtr.isBottomMenuHide.value = !_chatCtr.isBottomMenuHide.value;
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 15.w + MediaQuery.of(context).padding.left, right: 10.w),
                              child: const Icon(
                                Icons.add_box,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _textController,
                            focusNode: _focusNode,
                            cursorHeight: 23.h,
                            decoration: const InputDecoration.collapsed(hintText: ''),
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            minLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Stack(
                    children: [
                      Visibility(
                        visible: _sendButtonVisible && ss.isIdle,
                        child: InkWell(
                          onTap: () async {
                            await _chatCtr.sendMessage(_textController.text);
                            _textController.clear();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                            child: Icon(
                              Icons.send,
                              color: Colors.black,
                              size: 24.w,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: ss.isBusy,
                        child: Container(
                          margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h, bottom: 10.h),
                          width: 30.w,
                          height: 30.w,
                          child: const CLoading(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () => Visibility(
                visible: !_chatCtr.isBottomMenuHide.value,
                child: Container(
                  width: Get.width,
                  height: 80.h,
                  child: Column(
                    children: [
                      _item(
                        title: '앨범',
                        onTap: () async {
                          var result = await cPickImageFile(maxWidth: 720, maxHeight: 720, imageQuality: 70);
                          if (result != null) {
                            try {
                              ss.busy();
                              final file = File(result.path);
                              final imageName = result.path.split('/').last;
                              final reference = FirebaseStorage.instance.ref(imageName);
                              await reference.putFile(file);
                              final uri = await reference.getDownloadURL();
                              _chatCtr.sendImageMessage(uri);

                              ss.idle();
                            } on FirebaseException catch (e) {
                              ss.idle();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item({required String title, required VoidCallback onTap}) {
    return RoundBox(
      height: 56.h,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.h),
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      color: primaryColor,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: CText(
              title,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
