import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kids_game/ad_helper.dart';
import 'package:kids_game/imagePuzzle/Core/app_assets.dart';
import 'package:kids_game/imagePuzzle/Core/app_string.dart';
import 'package:kids_game/imagePuzzle/Services/hive_db.dart';

import 'Widgets/title_image_section.dart';

class ImagePuzzle extends StatefulWidget {
  const ImagePuzzle({Key? key}) : super(key: key);

  @override
  ImagePuzzleState createState() => ImagePuzzleState();
}

class ImagePuzzleState extends State<ImagePuzzle> {
  late BannerAd staticAd;
  bool staticAdLoaded = false;

  void loadStaticBannerAd() {
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: AdHelper.testDevices),
    );
    staticAd = BannerAd(
      size: AdSize.banner,
      request: AdHelper.request,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          staticAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Banner Ad Failed to Load: ${error.message}');
      }),
    );
    staticAd.load();
  }

  @override
  void initState() {
    if (!kIsWeb) {
      loadStaticBannerAd();
    }
    initDB();
    if (AppAssets.seasonImageList.isEmpty ||
        AppAssets.backgroundImageList.isEmpty ||
        AppAssets.cartoonImageList.isEmpty) {
      AppAssets.initImages(
          AppAssets.seasonImagesAssets, AppAssets.seasonImageList);

      AppAssets.initImages(
          AppAssets.backgroundImageAssets, AppAssets.backgroundImageList);
      AppAssets.initImages(
          AppAssets.puzzleImageAssets, AppAssets.cartoonImageList);
    }
    super.initState();
  }

  Future<void> initDB() async {
    await Hive.initFlutter();
    await Hive.openBox<ImageStore>(AppString.dbName);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter<ImageStore>(ImageStoreAdapter());
    }
  }

  @override
  void didChangeDependencies() {
    AppAssets.cacheImages(AppAssets.seasonImageList, context);
    AppAssets.cacheImages(AppAssets.backgroundImageList, context);
    AppAssets.cacheImages(AppAssets.cartoonImageList, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Puzzles Library",
            style: TextStyle(fontFamily: 'Mansalva'),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(
                //   height: 210,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       SizedBox(height: 15),
                //       Text("My Puzzle"),
                //       Spacer(),
                //       MyPuzzleSection(),
                //     ],
                //   ),
                // ),
                AssetImageSection(
                  images: AppAssets.cartoonImageList,
                  title: "Cartoon Images",
                ),
                const SizedBox(height: 20),
                if (staticAdLoaded)
                  Container(
                    width: staticAd.size.width.toDouble(),
                    height: staticAd.size.height.toDouble(),
                    alignment: Alignment.bottomCenter,
                    child: AdWidget(ad: staticAd),
                  ),
                AssetImageSection(
                  images: AppAssets.seasonImageList,
                  title: "Season Images",
                ),
                AssetImageSection(
                  images: AppAssets.backgroundImageList,
                  title: "Background Images",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
