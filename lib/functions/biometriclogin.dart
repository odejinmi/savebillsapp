
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

List<BiometricType> availableBiometrics = [];
String _authorized = 'Not Authorized';
bool _isAuthenticating = false;

Future<bool> checkBiometrics() async {
  bool canCheckBiometrics;
  try {
    canCheckBiometrics = await auth.canCheckBiometrics;
  } on PlatformException catch (e) {
    canCheckBiometrics = false;
    print(e);
  }

  return canCheckBiometrics;
}

Future<void> getAvailableBiometrics() async {
  List<BiometricType> availableBiometrics;
  try {
    availableBiometrics = await auth.getAvailableBiometrics();
  } on PlatformException catch (e) {
    availableBiometrics = <BiometricType>[];
    print(e);
  }
  availableBiometrics = availableBiometrics;
}

Future<Map<String, dynamic>> authenticateWithBiometrics(prefs) async {
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

void cancelAuthentication() async {
  await auth.stopAuthentication();
}