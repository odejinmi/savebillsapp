import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:savebills/pagecontroller.dart';
import 'package:url_launcher/url_launcher.dart';

import 'banner_admob.dart';
import 'bottomnavigation.dart';
import 'constant.dart';
import 'js_handler.dart';
import 'no_internet.dart';
import 'provider/adsProvider.dart';
import 'provider/googleProvider.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({Key? key}) : super(key: key);
  @override
  createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  var pagecontroller = Get.put(Pagecontroller());

  @override
  Widget build(BuildContext context) {
    pagecontroller.start();
    var initialSettings = InAppWebViewSettings();
    initialSettings.useOnDownloadStart = true;
    initialSettings.useOnLoadResource = true;
    initialSettings.useShouldOverrideUrlLoading = true;
    initialSettings.javaScriptCanOpenWindowsAutomatically = true;
    initialSettings.userAgent =
        "Mozilla/5.0 (Linux; Android 9; LG-H870 Build/PKQ1.190522.001) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36";
    initialSettings.transparentBackground = true;

    initialSettings.safeBrowsingEnabled = true;
    initialSettings.disableDefaultErrorPage = true;
    // initialSettings.supportMultipleWindows = true;
    initialSettings.verticalScrollbarThumbColor =
        const Color.fromRGBO(0, 0, 0, 0.5);
    initialSettings.horizontalScrollbarThumbColor =
        const Color.fromRGBO(0, 0, 0, 0.5);

    initialSettings.allowsLinkPreview = false;
    initialSettings.mediaPlaybackRequiresUserGesture = false;
    initialSettings.isFraudulentWebsiteWarningEnabled = true;
    initialSettings.disableLongPressContextMenuOnLinks = true;
    // initialSettings.allowingReadAccessTo = WebUri('file://$WEB_ARCHIVE_DIR/');
    return WillPopScope(
        onWillPop: () => pagecontroller.exitApp(context),
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: SpinKitCubeGrid(
                color: primarycolor,
                size: 50.0,
              ),
            ),
            overlayOpacity: 0.8,
            child: Container(
              margin: const EdgeInsets.only(top: 1),
              child: Column(
                children: [
                  Expanded(
                    child: InAppWebView(
                      key: GlobalKey(),
                      initialSettings: initialSettings,
                      // contextMenu: contextMenu,
                      initialUrlRequest:
                          URLRequest(url: WebUri(pagecontroller.url.value)),
                      // initialFile: "assets/index.html",
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      // initialOptions: options,
                      pullToRefreshController:
                          pagecontroller.pullToRefreshController,
                      onWebViewCreated: (controller) async {
                        pagecontroller.webViewController = controller;
                      },
                      onDownloadStartRequest:
                          (controller, downloadStartRequest) async {
                        print("onDownloadStart $downloadStartRequest");

                        await Permission.storage.request();

                        final taskId = await FlutterDownloader.enqueue(
                          url: downloadStartRequest.url.toString(),
                          savedDir:
                              (await getExternalStorageDirectory())?.path ?? "",
                          showNotification:
                              true, // show download progress in status bar (for Android)
                          openFileFromNotification:
                              true, // click on notification to open downloaded file (for Android)
                        );
                      },
                      onReceivedServerTrustAuthRequest:
                          (controller, challenge) async {
                        return ServerTrustAuthResponse(
                            action: ServerTrustAuthResponseAction.PROCEED);
                      },
                      onLoadStart: (controller, url) async {
                        pagecontroller.urll.value = url.toString();
                        context.loaderOverlay.show();

                        // inject javascript file from assets folder
                        await pagecontroller.webViewController
                            ?.injectJavascriptFileFromAsset(
                                assetFilePath: "asset/js_bridge.js");

                        startJS(pagecontroller.webViewController);
                      },
                      onPermissionRequest:
                          (controller, permissionRequest) async {
                        return PermissionResponse(
                            resources: permissionRequest.resources,
                            action: PermissionResponseAction.GRANT);
                      },
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
                        var uri = navigationAction.request.url!;

                        if (![
                          "http",
                          "https",
                          "file",
                          "chrome",
                          "data",
                          "javascript",
                          "about"
                        ].contains(uri.scheme)) {
                          if (await canLaunch(pagecontroller.urll.value)) {
                            // Launch the App
                            await launch(
                              pagecontroller.urll.value,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pagecontroller.pullToRefreshController.endRefreshing();
                        // context.loaderOverlay.hide();
                        if (pagecontroller.isLoading.value) {
                          setState(() {
                            pagecontroller.isLoading.value = false;
                            pagecontroller.isloaded.value = true;
                          });
                        }
                        pagecontroller.urll.value = url.toString();
                      },
                      onReceivedError: (controller, request, error) async {
                        var isForMainFrame = request.isForMainFrame ?? false;
                        if (!isForMainFrame) {
                          return;
                        }
                        pagecontroller.pullToRefreshController.endRefreshing();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => No_Internet()));
                      },
                      onLoadError: (controller, url, code, message) {
                        pagecontroller.pullToRefreshController.endRefreshing();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => No_Internet()));
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pagecontroller.pullToRefreshController
                              .endRefreshing();
                        }
                        if (progress >= 60) {
                          context.loaderOverlay.hide();
                        }
                        pagecontroller.progresss = progress / 100;
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        pagecontroller.urll.value = url.toString();
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Obx(()=> !pagecontroller.tabNavigationEnabled.value
                ? const SizedBox.shrink()
                : const Bottomnavigation(),
          ),
        ));
  }
}
