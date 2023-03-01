import 'dart:io';

// import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// class Deviceinfo extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
// Map<String, dynamic> _deviceData = <String, dynamic>{};

// const _androidIdPlugin = AndroidId();
Future<Map<String, dynamic>?> initPlatformState() async {
  Map<String, dynamic>? deviceData;
  try {
    if (Platform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);

      // androidId = (await _androidIdPlugin.getId())!;
      // AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      //
      // androidId= androidInfo.androidId;
      // board = androidInfo.board;
      // bootloader= androidInfo.bootloader;
      // brand= androidInfo.brand;
      // device= androidInfo.device;
      // display= androidInfo.display;
      // fingerprint= androidInfo.fingerprint;
      // hardware= androidInfo.hardware;
      // host =androidInfo.host;
      // id= androidInfo.id;
      // isPhysicalDevice = androidInfo.isPhysicalDevice;
      // manufacturer= androidInfo.manufacturer;
      // model=androidInfo.model;
      // product= androidInfo.product;
    } else if (Platform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    } else if (Platform.isLinux) {
      deviceData = _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
    } else if (Platform.isMacOS) {
      deviceData = _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
    } else if (Platform.isWindows) {
      deviceData = _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
    } else if (kIsWeb) {
      deviceData = _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);
    }
  } on PlatformException {
    deviceData = {'Error:': 'Failed to get platform details.'};
  }
  return deviceData;

  // if (!mounted) return;
  //
  // setState(() {
  //   _deviceData = deviceData;
  // });
}

_readAndroidBuildData(AndroidDeviceInfo build) {
  return {
    'platform': 'android',
    'versioncodename': build.version.codename ?? "",
    'versionbaseOS': build.version.baseOS ?? "",
    'board': build.board ?? "",
    'brand': build.brand ?? "",
    'device': build.device ?? "",
    'manufacturer': build.manufacturer ?? ""
  };
//   versionsecurityPatch = build.version.securityPatch ?? "";
//   versionsdkInt = build.version.sdkInt ?? 0;
//   versionrelease = build.version.release ?? "";
//   versionpreviewSdkInt = build.version.previewSdkInt ?? 0;
//   versionincremental = build.version.incremental ?? "";
//   versioncodename = build.version.codename ?? "";
//   versionbaseOS = build.version.baseOS ?? "";
//   board = build.board ?? "";
//   bootloader = build.bootloader ?? "";
//   brand = build.brand ?? "";
//   device = build.device ?? "";
//   display = build.display ?? "";
//   finger = build.fingerprint ?? "";
//   hardware = build.hardware ?? "";
//   hashCode = build.hashCode;
//   host = build.host ?? "";
//   id = build.id ?? "";
//   manufacturer = build.manufacturer ?? "";
//   model = build.model ?? "";
//   product = build.product ?? "";
//   supported32BitAbis = build.supported32BitAbis;
//   supported64BitAbis = build.supported64BitAbis;
//   supportedAbis = build.supportedAbis;
//   tags = build.tags ?? "";
//   type = build.type ?? "";
//   isPhysicalDevice = build.isPhysicalDevice ?? false;
//   systemFeatures = build.systemFeatures;
// // 08084599426
//   deviceDetail = id +
//       " | " +
//       androidId +
//       " | " +
//       model +
//       " | " +
//       brand +
//       " | " +
//       manufacturer +
//       " | " +
//       hardware +
//       " | $isPhysicalDevice";
}

_readIosDeviceInfo(IosDeviceInfo data) {
  return {
    'platform': 'ios',
    'model': data.model ?? "",
    'versionbaseOS': data.systemVersion ?? "",
    'systemName': data.systemName ?? ""
  };
  // name = data.name ?? "";
  // systemName = data.systemName ?? "";
  // systemVersion = data.systemVersion ?? "";
  // model = data.model ?? "";
  // localizedModel = data.localizedModel ?? "";
  // identifierForVendor = data.identifierForVendor ?? "";
  // isPhysicalDevice = data.isPhysicalDevice;
  // utsnamesysname = data.utsname.sysname ?? "";
  // utsnamenodename = data.utsname.nodename ?? "";
  // utsnamerelease = data.utsname.release ?? "";
  // utsnameversion = data.utsname.version ?? "";
  // utsnamemachine = data.utsname.machine ?? "";
  //
  // deviceDetail = name +
  //     " | " +
  //     model +
  //     " | " +
  //     systemName +
  //     " | " +
  //     systemVersion +
  //     " | " +
  //     localizedModel +
  //     " | " +
  //     identifierForVendor +
  //     " | " +
  //     isPhysicalDevice.toString();
}

_readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return {
    'platform': 'linux',
    'name': data.name ?? "",
    'machineId': data.machineId!
  };
  // name = data.name;
  // version = data.version;
  // id = data.id;
  // idLike = data.idLike;
  // versionCodename = data.versionCodename;
  // versionId = data.versionId;
  // prettyName = data.prettyName;
  // buildId = data.buildId;
  // variant = data.variant;
  // variantId = data.variantId;
  // machineId = data.machineId;
  // deviceDetail = name +
  //     " | " +
  //     data.machineId! +
  //     " | " +
  //     data.version! +
  //     " | " +
  //     data.id +
  //     " | " +
  //     data.idLike.toString() +
  //     " | " +
  //     data.versionCodename! +
  //     " | " +
  //     data.versionId!;
}

_readWebBrowserInfo(WebBrowserInfo data) {
  return {
    'platform': 'web',
    'name': describeEnum(data.browserName),
    'product': data.product!,
    'appcode': data.appCodeName.toString()
  };

  // name = describeEnum(data.browserName);
  // appCodeName = data.appCodeName;
  // appName = data.appName!;
  // appVersion = data.appVersion;
  // deviceMemory = data.deviceMemory;
  // language = data.language;
  // languages = data.languages;
  // platform = data.platform;
  // product = data.product!;
  // productSub = data.productSub;
  // userAgent = data.userAgent;
  // vendor = data.vendor;
  // vendorSub = data.vendorSub;
  // hardwareConcurrency = data.hardwareConcurrency;
  // maxTouchPoints = data.maxTouchPoints;
  // deviceDetail = name +
  //     " | " +
  //     product +
  //     " | " +
  //     appName +
  //     " | " +
  //     data.appCodeName.toString() +
  //     " | " +
  //     data.appVersion.toString() +
  //     " | " +
  //     data.deviceMemory.toString() +
  //     data.language!;
}

_readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return {
    'platform': 'macos',
    'name': data.computerName.replaceAll(RegExp(r'[^\w\s]+'), ""),
    'model': data.model,
    'activeCPUs': data.activeCPUs
  };
  // name = data.computerName.replaceAll(RegExp(r'[^\w\s]+'), "");
  // hostName = data.hostName;
  // arch = data.arch;
  // model = data.model;
  // kernelVersion = data.kernelVersion;
  // osRelease = data.osRelease;
  // activeCPUs = data.activeCPUs;
  // memorySize = data.memorySize;
  // cpuFrequency = data.cpuFrequency;
  // systemGUID = data.systemGUID;
  // deviceDetail = name +
  //     " | " +
  //     model +
  //     " | " +
  //     data.hostName +
  //     " | " +
  //     data.arch +
  //     " | " +
  //     data.kernelVersion +
  //     " | " +
  //     data.osRelease +
  //     " | " +
  //     data.activeCPUs.toString();
}

_readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return {
    'platform': 'window',
    'name': data.computerName.replaceAll(RegExp(r'[^\w\s]+'), ""),
  };
  // numberOfCores = data.numberOfCores;
  // name = data.computerName.replaceAll(RegExp(r'[^\w\s]+'), "");
  // systemMemoryInMegabytes = data.systemMemoryInMegabytes;
  // deviceDetail = name +
  //     " | " +
  //     data.numberOfCores.toString() +
  //     " | " +
  //     data.systemMemoryInMegabytes.toString() +
  //     " | " +
  //     data.numberOfCores.toString();
}
