import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:webview_windows/webview_windows.dart';

import 'windowcontroller.dart';

class Window extends StatelessWidget {
  final url;
  Window({Key? key, this.url}) : super(key: key);


  final windowcontroller = Get.put(Windowcontroller());


  Widget compositeView() {
    if (!windowcontroller.controller.value.value.isInitialized) {
      return const Text(
        'Not Initialized',
        style: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Card(
            color: Colors.transparent,
            elevation: 0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Stack(
              children: [
                Webview(
                  windowcontroller.controller.value,
                  permissionRequested: _onPermissionRequested,
                ),
                StreamBuilder<LoadingState>(
                    stream: windowcontroller.controller.value.loadingState,
                    builder: (context, snapshot) {
                      if (snapshot.hasData &&
                          snapshot.data == LoadingState.loading) {
                        return const LinearProgressIndicator();
                      } else {
                        return const SizedBox();
                      }
                    }),
              ],
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    windowcontroller.controller.value.loadUrl(url);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: windowcontroller.isWebviewSuspended.value ? 'Resume webview' : 'Suspend webview',
        onPressed: () async {
          if (windowcontroller.isWebviewSuspended.value) {
            await windowcontroller.controller.value.resume();
          } else {
            await windowcontroller.controller.value.suspend();
          }
            windowcontroller.isWebviewSuspended.value = !windowcontroller.isWebviewSuspended.value;

        },
        child: Icon(windowcontroller.isWebviewSuspended.value ? Icons.play_arrow : Icons.pause),
      ),
      appBar: AppBar(
          title: StreamBuilder<String>(
            stream: windowcontroller.controller.value.title,
            builder: (context, snapshot) {
              return Text(
                  snapshot.hasData ? snapshot.data! : 'WebView (Windows) Example');
            },
          )),
      body: Center(
        child: compositeView(),
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}

final navigatorKey = GlobalKey<NavigatorState>();