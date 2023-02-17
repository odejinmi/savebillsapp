import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constant.dart';
import 'pagecontroller.dart';
import 'provider/adsProvider.dart';
import 'web_view_container.dart';

class Bottomnavigation extends StatelessWidget {
  const Bottomnavigation({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var pagecontroller = Get.put(Pagecontroller());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (int i = 0; i < bottomicon.length; i++)
          Obx(() {
            return GestureDetector(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Icon(
                      bottomicon[i],
                      color: pagecontroller.selected.value == i
                          ? primarycolor
                          : Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      bottomtittle[i],
                      style: TextStyle(
                          color: pagecontroller.selected.value == i
                              ? primarycolor
                              : Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              onTap: () {
                if (pagecontroller.selected.value != i) {
                  pagecontroller.url.value = bottomurl[i];
                  pagecontroller.selected.value = i;
                  // Get.to(()=>const WebViewContainer());
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => WebViewContainer()));
                }
              },
            );
          })
      ],
    );
  }
}
