import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final Widget? widget;

  CustomAlertDialogWidget({this.widget});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: widget,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    );
  }
}

CustomAlertDialogWidgetloader({required Widget widget}) {
  Get.dialog(CustomAlertDialogWidget(
    widget: widget,
  ));
}
