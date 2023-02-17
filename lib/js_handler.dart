import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:savebills/pagecontroller.dart';
import 'package:savebills/provider/adsProvider.dart';
import 'package:savebills/provider/googleProvider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_settings/app_settings.dart';
// import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:vibration/vibration.dart';

import 'constant.dart';
import 'deviceinfo.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();
_SupportState _supportState = _SupportState.unknown;

List<BiometricType> _availableBiometrics = [];
String _authorized = 'Not Authorized';
bool _isAuthenticating = false;

final InAppReview _inAppReview = InAppReview.instance;
Future<void> _requestReview() => _inAppReview.requestReview();

Future<bool> _checkBiometrics() async {
  bool canCheckBiometrics;
  try {
    canCheckBiometrics = await auth.canCheckBiometrics;
  } on PlatformException catch (e) {
    canCheckBiometrics = false;
    print(e);
  }

  return canCheckBiometrics;
}

Future<void> _getAvailableBiometrics() async {
  List<BiometricType> availableBiometrics;
  try {
    availableBiometrics = await auth.getAvailableBiometrics();
  } on PlatformException catch (e) {
    availableBiometrics = <BiometricType>[];
    print(e);
  }
  _availableBiometrics = availableBiometrics;
}

Future<Map<String, dynamic>> _authenticateWithBiometrics(prefs) async {
  bool authenticated = false;
  try {
    _isAuthenticating = true;
    _authorized = 'Authenticating';

    authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face) to authenticate');
    _isAuthenticating = false;
    _authorized = 'Authenticating';
  } on PlatformException catch (e) {
    print(e);
    _isAuthenticating = false;
    _authorized = "Error - ${e.message}";
    return {"success": false, "message": _authorized};
  }

  final String message = authenticated ? 'Authorized' : 'Not Authorized';
  _authorized = message;

  if (authenticated) {
    print("Auth successful");
    var auth = prefs.read("auth");
    return {"success": true, "data": jsonDecode(auth)};
  } else {
    print("Auth not successful");
    return {"success": false, "message": "Auth not successful"};
  }
}

void _cancelAuthentication() async {
  await auth.stopAuthentication();
}

Future scan() async {
  try {
    var barcode = await BarcodeScanner.scan();
    var barcoded = barcode.rawContent;
    print(barcode.type); // The result type (barcode, cancelled, failed)
    print(barcode.rawContent); // The barcode content
    print(barcode.format); // The barcode format (as enum)
    print(barcode
        .formatNote); // If a unknown format was scanned this field contains a note

    if (barcode.rawContent.isNotEmpty) {
      return {"success": true, "data": barcoded};
    } else {
      return {"success": false, "message": "Barcode not found"};
    }
  } on PlatformException catch (e) {
    return {"success": false, "message": 'Unknown error: $e'};
  } on FormatException {
    return {
      "success": false,
      "message":
          'User returned using the "back"-button before scanning anything. Result'
    };
  } catch (e) {
    return {"success": false, "message": "Unknown error: $e"};
  }
}

Future<Map<String, Object>> selectContact() async {
  final FlutterContactPicker _contactPicker = new FlutterContactPicker();
  Contact? contact = await _contactPicker.selectContact();
  var array = contact!.phoneNumbers;
  var rc = array
      .toString()
      .replaceAll(" ", "")
      .replaceAll("[", "")
      .replaceAll("]", "")
      .replaceAll("+234", "0")
      .replaceAll("234", "0");

  return {"success": true, 'data': rc};
}

Future<Map<String, Object>> takePicture() async {
  final picker = ImagePicker();
  final image =
      await picker.pickImage(source: ImageSource.camera, imageQuality: 20);
  return cropImage(image?.path);
}

/// Crop Image
cropImage(filePath) async {
  var croppedFile = await ImageCropper().cropImage(
    sourcePath: filePath,
    aspectRatioPresets: Platform.isAndroid
        ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]
        : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: primarycolor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
        IOSUiSettings(
        title: 'Crop Image',)
      ]
  );
  if (croppedFile != null) {
    File image = File(croppedFile.path);
    final bytes = image.readAsBytesSync();
    String img64 = base64Encode(bytes);

    return {"success": true, 'data': img64};
  }
  return {"success": false, 'message': 'No image for return'};
}

