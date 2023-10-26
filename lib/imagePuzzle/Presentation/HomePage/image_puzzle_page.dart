import 'package:flutter/material.dart';
import 'package:kids_game/imagePuzzle/Core/app_colors.dart';
import 'package:kids_game/imagePuzzle/Core/assets.dart';
import 'package:kids_game/imagePuzzle/Theme/app_theme.dart';

import 'Widgets/bootom_modal_sheet.dart';
import 'Widgets/custome_text.dart';
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
    AppAssets.initImages(AppAssets.heroImageAssets, AppAssets.heroImageList);
    AppAssets.initImages(
        AppAssets.hypnotizeImageAssets, AppAssets.hypnotizeImageList);
    AppAssets.initImages(
        AppAssets.cartoonImageAssets, AppAssets.cartoonImageList);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    AppAssets.cacheImages(AppAssets.heroImageList, context);
    AppAssets.cacheImages(AppAssets.hypnotizeImageList, context);
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
                      CustomeHeadingText(title: "My Puzzle"),
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
                  images: AppAssets.heroImageList,
                  title: "Hero Images",
                ),
                AssetImageSection(
                  images: AppAssets.hypnotizeImageList,
                  title: "Hypnotize Images",
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
