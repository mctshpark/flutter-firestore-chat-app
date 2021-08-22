import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';

enum ControllerState {
  superBusy,
  busy,
  idle,
  listBusy,
}

class StateService extends GetxService {
  Rx<ControllerState> state = ControllerState.idle.obs;

  bool get isBusy => state.value == ControllerState.busy || state.value == ControllerState.superBusy;

  bool get isIdle => state.value == ControllerState.idle;

  bool get isSuperBusy => state.value == ControllerState.superBusy;

  bool get isListBusy => state.value == ControllerState.listBusy;

  void superBusy() => state.value = ControllerState.superBusy;

  void listBusy() => state.value = ControllerState.listBusy;

  void busy() => state.value = ControllerState.busy;

  void idle() => state.value = ControllerState.idle;

  Widget get loading => _loading();

  Widget _loading() {
    return Obx(
      () => Visibility(
        visible: isBusy,
        child: Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            width: 45.w,
            height: 45.w,
            child: SizedBox(
              width: 45.w,
              height: 45.w,
              child: const CLoading(),
            ),
          ),
        ),
      ),
    );
  }
}

class CLoading extends StatelessWidget {
  const CLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    try {
      if (Platform.isIOS) {
        return const CupertinoActivityIndicator();
      }
    } catch (e) {}

    return const CircularProgressIndicator();
  }
}