Future<bool> _handleLocationPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 'Location services are disabled. Please enable the services'
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 'Location permissions are denied'
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    // 'Location permissions are permanently denied, we cannot request permissions.'
    return false;
  }
  return true;
}

Future<Map<String, Object>> _getCurrentPosition(type) async {
  final hasPermission = await _handleLocationPermission();
  if (!hasPermission)
    return {"success": false, 'message': 'Location permissions are denied'};
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  if (type == 1) {
    return {
      "success": true,
      'data': {"lat": position.latitude ?? "", "lng": position.longitude ?? ""}
    };
  } else {
    return _getAddressFromLatLng(position);
  }
}

Future<Map<String, Object>> _getAddressFromLatLng(Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

  Placemark place = placemarks[0];

  return {"success": true, 'data': place};
}

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

  // webViewController?.addJavaScriptHandler(
  //     handlerName: 'contacts',
  //     callback: (args) async {
  //       print("start contacts");
  //       print(args);
  //
  //       PermissionStatus permission = await Permission.contacts.status;
  //       if (permission != PermissionStatus.granted &&
  //           permission != PermissionStatus.permanentlyDenied) {
  //         PermissionStatus permissionStatus =
  //             await Permission.contacts.request();
  //
  //         if (permissionStatus == PermissionStatus.granted) {
  //           print("Permission granted");
  //           // Get all contacts on device
  //           List<Contact> contacts = await ContactsService.getContacts();
  //
  //           print("contacts");
  //           print(contacts);
  //
  //           return {"success": true, 'data': contacts};
  //         } else {
  //           print("Permission not granted");
  //           return {"success": false, 'message': "Permission not granted"};
  //         }
  //       } else {
  //         print("Permission error");
  //         return {"success": false, 'message': "Permission Error"};
  //         ;
  //       }
  //     });

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
        return _authenticateWithBiometrics(prefs);
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_stop',
      callback: (args) {
        _cancelAuthentication();
        return {"success": true, "message": "Authentication cancelled"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_available',
      callback: (args) {
        _getAvailableBiometrics();
        return {
          "success": true,
          "message": "Authentication cancelled",
          'data': _availableBiometrics
        };
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'biometric_check',
      callback: (args) async {
        var auth = prefs.read("auth");
        bool cb = await _checkBiometrics();
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
      handlerName: 'scanQrCode',
      callback: (args) async {
        PermissionStatus permission = await Permission.camera.status;
        if (permission != PermissionStatus.granted &&
            permission != PermissionStatus.permanentlyDenied) {
          PermissionStatus permissionStatus =
          await Permission.camera.request();
          await Permission.storage.request();

          if (permissionStatus == PermissionStatus.granted) {
            print("Permission granted");
            return scan();
          } else {
            print("Permission not granted");
            return {"success": false, 'message': "Permission not granted"};
          }
        } else {
          PermissionStatus permissionStatus = await Permission.camera.request();
          if (permissionStatus == PermissionStatus.granted) {
            print("Permission granted");
            return scan();
          } else {
            print("Permission not granted");
            return {"success": false, 'message': "Permission not granted"};
          }
        }
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'takePicture',
      callback: (args) async {
        PermissionStatus permission = await Permission.camera.status;
        if (permission != PermissionStatus.granted &&
            permission != PermissionStatus.permanentlyDenied) {
          PermissionStatus permissionStatus =
              await Permission.camera.request();
              await Permission.storage.request();

          if (permissionStatus == PermissionStatus.granted) {
            print("Permission granted");
            return takePicture();
          } else {
            print("Permission not granted");
            return {"success": false, 'message': "Permission not granted"};
          }
        } else {
          PermissionStatus permissionStatus = await Permission.camera.request();
          if (permissionStatus == PermissionStatus.granted) {
            print("Permission granted");
            return takePicture();
          } else {
            print("Permission not granted");
            return {"success": false, 'message': "Permission not granted"};
          }
        }
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

        return _getCurrentPosition(1);
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'geoAddress',
      callback: (args) async {

        return _getCurrentPosition(2);
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'vibrate',
      callback: (args) async {

        Vibration.vibrate(duration: args[0]);

        return {"success": true, 'message': "Vibration started"};
      });

  webViewController?.addJavaScriptHandler(
      handlerName: 'islogin',
      callback: (args) async {
        Get.find<Pagecontroller>().tabNavigationEnabled.value = true;
        return {"success": true, 'message': "Devise has login"};
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
