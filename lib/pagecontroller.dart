import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:savebills/provider/adsProvider.dart';

import 'constant.dart';
import 'js_handler.dart';

class Pagecontroller extends GetxController with WidgetsBindingObserver {

  GoogleSignInAccount? currentUser;
  var contactText = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        currentUser = account;
        update();
      if (currentUser != null) {
        handleGetContact(currentUser!);
      }
    });
    googleSignIn.signInSilently();
  }




  void start() {
    // TODO: implement initState
    // flutterDownload();
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   setState(() {
    //     showgoogleadvert();
    //   });
    // });

    // timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
    //   Get.find<AdsProvider>().showads();
    // });

    for (int i = 0; i < bottomicon.length; i++) {
      if (url == bottomurl[i]) {
        selected.value = i;
      }
    }
    WidgetsBinding.instance.addObserver(this);
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid)
              ? contextMenuItemClicked.androidId
              : contextMenuItemClicked.iosId;
          print(
              "onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  var urll = "".obs;
  var webViewKey = GlobalKey();

var tabNavigationEnabled = false.obs;

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          useOnDownloadStart: true),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  var progresss = 0.0;
  var isLoading = true.obs;
  DateTime? currentBackPressTime;

  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      webViewController?.goBack();
      return Future.value(false);
    }
    return Future.value(true);
  }

  var url = "https://savebills.com.ng".obs;
  // var url = "".obs;
  final key = UniqueKey();

  Future<bool> exitApp(BuildContext context) async {
    if (await webViewController!.canGoBack()) {
      print("on will goback");
      webViewController!.goBack();
      return Future.value(false);
    } else {
      print("No back history item");
      return Future.value(true);
    }
  }


  Future<void> flutterDownload() async {
    // Plugin must be initialized before using
    await FlutterDownloader.initialize(
        debug:
            false, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl:
            true // option: set to false to disable working with http links (default: false)
        );
  }

  late Timer timer;
  var selected = 0.obs;
  var isloaded = false.obs;
  var issplashscreen = true.obs;

  void handleSubmitted(String text) async {
    textController.value.clear();
    url.value = text;
    start();
  }

  var istext = false.obs;
  var textController = TextEditingController().obs;

  void splashscreen() {
    Timer(const Duration(seconds: 4), () async {
      issplashscreen.value = false;
    });
  }
}

const edittextbodercolour = 0xFF1B5E20;

GoogleSignIn googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
