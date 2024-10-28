import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_game/animal_sound_game.dart';
import 'package:kids_game/animals.dart';
import 'package:kids_game/game_page.dart';
import 'package:kids_game/imagePuzzle/Presentation/PuzzlePage/image_puzzle_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  List<dynamic> animalList = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/animals.json');
    List<dynamic> data = json.decode(response);
    setState(() {
      animalList.addAll(data);
      animalList.sort((a, b) => a['category'].compareTo(b['category']));
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.volume_up_outlined),
            selectedIcon: Icon(Icons.volume_up),
            label: 'Sounds',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Find Animal',
          ),
          NavigationDestination(
            icon: Icon(Icons.abc_outlined),
            selectedIcon: Icon(Icons.abc),
            label: 'Find Word',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Puzzles',
          ),
          // NavigationDestination(
          //   icon: Icon(Icons.video_collection_outlined),
          //   selectedIcon: Icon(Icons.video_collection),
          //   label: 'Videos',
          // ),
        ],
      ),
      body: <Widget>[
        AnimalsPage(animalList: animalList),
        FindAnimalSound(animalList: animalList),
        const AlphabetPuzzle(),
        const ImagePuzzle(),
        //const VideosLibrary()
      ][currentPageIndex],
    );
  }
}
