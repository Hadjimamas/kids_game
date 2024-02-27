import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class AnimalsPage extends StatefulWidget {
  final List<dynamic> animalList;

  const AnimalsPage({super.key, required this.animalList});

  @override
  AnimalsPageState createState() => AnimalsPageState();
}

enum TtsState { playing, stopped, paused, continued }

class AnimalsPageState extends State<AnimalsPage> {
  final audioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
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
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items in each row
            mainAxisSpacing: 50.0, // Spacing between rows
            crossAxisSpacing: 50.0, // Spacing between columns
          ),
          padding: const EdgeInsets.all(10),
          itemCount: widget.animalList.length,
          itemBuilder: (context, index) {
            String animalName = widget.animalList[index]['name'];
            String animalCategory = widget.animalList[index]['category'];
            String animalImage = widget.animalList[index]['imagePath'];
            String animalSound = widget.animalList[index]['soundPath'];
            String defaultImagePath =
                'assets/images/${animalCategory.toLowerCase()}/';
            String defaultSoundPath =
                'assets/audio/${animalCategory.toLowerCase()}/';
            widget.animalList
                .sort((a, b) => a['category'].compareTo(b['category']));
            return Column(
              children: [
                Text(
                  animalName,
                  style: TextStyle(
                    fontSize: deviceWidth / 15,
                    color: Colors.pink,
                    fontFamily: 'Jungle Hope',
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      Image.asset(
                        '$defaultImagePath$animalImage',
                        width: deviceWidth / 2,
                        height: deviceHeight,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset('assets/images/farm/Sheep.PNG');
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
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
