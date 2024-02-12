import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kids_game/imagePuzzle/Core/app_colors.dart';
import 'package:kids_game/imagePuzzle/Core/app_string.dart';
import 'package:kids_game/imagePuzzle/Core/app_theme.dart';
import 'package:kids_game/imagePuzzle/Core/assets.dart';
import 'package:kids_game/imagePuzzle/Services/hive_db.dart';

import 'Widgets/bottom_modal_sheet.dart';
import 'Widgets/custom_text.dart';
import 'Widgets/my_puzzle_section.dart';
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
    AppAssets.initImages(
        AppAssets.seasonImagesAssets, AppAssets.seasonImageList);
    AppAssets.initImages(
        AppAssets.backgroundImageAssets, AppAssets.backgroundImageList);
    AppAssets.initImages(
        AppAssets.puzzleImageAssets, AppAssets.cartoonImageList);
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
          backgroundColor: AppColors.transparentColor,
          elevation: 0,
          title: Text("Puzzle Hack", style: Themes.textTheme.displayLarge),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () => bottomModelSheetUI(context),
                icon: const Icon(Icons.info_outline,
                    color: AppColors.black54Color, size: 30),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 210,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      CustomHeadingText(title: "My Puzzle"),
                      Spacer(),
                      MyPuzzleSection(),
                    ],
                  ),
                ),
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
