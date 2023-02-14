import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savebills/inputaddress.dart';
import 'package:savebills/splashscreen.dart';
import 'package:savebills/web_view_container.dart';

import 'pagecontroller.dart';
import 'provider/googleProvider.dart';

class Landingpage extends StatelessWidget {
  Landingpage({super.key});

var controller = Get.put(Pagecontroller());
  var googleadvert = Get.put(GoogleProvider(), permanent: true);
  
  @override
  Widget build(BuildContext context) {
    return Obx(() {
        return controller.url.isEmpty
            ? Inputaddress()
            : Stack(
                children: [
                  const WebViewContainer(),
                  Visibility(
                    visible: !controller.isloaded.value || controller.issplashscreen.value,
                    child: const Splashscreen(),
                  ),
                ],
              );
      },
    );
  }
}
