import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String title;
  final String message;
  final String positiveBtnText;
  final String negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    this.title = "",
    this.message = "",
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText = "",
    this.negativeBtnText = "",
    this.onPostivePressed,
    this.onNegativePressed,
  })  : assert(bgColor != null),
        assert(circularBorderRadius != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Text(message),
      ),
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        Visibility(
          visible: negativeBtnText != "",
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              //   // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
              //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.all(Radius.circular(10)),
              //           // side: BorderSide(color: Colors.red)
              //         ))
            ),
            child: Text(
              negativeBtnText,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            // textColor: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(context).pop();
              if (onNegativePressed != null) {
                onNegativePressed!();
              }
            },
          ),
        ),
        Visibility(
          visible: positiveBtnText != "",
          child: ElevatedButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              // foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              // shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //     RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(120)),
              //       // side: BorderSide(color: Colors.red)
              //     ))
            ),
            child: Text(
              positiveBtnText != null ? positiveBtnText : " ",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            // textColor: Theme.of(context).accentColor,
            onPressed: () {
              if (onPostivePressed != null) {
                onPostivePressed!();
              }
            },
          ),
        )
      ],
    );
  }
}

CustomAlertDialogloader(
    {String? title,
    String? message,
    String? negativeBtnText,
    String positiveBtnText = "",
    Function? onPostivePressed,
    Function? onNegativePressed}) {
  Get.dialog(CustomAlertDialog(
      title: title!,
      message: message!,
      onPostivePressed: onPostivePressed,
      positiveBtnText: positiveBtnText,
      onNegativePressed: onNegativePressed,
      negativeBtnText: negativeBtnText ?? ""));
}
