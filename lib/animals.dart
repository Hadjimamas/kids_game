// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  AnimalsPageState createState() => AnimalsPageState();
}

enum TtsState { playing, stopped, paused, continued }

class AnimalsPageState extends State<AnimalsPage> {
  final audioPlayer = AssetsAudioPlayer();
  List<dynamic> animalList = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/animals.json');
    List<dynamic> data = json.decode(response);
    setState(() {
      animalList.addAll(data);
    });
  }

  @override
  void initState() {
    readJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40),
        alignment: Alignment.topCenter,
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: 100,
            //childAspectRatio: 2 / 2,
          ),
          itemCount: animalList.length,
          itemBuilder: (context, index) {
            String animalName = animalList[index]['name'];
            String animalCategory = animalList[index]['category'];
            String animalImage = animalList[index]['imagePath'];
            String animalSound = animalList[index]['soundPath'];
            String defaultImagePath =
                'assets/images/${animalCategory.toLowerCase()}/';
            String defaultSoundPath =
                'assets/audio/${animalCategory.toLowerCase()}/';
            animalList.sort((a, b) => a['category'].compareTo(b['category']));
            return Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Image.asset(
                  '$defaultImagePath$animalImage',
                  width: deviceWidth / 2,
                  height: deviceHeight / 10,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset('assets/images/farm/Sheep.PNG');
                  },
                ),
                FloatingActionButton.small(
                  child: const Icon(Icons.volume_up),
                  onPressed: () {
                    print('Animal Playing: $animalName');
                    audioPlayer.open(
                      Audio("$defaultSoundPath$animalSound"),
                      autoStart: true,
                      showNotification: true,
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
