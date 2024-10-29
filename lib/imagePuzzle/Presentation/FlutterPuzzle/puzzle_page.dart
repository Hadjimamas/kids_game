import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image/image.dart' as image;
import 'package:kids_game/ad_helper.dart';
import 'package:kids_game/imagePuzzle/Core/app_colors.dart';
import 'package:kids_game/imagePuzzle/Core/app_string.dart';
import 'package:kids_game/imagePuzzle/Model/object_model.dart';
import 'package:kids_game/imagePuzzle/Presentation/FlutterPuzzle/Widgets/button.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key, required this.imageWidget, required this.heroTag})
      : super(key: key);

  final Widget imageWidget;
  final String heroTag;

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  final GlobalKey _globalKey = GlobalKey<_PuzzlePageState>();

  List<ObjectsModel>? slideObjects;
  int puzzleLength = 0;
  late Size _size;
  late image.Image fullImage;
  bool finishSwap = false;
  bool success = false;
  bool startSlide = false;
  bool showText = false;
  late List process;
  Timer? _timer;
  bool stopTimer = false;
  Duration duration = const Duration();
  String? dropDownSelectedLength;
  late double _width;
  late RewardedAd _rewardedAd;

  /// Loads a rewarded ad.
  void loadRewardAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('Reward Ad Loaded');
          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd.dispose();
          debugPrint('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  fillSlideObject() async {
    fullImage = await getImage();

    Size size = Size(_size.width / puzzleLength, _size.height / puzzleLength);

    slideObjects = List.generate(puzzleLength * puzzleLength, (index) {
      double xOffset = index % puzzleLength * size.width;
      double yOffset = index ~/ puzzleLength * size.height;

      Offset offset = Offset(xOffset, yOffset);

      var cropImage = image.copyCrop(
        fullImage,
        x: offset.dx.round(),
        y: offset.dy.round(),
        width: size.width.round(),
        height: size.height.round(),
      );
      return ObjectsModel(
        defaultPosition: offset,
        currentPosition: offset,
        defaultIndex: index + 1,
        currentIndex: index,
        size: size,
        image: Image.memory(
          Uint8List.fromList(
            image.encodePng(cropImage),
          ),
          fit: BoxFit.fitHeight,
          height: size.height,
          width: size.width,
        ),
      );
    });
    slideObjects!.last.empty = true;

    shuffle();
    setState(() {});
    startTimer();
  }

  getImage() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    _size = boundary.size;
    var img = await boundary.toImage();
    var byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData!.buffer.asUint8List();
    return image.decodeImage(pngBytes);
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        int seconds = duration.inSeconds + 1;
        duration = Duration(seconds: seconds);
      });
    });
  }

  @override
  void initState() {
    loadRewardAd();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = min(MediaQuery.of(context).size.width, 450);
    String twoDigit(int n) => n.toString().padLeft(2, "0");
    final minute = twoDigit(duration.inMinutes.remainder(60));
    final second = twoDigit(duration.inSeconds.remainder(60));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparentColor,
        elevation: 0,
        centerTitle: true,
        title: Row(
          children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 10),
            Text("$minute : $second"),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    backgroundColor: AppColors.transparentColor,
                    child: SizedBox(
                      height: 350,
                      width: 300,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: widget.imageWidget,
                          ),
                          const Spacer(),
                          CircleAvatar(
                            backgroundColor: AppColors.dottedBorderColor,
                            radius: 20,
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.close),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: SizedBox(
                height: 50,
                width: 45,
                child: widget.imageWidget,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: IconButton(
              tooltip: "Hint",
              onPressed: () {
                setState(() {
                  _rewardedAd.show(onUserEarnedReward:
                      (AdWithoutView ad, RewardItem rewardItem) {
                    // Reward the user for watching an ad.
                    showText = !showText;
                  });
                });
              },
              icon: Icon(
                showText ? Icons.lightbulb_sharp : Icons.lightbulb_outlined,
                color: showText ? Colors.orange : AppColors.greyColor,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: 360,
                width: _width,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: AppColors.greyColor),
                ),
                child: Stack(
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: RepaintBoundary(
                        key: _globalKey,
                        child: SizedBox(
                          height: double.maxFinite,
                          child: widget.imageWidget,
                        ),
                      ),
                    ),
                    if (slideObjects != null) ...[
                      Container(
                        height: double.infinity,
                        width: double.infinity,
                        color: AppColors.blueGreyColor,
                      ),
                    ],
                    if (slideObjects != null) ...[
                      for (var slideObject in slideObjects!) ...[
                        if (!slideObject.empty) ...[
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            left: slideObject.currentPosition.dx,
                            top: slideObject.currentPosition.dy,
                            child: GestureDetector(
                              onTap: () {
                                changePos(slideObject.currentIndex);
                              },
                              child: Container(
                                width: slideObject.size.width,
                                height: slideObject.size.height,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: success
                                          ? AppColors.transparentColor
                                          : AppColors.transparentColor,
                                      width: success ? 0 : 2),
                                ),
                                child: Stack(
                                  children: [
                                    slideObject.image,
                                    if (showText && !success)
                                      TextInCircleAvatar(
                                          slideObject: slideObject),
                                  ],
                                ),
                                // nice one
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                    if (slideObjects != null) ...[
                      for (var slideObject in slideObjects!) ...[
                        if (slideObject.empty) ...[
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.ease,
                            left: slideObject.currentPosition.dx,
                            top: slideObject.currentPosition.dy,
                            child: Container(
                              width: slideObject.size.width,
                              height: slideObject.size.height,
                              alignment: Alignment.center,
                              color: AppColors.whiteColor,
                              child: Stack(
                                children: [
                                  DottedBorder(
                                    color: AppColors.dottedBorderColor,
                                    dashPattern: const [20, 8],
                                    strokeWidth: 3,
                                    child: Opacity(
                                      opacity: success ? 0 : 0.5,
                                      child: slideObject.image,
                                    ),
                                  ),
                                  if (showText && !success)
                                    TextInCircleAvatar(
                                        slideObject: slideObject),
                                ],
                              ),
                              // nice one
                            ),
                          ),
                        ],
                      ],
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //shrinkWrap: true,
                  //scrollDirection: Axis.horizontal,
                  children: [
                    ButtonWidget(
                      text: "2x2",
                      onTap: () {
                        if (puzzleLength == 0) {
                          puzzleLength = 2;
                          fillSlideObject();
                        }
                      },
                      backgroundColor: puzzleLength == 2
                          ? AppColors.primaryColor
                          : AppColors.transparentColor,
                    ),
                    ButtonWidget(
                      text: "3x3",
                      onTap: () {
                        if (puzzleLength == 0) {
                          puzzleLength = 3;
                          fillSlideObject();
                        }
                      },
                      backgroundColor: puzzleLength == 3
                          ? AppColors.primaryColor
                          : AppColors.transparentColor,
                    ),
                    ButtonWidget(
                      text: "4x4",
                      onTap: () {
                        if (puzzleLength == 0) {
                          puzzleLength = 4;
                          fillSlideObject();
                        }
                      },
                      backgroundColor: puzzleLength == 4
                          ? AppColors.primaryColor
                          : AppColors.transparentColor,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.transparentColor,
                        border:
                            Border.all(color: AppColors.primaryColor, width: 4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.only(left: 2),
                      alignment: Alignment.center,
                      width: 90,
                      height: 35,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text(dropDownSelectedLength ?? 'Other'),
                          value: dropDownSelectedLength,
                          underline: null,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: AppString.puzzleLengthList
                              .map(
                                (value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(value),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (selectedLength) {
                            if (puzzleLength == 0) {
                              dropDownSelectedLength = selectedLength;
                              puzzleLength =
                                  int.parse(selectedLength!.substring(0, 1));
                              fillSlideObject();
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ObjectsModel getEmptyObject() {
    return slideObjects!.firstWhere((element) => element.empty);
  }

  changePos(int indexCurrent) {
    // problem here i think..
    ObjectsModel slideObjectEmpty = getEmptyObject();

    // get index of empty slide object
    int emptyIndex = slideObjectEmpty.currentIndex;

    // min & max index based on vertical or horizontal

    int minIndex = min(indexCurrent, emptyIndex);
    int maxIndex = max(indexCurrent, emptyIndex);

    // temp list moves involves
    List<ObjectsModel> rangeMoves = [];

    // check if index current from vertical / horizontal line
    if (indexCurrent % puzzleLength == emptyIndex % puzzleLength) {
      // same vertical line
      rangeMoves = slideObjects!
          .where((element) =>
              element.currentIndex % puzzleLength ==
              indexCurrent % puzzleLength)
          .toList();
    } else if (indexCurrent ~/ puzzleLength == emptyIndex ~/ puzzleLength) {
      rangeMoves = slideObjects!;
    } else {
      rangeMoves = [];
    }

    rangeMoves = rangeMoves
        .where((puzzle) =>
            puzzle.currentIndex >= minIndex &&
            puzzle.currentIndex <= maxIndex &&
            puzzle.currentIndex != emptyIndex)
        .toList();

    // check empty index under or above current touch
    if (emptyIndex < indexCurrent) {
      rangeMoves.sort((a, b) => a.currentIndex < b.currentIndex ? 1 : 0);
    } else {
      rangeMoves.sort((a, b) => a.currentIndex < b.currentIndex ? 0 : 1);
    }

    // check if rangeMoves is exist,, then proceed switch position
    if (rangeMoves.isNotEmpty) {
      int tempIndex = rangeMoves[0].currentIndex;

      Offset tempPos = rangeMoves[0].currentPosition;

      for (var i = 0; i < rangeMoves.length - 1; i++) {
        rangeMoves[i].currentIndex = rangeMoves[i + 1].currentIndex;
        rangeMoves[i].currentPosition = rangeMoves[i + 1].currentPosition;
      }

      rangeMoves.last.currentIndex = slideObjectEmpty.currentIndex;
      rangeMoves.last.currentPosition = slideObjectEmpty.currentPosition;

      // haha ..i forget to setup pos for empty puzzle box.. :p
      slideObjectEmpty.currentIndex = tempIndex;
      slideObjectEmpty.currentPosition = tempPos;
    }

    // this to check if all puzzle box already in default place.. can set callback for success later
    if (slideObjects!
                .where((slideObject) =>
                    slideObject.currentIndex == slideObject.defaultIndex - 1)
                .length ==
            slideObjects!.length &&
        finishSwap) {
      success = true;
      slideObjects!.last.empty = false;
      _timer!.cancel();
      showText = false;
    } else {
      success = false;
    }

    startSlide = true;
    setState(() {});
  }

  shuffle() {
    bool swap = true;
    process = [];

    // 20 * size puzzle shuffle
    for (var i = 0; i < puzzleLength * 10; i++) {
      for (var j = 0; j < puzzleLength / 2; j++) {
        ObjectsModel slideObjectEmpty = getEmptyObject();

        // get index of empty slide object
        int emptyIndex = slideObjectEmpty.currentIndex;
        process.add(emptyIndex);
        int randKey;

        if (swap) {
          // horizontal swap
          int row = emptyIndex ~/ puzzleLength;
          randKey = row * puzzleLength + Random().nextInt(puzzleLength);
        } else {
          int col = emptyIndex % puzzleLength;
          randKey = puzzleLength * Random().nextInt(puzzleLength) + col;
        }

        // call change pos method we create before to swap place

        changePos(randKey);
        // ops forgot to swap
        // hmm bug.. :).. let move 1st with click..check whether bug on swap or change pos
        swap = !swap;
      }
    }
    startSlide = false;
    finishSwap = true;
    setState(() {});
  }
}

class TextInCircleAvatar extends StatelessWidget {
  const TextInCircleAvatar({
    Key? key,
    required this.slideObject,
  }) : super(key: key);

  final ObjectsModel slideObject;

  @override
  Widget build(BuildContext context) {
    double radius = slideObject.size.width * 0.1;
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: CircleAvatar(
          radius: min(10, radius) + 1,
          backgroundColor: AppColors.dottedBorderColor,
          child: Text(
            "${slideObject.defaultIndex}",
            style: TextStyle(fontSize: min(10, radius) + 1),
          ),
        ),
      ),
    );
  }
}
