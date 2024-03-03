import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  @override
  void initState() {
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                AssetImageSection(
                  images: AppAssets.seasonImageList,
                  title: "Season Images",
                ),
                AssetImageSection(
                  images: AppAssets.backgroundImageList,
                  title: "Background Images",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
