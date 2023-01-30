import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:universal_platform/universal_platform.dart';

InterstitialAd? myInterstitial;
int maxFailedLoadAttempts = 3;
int _numInterstitialLoadAttempts = 0;
RewardedAd? rewardedAd;
int _numRewardedLoadAttempts = 0;

BannerAd? banner;

class Advertgoogle {
  Future<InitializationStatus> initialization;
  Advertgoogle(this.initialization);
  static var initFuture = MobileAds.instance.initialize();
  static var adstate = Advertgoogle(initFuture);
  static String get appId => UniversalPlatform.isAndroid
      // ? 'ca-app-pub-3940256099942544~3347511713'
      ? 'ca-app-pub-1598206053668309~3978884246'
      // : 'ca-app-pub-3940256099942544~1458002511';
      : 'ca-app-pub-1434709234432705~5608248115';

  static String get bannerUnitId => UniversalPlatform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      // ? 'ca-app-pub-1598206053668309/9458441638'
      // : 'ca-app-pub-3940256099942544/2934735716';
      : 'ca-app-pub-1434709234432705/4888410427';
  static String get screenUnitId => UniversalPlatform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      // ? 'ca-app-pub-1598206053668309/3372379580'
      // : 'ca-app-pub-3940256099942544/4411468910';
      : 'ca-app-pub-1434709234432705/2712839079';
  static String get videoUnitId => UniversalPlatform.isAndroid
      ? 'ca-app-pub-1598206053668309/7120052904'
      // ? 'ca-app-pub-1434709234432705/7859994011'
      : 'ca-app-pub-3940256099942544/1712485313';
  static BannerAdListener get listner => _listener;
  static final BannerAdListener _listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      print('Ad loaded.');
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an ad is in the process of leaving the application.
    // onApplicationExit: (Ad ad) => print('Left application.'),
  );
}

void createInterstitialAd() async {
  // if (await CheckVpnConnection.isVpnActive()) {
  InterstitialAd.load(
      adUnitId: Advertgoogle.screenUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          myInterstitial = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          _numInterstitialLoadAttempts += 1;
          myInterstitial = null;
          if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      )
      // listener: Interstitiallistner,
      );
  // }
}

void createRewardedAd() async {
  // if (await CheckVpnConnection.isVpnActive()) {
  RewardedAd.load(
      adUnitId: Advertgoogle.videoUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          // Keep a reference to the ad so you can show it later.
          rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          createRewardedAd();
        },
      ));
  // }
}

void showRewardedAd() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
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
      // point += 20;
      // prefs.setInt('point', point);
      createRewardedAd();
      showgoogleadvert();
    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createRewardedAd();
    },
  );

  rewardedAd!.setImmersiveMode(true);
  rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
    print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
  });
  rewardedAd = null;
}

AdRequest request = const AdRequest(
  keywords: <String>[
    'foo',
    'bar',
    'wallpaper',
  ],
  contentUrl: 'URL',
  nonPersonalizedAds: true,
);

final BannerAd myBanner = BannerAd(
    adUnitId: Advertgoogle.bannerUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: Advertgoogle.listner);

final AdWidget adWidget = AdWidget(ad: myBanner);

bool googleshow = true;
int googlecount = 0;
void showgoogleadvert() async {
  if (myInterstitial != null) {
  myInterstitial!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) {
      print('ad onAdShowedFullScreenContent.');
      createInterstitialAd();
    },
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );

  myInterstitial!.show();
  }
}

void initiate(MyApp) async {
  assert(MyApp != null);
  WidgetsFlutterBinding.ensureInitialized();
  // if (await CheckVpnConnection.isVpnActive()) {
  MobileAds.instance.initialize();
  runApp(Phoenix(
      child: Provider.value(
    value: Advertgoogle.adstate,
    builder: (context, child) => MyApp,
  )));
  // }else {
  //   runApp(MyApp);
  // }
}

void initgooglebanner() async {
  // if (await CheckVpnConnection.isVpnActive()) {
  banner = BannerAd(
      adUnitId: Advertgoogle.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: Advertgoogle.listner)
    ..load();
  // }
}

void disposebanner() {
  banner!.dispose();
}
