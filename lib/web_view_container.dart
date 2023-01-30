import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'advertgogle.dart';
import 'banner_admob.dart';
import 'bottomnavigation.dart';
import 'constant.dart';
import 'js_handler.dart';
import 'no_internet.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  const WebViewContainer(this.url);
  @override
  createState() => WebViewContainerState(this.url);
}

class WebViewContainerState extends State<WebViewContainer>
    with WidgetsBindingObserver {
  var urll = "";
  var webViewKey = GlobalKey();

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
  var isLoading = true;
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

  var _url;
  final _key = UniqueKey();
  WebViewContainerState(this._url);

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

  Future<void> hello() async {
    // await readJson();
    // setParams();
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
  int selected = 0;
  @override
  void initState() {
    // TODO: implement initState
    flutterDownload();
    // createRewardedAd();
    createInterstitialAd();
    // Future.delayed(const Duration(milliseconds: 2000), () {
    //   setState(() {
    //     showgoogleadvert();
    //   });
    // });

      // timer = Timer.periodic(const Duration(seconds: 60), (Timer t) {
      //   showgoogleadvert();
      // });

    hello();
    for (int i = 0; i < bottomicon.length; i++) {
      if (_url == bottomurl[i]) {
        selected = i;
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
          print("onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        onWillPop: () => exitApp(context),
        child: Scaffold(
          appBar: AppBar(toolbarHeight:0),
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
                      key: webViewKey,
                      initialSettings: initialSettings,
                      // contextMenu: contextMenu,
                      initialUrlRequest: URLRequest(url: WebUri(_url)),
                      // initialFile: "assets/index.html",
                      initialUserScripts: UnmodifiableListView<UserScript>([]),
                      // initialOptions: options,
                      pullToRefreshController: pullToRefreshController,
                      onWebViewCreated: (controller) async {
                        webViewController = controller;
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
                        urll = url.toString();
                        context.loaderOverlay.show();

                        // inject javascript file from assets folder
                        await webViewController?.injectJavascriptFileFromAsset(
                            assetFilePath: "asset/js_bridge.js");

                        startJS(webViewController);
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
                          if (await canLaunch(urll)) {
                            // Launch the App
                            await launch(
                              urll,
                            );
                            // and cancel the request
                            return NavigationActionPolicy.CANCEL;
                          }
                        }

                        return NavigationActionPolicy.ALLOW;
                      },
                      onLoadStop: (controller, url) async {
                        pullToRefreshController.endRefreshing();
                        // context.loaderOverlay.hide();
                        if (isLoading) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                        urll = url.toString();
                      },
                      onReceivedError: (controller, request, error) async {
                        var isForMainFrame = request.isForMainFrame ?? false;
                        if (!isForMainFrame) {
                          return;
                        }
                        pullToRefreshController.endRefreshing();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => No_Internet()));
                      },
                      onLoadError: (controller, url, code, message) {
                        pullToRefreshController.endRefreshing();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => No_Internet()));
                      },
                      onProgressChanged: (controller, progress) {
                        if (progress == 100) {
                          pullToRefreshController.endRefreshing();
                        }
                        if (progress >= 60) {
                          context.loaderOverlay.hide();
                        }
                        progresss = progress / 100;
                      },
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        urll = url.toString();
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print(consoleMessage);
                      },
                    ),
                  ),
                  BannerAdmob()
                ],
              ),
            ),
          ),
          bottomNavigationBar: !tabNavigationEnabled
                  ? null
                  : Bottomnavigation(
                          selected: selected,
                        ),
        ));
  }
}
