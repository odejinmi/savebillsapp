import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';


class UnityProvider extends GetxController {
  var prefs = GetStorage();
  bool showBanner = false;
  Map<String, bool> placements = {
    AdManager.interstitialVideoAdPlacementId: false,
    AdManager.rewardedVideoAdPlacementId: false,
  };

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initAds();
  }

  bool _footerBannerShow = false;
  dynamic _bannerAd;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    update();
  }

  get bannerIsAvailable => _bannerAd != null;

  void initAds() {
    UnityAds.init(
      gameId: AdManager.gameId,
      testMode: false,
      onComplete: () {
        print('Initialization Complete');
        _loadAds();
      },
      onFailed: (error, message) =>
          print('Initialization Failed: $error $message'),
    );
  }

  void _loadAds() {
    for (var placementId in placements.keys) {
      _loadAd(placementId);
    }
  }

  void _loadAd(String placementId) {
    UnityAds.load(
      placementId: placementId,
      onComplete: (placementId) {
        print('Load Complete $placementId');
        placements[placementId] = true;
        update();
      },
      onFailed: (placementId, error, message) =>
          print('Load Failed $placementId: $error $message'),
    );
  }

  void showAd(String placementId, Function? reward) {
    placements[placementId] = false;
    update();
    UnityAds.showVideoAd(
      placementId: placementId,
      onComplete: (placementId) {
        print('Video Ad $placementId completed');
        _loadAd(placementId);
        if (reward != null) {
          reward();
        }
      },
      onFailed: (placementId, error, message) {
        print('Video Ad $placementId failed: $error $message');
        _loadAd(placementId);
      },
      onStart: (placementId) {
        print('Video Ad $placementId started');
      },
      onClick: (placementId) {
        print('Video Ad $placementId click');
      },
      onSkipped: (placementId) {
        print('Video Ad $placementId skipped');
        _loadAd(placementId);
      },
    );
  }

  Widget adWidget() {
    return UnityBannerAd(
      placementId: AdManager.bannerAdPlacementId,
      onLoad: (placementId) => print('Banner loaded: $placementId'),
      onClick: (placementId) => print('Banner clicked: $placementId'),
      onFailed: (placementId, error, message) =>
          print('Banner Ad $placementId failed: $error $message'),
    );
    // return BannerAd(adUnitId: bannerId ?? banner1, adSize: adsize);
  }
}

class AdManager {
  static String get gameId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return "3717787";
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return '3717786';
    }
    return '';
  }

  static String get bannerAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'newandroidbanner';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS_Banner';
    }
    return 'newandroidbanner';
  }

  static String get interstitialVideoAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'video';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS_Interstitial';
    }
    return 'video';
  }

  static String get rewardedVideoAdPlacementId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'Android_Rewarded';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'iOS_Rewarded';
    }
    return 'Android_Rewarded';
  }
}
