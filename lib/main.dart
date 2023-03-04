import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:savebills/provider/adsProvider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:savebills/provider/networkProvider.dart';

import 'constant.dart';
import 'landingpage.dart';
import 'package:flutter/material.dart';

const _kShouldTestAsyncErrorOnInit = false;

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Toggle this for testing Crashlytics in your app locally.
const _kTestingCrashlytics = true;

final InAppLocalhostServer localhostServer = InAppLocalhostServer();

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  // start the localhost server
  await localhostServer.start();

  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  if (Platform.isIOS || Platform.isAndroid) {
    await Firebase.initializeApp();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    if (Platform.isIOS) {
      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

  } else {
    if (kIsWeb) {
      // if (runWebViewTitleBarWidget(args)) {
      //   return;
      // }
      await Firebase.initializeApp();
    }
  }


    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: Landingpage(),
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => AdsProvider(), fenix: true);
        Get.lazyPut(() => NetworkProvider(), fenix: true);
        // Get.find<VpnProvider>().initialize();
      }),
    );
  }
}

/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');

  const android1 = AndroidNotificationDetails('channel id', 'channel name',
      channelDescription: 'channel description',
      priority: Priority.high,
      importance: Importance.max);
  // const iOS = IOSNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
  const iOS = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);
  const platform = NotificationDetails(android: android1, iOS: iOS);
  RemoteNotification? notification = message.notification;

  await flutterLocalNotificationsPlugin.show(
      notification.hashCode, // notification id
      notification!.title,
      notification.body,
      platform);
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'Savebills',
          ),
        ));
  }

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published from main!');
  });
}
