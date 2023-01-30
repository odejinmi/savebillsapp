import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class GoogleProvider extends GetxController {
  InterstitialAd? intersAd1;
  int _numInterstitialLoadAttempts = 0;
  InterstitialAd? intersAd2;
  InterstitialAd? intersAd3;
  RewardedAd? rewardedAd;

  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  bool showAds = false;
  bool _footerBannerShow = false;
  dynamic _bannerAd;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    update();
  }

  // bool get footBannerShow => !showAds ? false : _footerBannerShow;

  get bannerIsAvailable => _bannerAd != null;

  // InterstitialAd _intersAd1Create() => InterstitialAd(
  //       unitId: screenUnitId,
  //       loadTimeout: Duration(seconds: 8),
  //     )..onEvent.listen(
  //         (event) {
  //           switch (event.keys.first) {
  //             case FullScreenAdEvent.closed:
  //               intersAd1!.dispose();
  //               intersAd1 = _intersAd1Create();
  //               intersAd1!.load();
  //               break;
  //             default:
  //           }
  //         },
  //       );

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: screenUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            intersAd1 = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // googleinstatialfailed = true;
            _numInterstitialLoadAttempts += 1;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
                createInterstitialAd();
            }
          },
        ));
  }

  void initAds() {
    // if (!showAds) return;
    // AdsProvider adsProvider = AdsProvider.instance(context);

    // adsProvider.intersAd1 = adsProvider._intersAd1Create();
    // adsProvider.intersAd2 = adsProvider._intersAd2Create();
    // adsProvider.intersAd3 = adsProvider._intersAd3Create();
    //
    createInterstitialAd();
    _createRewardedAd();
    // adsProvider.intersAd2?.load();
    // adsProvider.intersAd3?.load();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initAds();
  }

  void showAd1() async {
    if (!showAds) return;
    if (intersAd1 != null) {
      intersAd1?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) {},
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          createInterstitialAd();
        },
      );

      intersAd1?.show();
    } else {
      createInterstitialAd();
    }
  }

  void showAd2(BuildContext context) async {
    // if (!showAds) return;
    // VpnProvider vpnProvider = Get.find<VpnProvider>();
    // if (vpnProvider.isPro) return;
    if (intersAd2 != null) {
      intersAd2?.show();
    } else {
      // intersAd2?.load();
    }
  }

  void showAd3(BuildContext context) async {
    // if (!showAds) return;
    // VpnProvider vpnProvider = Get.find<VpnProvider>();
    // if (vpnProvider.isPro) return;
    if (intersAd3 != null) {
      intersAd3?.show();
    } else {
      // intersAd3?.load();
    }
  }

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: videoUnitId,
        // request: request,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd(Function? rewarded) {
    if (rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    rewardedAd!.setImmersiveMode(true);
    rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      if (rewarded != null) {
        rewarded();
      }
    });
    rewardedAd = null;
  }

  // Widget adWidget(BuildContext context,
  //     {String? bannerId, BannerSize? adSize}) {
  //   if (!showAds) return SizedBox.shrink();
  //   VpnProvider vpnProvider = VpnProvider.instance(context);
  //   if (vpnProvider.isPro) {
  //     return SizedBox.shrink();
  //   } else {
  //     // return SizedBox.shrink();
  //     return BannerAd(
  //       unitId: bannerId ?? banner1,
  //       size: adSize ?? BannerSize.ADAPTIVE,
  //     );
  //     // return BannerAd(adUnitId: bannerId ?? banner1, adSize: adsize);
  //   }
  // }

  // Widget adbottomSpace() {
  //   if (!showAds) return SizedBox.shrink();
  //   return GetBuilder<AdsProvider>(
  //     builder: (value) =>
  //         value.footBannerShow ? SizedBox(height: 60) : SizedBox.shrink(),
  //   );
  // }

  void removeBanner() {
    if (!showAds) return;
    footBannerShow = false;
    _bannerAd.dispose();
    _bannerAd = null;
  }

  // static AdsProvider instance(BuildContext context) =>
  //     Provider.of(context, listen: false);

  static String get appId => Platform.isAndroid
      // old
      // ? 'ca-app-pub-6117361441866120~5829948546'
      ? 'ca-app-pub-1598206053668309~2044155939'
      // : 'ca-app-pub-3940256099942544~1458002511';
      : 'ca-app-pub-1598206053668309~7710581439';

  static String get bannerUnitId => Platform.isAndroid
      // test
      // ? 'ca-app-pub-3940256099942544/6300978111'
      ? 'ca-app-pub-1598206053668309/7104910929'
      // : 'ca-app-pub-3940256099942544/2934735716';
      : 'ca-app-pub-1598206053668309/3771336427';

  static String get screenUnitId => Platform.isAndroid
      // test
      // ? 'ca-app-pub-3940256099942544/1033173712'
      ? 'ca-app-pub-1598206053668309/2841398135'
      // : 'ca-app-pub-3940256099942544/4411468910';
      : 'ca-app-pub-1598206053668309/3579764737';

  static String get videoUnitId => Platform.isAndroid
      // ? 'ca-app-pub-3940256099942544/5224354917'
      ? 'ca-app-pub-1598206053668309/5275989781'
      : 'ca-app-pub-1598206053668309/3667378733';
}
