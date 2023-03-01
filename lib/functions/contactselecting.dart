import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:geolocator/geolocator.dart';

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
