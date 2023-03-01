
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

Future<Map<String, Object>> getCurrentPosition(type) async {
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
    return getAddressFromLatLng(position);
  }
}

Future<Map<String, Object>> getAddressFromLatLng(Position position) async {
  List<Placemark> placemarks =
  await placemarkFromCoordinates(position.latitude, position.longitude);

  Placemark place = placemarks[0];

  return {"success": true, 'data': place};
}