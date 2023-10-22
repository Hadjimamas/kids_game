// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlphabetPuzzle extends StatefulWidget {
  const AlphabetPuzzle({Key? key}) : super(key: key);

  @override
  AlphabetPuzzleState createState() => AlphabetPuzzleState();
}

class AlphabetPuzzleState extends State<AlphabetPuzzle>
    with SingleTickerProviderStateMixin {
  /// List of Json file
  List<dynamic> animalList = [];

  /// List of Questions
  List<String> listQuestions = [''];

  /// List of answers
  List<String> answers = [''];

  /// List of Images
  List<String> imageUrls = ['assets/images/farm/Sheep.PNG'];
  List<String> backgroundImages = ['assets/images/farm/background.jpg'];

  List<String> alphabet = [];
  List<String> userAnswers = [];
  late AnimationController _animationController;
  late Animation<double> _animation;
  int currentPuzzle = 0;
  String response = '';
  List<dynamic> data = [];

  @override
  void initState() {
    readJson();
    generateAlphabetOptions();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  ///Reads Json File
  Future<void> readJson() async {
    response = await rootBundle.loadString('assets/animals.json');
    data = json.decode(response);
    setState(() {
      animalList.addAll(data);
    });

    ///Clearing the Lists so I can insert the data from JSON
    listQuestions.clear();
    imageUrls.clear();
    answers.clear();
    backgroundImages.clear();
    for (int i = 0; i < animalList.length; i++) {
      listQuestions.add(animalList[i]['question']);
      answers.add(animalList[i]['name']);
      imageUrls.add(
          'assets/images/${animalList[i]['category'].toString().toLowerCase()}/${animalList[i]['imagePath']}');
      backgroundImages.add(
          'assets/images/${animalList[i]['category'].toString().toLowerCase()}/background.jpg');
    }
    print('**********Lists**********');
    print(imageUrls);
    print(listQuestions);
    print(answers);
    print(backgroundImages);
  }

  ///Generates Alphabets
  Future<void> generateAlphabetOptions() async {
    response = await rootBundle.loadString('assets/animals.json');
    data = json.decode(response);
    setState(() {
      alphabet = animalList[currentPuzzle]['name'].split('');
      alphabet.shuffle();
      userAnswers = List.filled(animalList[currentPuzzle]['name'].length, '');
    });
  }

  ///Checks Answer
  void checkAnswer() {
    if (userAnswers.join('') == answers[currentPuzzle]) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: const Text('Correct Answer!'),
            content: const Text('Congratulations! You got it right.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (currentPuzzle == animalList.length - 1) {
                    // Last puzzle, show completion message
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog.adaptive(
                          title: const Text('Puzzle Completed'),
                          content:
                              const Text('You have completed all the puzzles.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  currentPuzzle = 0;
                                  generateAlphabetOptions();
                                });
                              },
                              child: const Text('Restart'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Next puzzle
                    setState(() {
                      currentPuzzle++;
                      print(
                          "Correct Answers: $currentPuzzle/${animalList.length}");
                      generateAlphabetOptions();
                    });
                  }
                },
                child: const Text('Next'),
              ),
            ],
          );
        },
      ).then((_) {
        _animationController.reset();
        _animationController.forward();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog.adaptive(
            title: Text('Incorrect Answer!'),
            content: Text('Please try again.'),
          );
        },
      );
    }
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImages[currentPuzzle]),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                listQuestions[currentPuzzle],
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: deviceWidth / 9,
                  fontFamily: 'Lovely Kids',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.asset(
                imageUrls[currentPuzzle],
                width: deviceWidth,
                height: deviceHeight / 3,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(userAnswers.length, (index) {
                  return DragTarget<String>(
                    builder: (context, candidateData, rejectedData) {
                      return Row(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.green,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              userAnswers[index].isEmpty
                                  ? ' '
                                  : userAnswers[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    },
                    onAccept: (data) {
                      setState(() {
                        userAnswers[index] = data;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: deviceWidth,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: alphabet.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Draggable<String>(
                              data: alphabet[index],
                              feedback: Material(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.orange,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      alphabet[index],
                                      style: const TextStyle(
                                          fontSize: 25,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              childWhenDragging: Container(),
                              child: Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  alphabet[index],
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: deviceWidth / 1.5,
                height: 60,
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ElevatedButton(
                  onPressed: checkAnswer,
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.orange, width: 2),
                    //backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Check Answer',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
