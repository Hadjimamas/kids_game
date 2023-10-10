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
    return Scaffold(
      appBar: AppBar(title: const Text('Kids Game'), centerTitle: true),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 500,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 0),
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
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return Image.asset('assets/images/farm/sheep.png');
                },
              ),
              FloatingActionButton(
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
    );
  }
}
