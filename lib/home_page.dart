import 'package:flutter/material.dart';
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

  @override
  void initState() {
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
        //backgroundColor: const Color(0x4C3AB708),
        //indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Find Animal',
          ),
          NavigationDestination(
            icon: Icon(Icons.volume_up_outlined),
            selectedIcon: Icon(Icons.volume_up),
            label: 'Sounds',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Puzzles',
          ),
        ],
      ),
      body: <Widget>[
        const AlphabetPuzzle(),
        const AnimalsPage(),
        const ImagePuzzle()
      ][currentPageIndex],
    );
  }
}
