import 'package:flutter/material.dart';

class AppAssets {
  static const String aamirkhan = "assets/images/farm/Donkey.PNG";
  static const String srk = "assets/images/farm/background.jpg";
  static const String heroAlam = "assets/images/farm/Horse.PNG";
  static const String hypnotize1 = "assets/images/farm/Cow.PNG";
  static const String hypnotize2 = "assets/images/farm/Dog.PNG";
  static const String hypnotize3 = "assets/images/farm/Goat.PNG";
  static const String cartoonImage1 =
      "assets/images/puzzleImages/puzzleAnimals.png";
  static const String cartoonImage2 =
      "assets/images/puzzleImages/puzzleNumbers.jpg";
  static const String cartoonImage3 = "assets/images/farm/Sheep.PNG";

  static const heroImageAssets = [
    aamirkhan,
    srk,
    heroAlam,
  ];

  static const hypnotizeImageAssets = [
    hypnotize2,
    hypnotize3,
    hypnotize1,
  ];

  static const cartoonImageAssets = [
    cartoonImage1,
    cartoonImage2,
    cartoonImage3,
  ];

  static List heroImageList = [];
  static List hypnotizeImageList = [];
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
