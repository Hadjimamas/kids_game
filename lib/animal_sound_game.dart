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

  Future<void> _showMyDialog(
      String title, String bodyMsg, bool isCorrect) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          titleTextStyle: const TextStyle(
              fontFamily: 'Jungle Hope', color: Colors.deepPurpleAccent),
          contentTextStyle: const TextStyle(
              fontFamily: 'Jungle Hope', color: Colors.deepPurpleAccent),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(bodyMsg),
                //Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // if (isCorrect)
            //   TextButton(
            //     child: const Text('Next'),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    List<int> randomNumbersList = [];
    List<int> shuffleList = [];
    for (var i = 0; i < 4; i++) {
      int randomInt = Random().nextInt(widget.animalList.length);
      if (randomNumbersList.contains(randomInt)) {
        i--;
      } else {
        randomNumbersList.add(randomInt);
        shuffleList.add(randomInt);
      }
    }
    shuffleList.shuffle();
    int random = Random().nextInt(shuffleList.length);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 40, bottom: 20),
        width: deviceWidth,
        height: deviceHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Text(
                'Which animals has this sound?',
                style: TextStyle(
                  fontSize: deviceWidth / 15,
                  color: Colors.deepPurpleAccent,
                  fontFamily: 'Mansalva',
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items in each row
                    mainAxisSpacing: 50.0, // Spacing between rows
                    crossAxisSpacing: 50.0, // Spacing between columns
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: randomNumbersList.length,
                  itemBuilder: (context, index) {
                    String gridAnimal =
                        widget.animalList[randomNumbersList[index]]['name'];
                    String correctAnimal =
                        widget.animalList[shuffleList[random]]['name'];
                    return InkWell(
                      onTap: () {
                        print('Correct answer: $correctAnimal');
                        print('Selected: $gridAnimal');
                        if (correctAnimal == gridAnimal) {
                          _showMyDialog(
                              "That's Correct!",
                              '$correctAnimal is the animal we are looking for',
                              true);
                        } else {
                          _showMyDialog("Wrong Answer", 'Try again!', false);
                        }
                      },
                      child: Image.asset(
                          width: deviceWidth / 2,
                          height: deviceHeight,
                          'assets/images/${widget.animalList[randomNumbersList[index]]['category'].toString().toLowerCase()}/${widget.animalList[randomNumbersList[index]]['imagePath']}'),
                    );
                  },
                ),
              ),
            ),
            TextButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  width: 3.0,
                  color: Colors.white,
                ),
              ),
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
      ),
    );
  }
}
