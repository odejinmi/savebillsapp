import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:savebills/provider/adsProvider.dart';

import 'constant.dart';
import 'landingpage.dart';
import 'splashscreen.dart';
import 'package:flutter/material.dart';


final InAppLocalhostServer localhostServer = InAppLocalhostServer();

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // start the localhost server
  await localhostServer.start();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: Landingpage(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => AdsProvider(), fenix: true);
        // Get.lazyPut(() => ApiProvider(), fenix: true);
        // Get.find<VpnProvider>().initialize();
      }),
    );
  }
}

