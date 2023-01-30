import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../banner_admob.dart';
import 'adcolonyProvider.dart';
import 'googleProvider.dart';
import 'unityprovider.dart';

class AdsProvider extends GetxController {
  // Future<InitializationStatus> initialization;
  // AdsProvider(this.initialization);
  // static var initFuture = MobileAds.instance.initialize();
  // static var adstate = AdsProvider(initFuture);

  var unity = Get.put(UnityProvider(), permanent: true);
  var adcolony = Get.put(AdcolonyProvider(), permanent: true);
  var googleadvert = Get.put(GoogleProvider(), permanent: true);
  var advertshow = 0.obs;
  var advertrewardshow = 0.obs;
  var unityplayed = false.obs;
  var googleplayed = false.obs;
  var adcolonyplayed = false.obs;
  var unitybannerplayed = false.obs;
  var googlebannerplayed = false.obs;
  var adcolonybannerplayed = false.obs;

  showads() async {
    if (unity.placements[AdManager.rewardedVideoAdPlacementId] == true &&
        unityplayed.isFalse) {
      unity.showAd(AdManager.rewardedVideoAdPlacementId, null);
      advertshow.value = 1;
      unityplayed.value = true;
      googleplayed.value = false;
      adcolonyplayed.value = false;
    } else if (await adcolony.isloaded() && adcolonyplayed.isFalse) {
      adcolony.show(null);
      advertshow.value = 2;
      unityplayed.value = false;
      googleplayed.value = false;
      adcolonyplayed.value = true;
    } else if (googleadvert.intersAd1 != null && googleplayed.isFalse) {
      googleadvert.showAd1();
      advertshow.value = 0;
      adcolonyplayed.value = false;
      unityplayed.value = false;
      googleplayed.value = true;
    } else {
      adcolonyplayed.value = false;
      unityplayed.value = false;
      googleplayed.value = false;
      advertshow.value = 0;
      showads();
    }
  }

  Future<void> showreawardads(Function reward) async {
    if (unity.placements[AdManager.rewardedVideoAdPlacementId] == true &&
        unityplayed.isFalse) {
      unity.showAd(AdManager.rewardedVideoAdPlacementId, reward);
      advertrewardshow.value = 1;
      adcolonyplayed.value = false;
      unityplayed.value = true;
      googleplayed.value = false;
    } else if (googleadvert.rewardedAd != null && googleplayed.isFalse) {
      googleadvert.showRewardedAd(reward);
      advertrewardshow.value = 2;
      adcolonyplayed.value = false;
      unityplayed.value = false;
      googleplayed.value = true;
    } else if (await adcolony.isloaded() && adcolonyplayed.isFalse) {
      adcolony.show(reward);
      advertrewardshow.value = 3;
      adcolonyplayed.value = true;
      unityplayed.value = false;
      googleplayed.value = false;
    } else {
      adcolonyplayed.value = false;
      unityplayed.value = false;
      googleplayed.value = false;
      advertrewardshow.value = 0;
      showreawardads(reward);
    }
  }

  Widget banner() {
    // return adcolony.banner();
    switch (slideIndex.value) {
      case 0:
        return unity.adWidget();
      // case 1:
      //   return adcolony.banner();
      case 1:
        return BannerAdmob();
      default:
        return SizedBox.shrink();
    }
  }

  var slideIndex = 0.obs;

  void counting() {
    Future.delayed(const Duration(seconds: 30), () async {
      // if (unity.placements[AdManager.bannerAdPlacementId] == true &&
      //     unitybannerplayed.isFalse) {
      //   slideIndex.value = 1;
      //   adcolonybannerplayed.value = false;
      //   unitybannerplayed.value = true;
      //   googlebannerplayed.value = false;
      //   // } else if (await adcolony.isloaded() && adcolonybannerplayed.isFalse) {
      //   //   slideIndex.value = 2;
      //   //   adcolonybannerplayed.value = true;
      //   //   unitybannerplayed.value = false;
      //   //   googlebannerplayed.value = false;
      // } else if (googlebannerplayed.isFalse) {
      //   slideIndex.value = 0;
      //   adcolonybannerplayed.value = false;
      //   unitybannerplayed.value = false;
      //   googlebannerplayed.value = true;
      // }
      if (slideIndex.value == 1) {
        slideIndex.value = 0;
      } else {
        slideIndex.value += 1;
      }
      counting();
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    counting();
  }
}
