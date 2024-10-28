import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static List<String> testDevices = ['4195558a9e3c9d743ba4ca7e89ebc80e','9B646DF252896C19378152D9D8458F7A'];
  static AdRequest request = const AdRequest(
      keywords: ['Radio,Cyprus'],
      nonPersonalizedAds: false,
      contentUrl: 'Hadjimamas.github.io');

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4707430774132554/7978506522';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4707430774132554/1994546518';
    }
    return 'Unsupported platform';
  }
  static String get bottomBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4707430774132554/2028329439';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4707430774132554/8728275241';
    }
    return 'Unsupported platform';
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4707430774132554/8325872724';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4707430774132554/5605702394';
    }
    return 'Unsupported platform';
  }
}
/***
    -----------------Test Ads iOS-----------------
    App Open	ca-app-pub-3940256099942544/5662855259
    Banner	ca-app-pub-3940256099942544/2934735716
    Interstitial	ca-app-pub-3940256099942544/4411468910
    Interstitial Video	ca-app-pub-3940256099942544/5135589807
    Rewarded	ca-app-pub-3940256099942544/1712485313
    Rewarded Interstitial	ca-app-pub-3940256099942544/6978759866
    Native Advanced	ca-app-pub-3940256099942544/3986624511
    Native Advanced Video	ca-app-pub-3940256099942544/2521693316
 ***/
/***
    -----------------Test Ads Android-----------------
    App Open	ca-app-pub-3940256099942544/3419835294
    Banner	ca-app-pub-3940256099942544/6300978111
    Interstitial	ca-app-pub-3940256099942544/1033173712
    Interstitial Video	ca-app-pub-3940256099942544/8691691433
    Rewarded	ca-app-pub-3940256099942544/5224354917
    Rewarded Interstitial	ca-app-pub-3940256099942544/5354046379
    Native Advanced	ca-app-pub-3940256099942544/2247696110
    Native Advanced Video	ca-app-pub-3940256099942544/1044960115
 ***/