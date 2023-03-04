import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:savebills/pagecontroller.dart';
import 'package:savebills/provider/adsProvider.dart';
import 'package:savebills/spinningwheel/spinningwheel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_settings/app_settings.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:in_app_review/in_app_review.dart';
import 'functions/deviceinfo.dart';

import 'functions/biometriclogin.dart';
import 'functions/contactselecting.dart';
import 'functions/location.dart';
import 'functions/sociallogin.dart';


final InAppReview _inAppReview = InAppReview.instance;
Future<void> _requestReview() => _inAppReview.requestReview();

Future<void> startJS(webViewController) async {
  var prefs = GetStorage();
  webViewController?.addJavaScriptHandler(
      handlerName: 'selectContact',
      callback: (args) async {

        PermissionStatus permission = await Permission.contacts.status;
        if (permission != PermissionStatus.granted &&
            permission != PermissionStatus.permanentlyDenied) {
          PermissionStatus permissionStatus =
              await Permission.contacts.request();

          if (permissionStatus == PermissionStatus.granted) {
            print("Permission granted");
            return selectContact();
          } else {
            print("Permission not granted");
            return {"success": false, 'message': "Permission not granted"};
          }
        } else {
          PermissionStatus permissionStatus =
              await Permission.contacts.request();
          if (permissionStatus == PermissionStatus.granted) {
            print("Permission granted");
            return selectContact();
          } else {
            print("Permission not granted");
            return {"success": false, 'message': "Permission not granted"};
          }
        }
      });


  webViewController?.addJavaScriptHandler(
      handlerName: 'appSettings',
      callback: (args) {
        AppSettings.openAppSettings();

        return {"success": true};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'deviceInfo',
      callback: (args) async {
        var resp = await initPlatformState();
        return {"success": true, "data": resp};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'share',
      callback: (args) {
        Share.share(args[0], subject: 'Web2App');

        return {"success": true};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric',
      callback: (args) {
        return authenticateWithBiometrics(prefs);
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_stop',
      callback: (args) {
        cancelAuthentication();
        return {"success": true, "message": "Authentication cancelled"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_available',
      callback: (args) {
        getAvailableBiometrics();
        return {
          "success": true,
          "message": "Authentication cancelled",
          'data': availableBiometrics
        };
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_check',
      callback: (args) async {
        var auth = prefs.read("auth");
        bool cb = await checkBiometrics();
        bool aut = auth != null ? true : false;
        return {
          "success": true,
          "data": {"biometric": cb, "auth": aut}
        };
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_saveauth',
      callback: (args) async {
        await prefs.write("auth", jsonEncode(args[0]));
        return {"success": true, "message": "Auth saved"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'appReview',
      callback: (args) async {
        _requestReview();
        return {"success": true, 'message': "App review requested"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'geoLocation',
      callback: (args) async {

        return getCurrentPosition(1);
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'geoAddress',
      callback: (args) async {

        return getCurrentPosition(2);
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'islogin',
      callback: (args) async {
        Get.find<Pagecontroller>().tabNavigationEnabled.value = true;
        return {"success": true, 'message': "Devise has login"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'islogout',
      callback: (args) async {
        Get.find<Pagecontroller>().tabNavigationEnabled.value = false;
        return {"success": true, 'message': "Devise has logout"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'showinterstitial',
      callback: (args) async {
        Get.find<AdsProvider>().showads();
        return {"success": true, 'message': "Devise has login"};
      });

 webViewController?.addJavaScriptHandler(
      handlerName: 'showbanner',
      callback: (args) async {
        if(Get.find<AdsProvider>().isadvertready()) {
          Get.dialog(
              AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Spacer(),
                        IconButton(onPressed: () {
                          Get.find<AdsProvider>().removebanner();
                          Get.back();
                        }, icon: const Icon(Icons.close))
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Get.find<AdsProvider>().banner(),
                  ],
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
              )
          );
        }
        return {"success": true, 'message': "Devise has login"};
      });

 webViewController?.addJavaScriptHandler(
      handlerName: 'copy',
      callback: (args) async {
        Clipboard.setData(ClipboardData(text: args[0]));
        return {"success": true, 'message': "Devise has copy"};
      });


 webViewController?.addJavaScriptHandler(
      handlerName: 'googlesignin',
      callback: (args) async {
        // login();
        var answer = await signInWithGoogle();
        return {"success": true, 'message': "Signin successfully",
          "data": answer.additionalUserInfo!.profile};
      });

 webViewController?.addJavaScriptHandler(
      handlerName: 'googlesignout',
      callback: (args) async {
        signOutWithGoogle();
        return {"success": true, 'message': "Signout successfully",};
      });

 webViewController?.addJavaScriptHandler(
      handlerName: 'githubsignin',
      callback: (args) async {
        // login();
        var answer = await signInWithGitHub();
        return {"success": true, 'message': "Signin successfully",
          "data": answer.additionalUserInfo!.profile};
      });


  webViewController?.addJavaScriptHandler(
      handlerName: 'subscribePushNotification',
      callback: (args) async {
        print("start subscribePushNotification");
        print(args);

        await FirebaseMessaging.instance.subscribeToTopic(args[0].toString());
        return {"success": true, 'message': "Subscribed successfully"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'unsubscribePushNotification',
      callback: (args) async {
        print("start unsubscribePushNotification");
        print(args);

        await FirebaseMessaging.instance.unsubscribeFromTopic(args[0].toString());
        return {"success": true, 'message': "unSubscribed successfully"};
      });
  webViewController?.addJavaScriptHandler(
      handlerName: 'spinandwin',
      callback: (args) async {
        print("start spin and win");
        print(args);

        Get.to(()=>Spinningwheel(token: args[0]["token"]??"1380001|5xfpeJUtI3FXLaOR43f32PI7Wjjz2HfYVRoEsUev"));
      });
}

showmessage(message){
  Get.snackbar("Mega Cheap Data", message.toString(),
      duration: const Duration(seconds: 4),
// icon: Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      mainButton: TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("CLOSE")));
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
