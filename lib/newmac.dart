import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/flutter_inline_webview_macos_controller.dart';
import 'package:flutter_inline_webview_macos/flutter_inline_webview_macos/types.dart';

class Newmac extends StatefulWidget {
  const Newmac({Key? key}) : super(key: key);

  @override
  _NewmacState createState() => _NewmacState();
}

class _NewmacState extends State<Newmac> {
  String _platformVersion = 'Unknown';
  final _flutterWebviewMacosPlugin = FlutterInlineWebviewMacos();
  bool _hide = false;

  InlineWebViewMacOsController? _controller;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _flutterWebviewMacosPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _hide = !_hide;
                    });
                    print("toggle hide!");
                  },
                  child: Text("toggle hide ${!_hide}")),
              _hide
                  ? Column(
                      children: [
                        TextButton(
                            onPressed: () async {
                              await _controller!.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse("https://pub.dev/packages/desktop_webview_window")));
                            },
                            child: const Text('load:"youtube.com"')),
                        TextButton(
                            onPressed: () async {
                              await _controller!.loadUrl(
                                  urlRequest: URLRequest(
                                      url: Uri.parse("https://zenn.dev")));
                            },
                            child: const Text('load:"zenn.dev"')),
                        TextButton(
                            onPressed: () async {
                              final url = await _controller!.getUrl();
                              print(url);
                            },
                            child: const Text("getUrl")),
                        InlineWebViewMacOs(
                          key: widget.key,
                          width: 500,
                          height: 300,
                          onWebViewCreated: (controller) {
                            _controller = controller;
                            // _controller!.loadUrl(
                            //     urlRequest: URLRequest(
                            //         url: Uri.parse("https://google.com")));
                          },
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
