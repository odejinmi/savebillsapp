import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'constant.dart';
import 'pagecontroller.dart';
import 'web_view_container.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var pagecontroller = Get.put(Pagecontroller());
  // @override
  // void initState() {
  //   super.initState();

  // }

  @override
  Widget build(BuildContext context) {
    pagecontroller.splashscreen();
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
