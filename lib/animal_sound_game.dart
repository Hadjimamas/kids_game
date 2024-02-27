import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class FindAnimalSound extends StatefulWidget {
  final List<dynamic> animalList;

  const FindAnimalSound({super.key, required this.animalList});

  @override
  FindAnimalSoundState createState() => FindAnimalSoundState();
}

class FindAnimalSoundState extends State<FindAnimalSound> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> playAnimalSound(String defaultSoundPath, String animalSound) {
    final audioPlayer = AssetsAudioPlayer();
    return audioPlayer.open(
      Audio("$defaultSoundPath$animalSound"),
      autoStart: true,
      showNotification: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<int> randomNumbersList = [];
    List<int> shuffleList = [];
    for (var i = 0; i < 3; i++) {
      int randomInt = Random().nextInt(widget.animalList.length);
      randomNumbersList.add(randomInt);
      shuffleList.add(randomInt);
    }
    shuffleList.shuffle();
    int random = Random().nextInt(shuffleList.length);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: randomNumbersList.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                      width: 200,
                      height: 200,
                      'assets/images/${widget.animalList[randomNumbersList[index]]['category'].toString().toLowerCase()}/${widget.animalList[randomNumbersList[index]]['imagePath']}');
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10)),
          ),
          TextButton.icon(
            onPressed: () {
              String animalCategory =
                  widget.animalList[shuffleList[random]]['category'];
              String animalSound =
                  widget.animalList[shuffleList[random]]['soundPath'];
              String defaultSoundPath =
                  'assets/audio/${animalCategory.toLowerCase()}/';
              playAnimalSound(defaultSoundPath, animalSound);
              print('Animal Sound: $animalSound');
            },
            icon: const Icon(Icons.volume_up_sharp),
            label: const Text('Animal Sound'),
          ),
        ],
      ),
    );
  }
}
