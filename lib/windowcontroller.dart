import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';

class Windowcontroller extends GetxController {
  final controller = WebviewController().obs;
  // final textController = TextEditingController().obs;
  var isWebviewSuspended = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    try {
      await controller.value.initialize();
      // controller.value.url.listen((url) {
      //   textController.value.text = url;
      // });

      await controller.value.setBackgroundColor(Colors.transparent);
      await controller.value
          .setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await controller.value.loadUrl("www.5starcompany.com.ng");
      //
      // if (!mounted) return;
      // setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.defaultDialog(
            content: AlertDialog(
          title: const Text('Error'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Code: ${e.code}'),
              Text('Message: ${e.message}'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Get.back();
              },
            )
          ],
        ));
      });
    }
  }
}
