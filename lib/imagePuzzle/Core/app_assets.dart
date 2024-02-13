import 'package:flutter/material.dart';

class AppAssets {
  static const String summerImage = "assets/images/seasons/summer.png";
  static const String winterImage = "assets/images/seasons/winter.png";
  static const String springImage = "assets/images/seasons/spring.png";
  static const String autumnImage = "assets/images/seasons/autumn.png";
  static const String background1 = "assets/images/farm/background.jpg";
  static const String background2 = "assets/images/forest/background.jpg";
  static const String background3 = "assets/images/tropical/background.jpg";
  static const String puzzleImage1 =
      "assets/images/puzzleImages/puzzleAnimals.png";
  static const String puzzleImage2 =
      "assets/images/puzzleImages/puzzleNumbers.jpg";
  static const String puzzleImage3 =
      "assets/images/puzzleImages/puzzleAnimals2.png";
  static const String puzzleImage4 =
      "assets/images/puzzleImages/puzzleAnimals3.png";
  static const String puzzleImage5 =
      "assets/images/puzzleImages/puzzleSeasons.png";

  static const seasonImagesAssets = [
    summerImage,
    winterImage,
    springImage,
    autumnImage,
  ];

  static const backgroundImageAssets = [
    background1,
    background2,
    background3,
  ];

  static const puzzleImageAssets = [
    puzzleImage1,
    puzzleImage2,
    puzzleImage3,
    puzzleImage4,
    puzzleImage5,
  ];

  static List seasonImageList = [];
  static List backgroundImageList = [];
  static List cartoonImageList = [];

  static initImages(imagesList, listWhereImageAdd) {
    for (var images in imagesList) {
      listWhereImageAdd.add(
        Image.asset(
          images,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      );
    }
  }

  static cacheImages(List images, context) {
    for (Image img in images) {
      precacheImage(img.image, context);
    }
  }
}
