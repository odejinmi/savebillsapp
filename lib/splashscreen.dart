import 'dart:async';

import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:universal_platform/universal_platform.dart';

import 'constant.dart';
import 'newmac.dart';
import 'web_view_container.dart';
import 'window.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    WebviewWindow.isWebviewAvailable().then((value) {
      setState(() {
        webviewAvailable = value;
      });
    });
    Timer(const Duration(seconds:  3), () async {
      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        Get.to(()=> WebViewContainer(lasturl.toString()));
      } else if (UniversalPlatform.isWindows) {
        Get.to(()=> Window(url: lasturl.toString()));
      } else {
        Get.to(()=> const Newmac());
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(80),
      color: primarycolor,
      child: Center(
              child: Image.asset('asset/logo.png'),
            ),
    );
  }
}
