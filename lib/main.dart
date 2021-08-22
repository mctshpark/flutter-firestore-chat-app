import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_chat_flutter/modules/widgets/anti_glow.dart';
import 'package:open_chat_flutter/routes/app_pages.dart';
import 'package:open_chat_flutter/service/user_service.dart';
import 'package:open_chat_flutter/utils/base_view_import.dart';
import 'package:open_chat_flutter/utils/common_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(UserService());
  Catcher(rootWidget: const MyApp(), debugConfig: slackCatCherConfig(), releaseConfig: slackCatCherConfig());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: () => GetMaterialApp(
        themeMode: ThemeMode.light,
        theme: lightTheme(),
        builder: (context, child) => _myAppBuilder(context, child),
        getPages: AppPages.routes,
        initialRoute: AppPages.Initial,
        defaultTransition: Transition.cupertino,
      ),
    );
  }

  Widget _myAppBuilder(BuildContext context, Widget? child) {
    child = MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: ScrollConfiguration(
        behavior: AntiGlow(),
        child: child ?? Container(),
      ),
    );
    return child;
  }

  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      dividerColor: const Color.fromRGBO(255, 255, 255, 0.1),
      textSelectionTheme: const TextSelectionThemeData().copyWith(
        cursorColor: cBlack085,
        selectionHandleColor: cBlack085,
      ),
      inputDecorationTheme: const InputDecorationTheme(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          labelStyle: TextStyle(color: primaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
      ),
    );
  }
}
