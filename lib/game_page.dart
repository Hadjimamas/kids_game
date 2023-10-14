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
  List<String> imageUrls = ['assets/images/farm/Sheep.JPG'];

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
    for (int i = 0; i < animalList.length; i++) {
      listQuestions.add(animalList[i]['question']);
      answers.add(animalList[i]['name']);
      imageUrls.add(
          'assets/images/${animalList[i]['category'].toString().toLowerCase()}/${animalList[i]['imagePath']}');
    }
    print(imageUrls);
    print(listQuestions);
    print(answers);
  }

  ///Generates Alphabets
  Future<void> generateAlphabetOptions() async {
    response = await rootBundle.loadString('assets/animals.json');
    data = json.decode(response);
    setState(() {
      print('Animal List: $animalList');
      alphabet = animalList[currentPuzzle]['name'].split('');
      print('Alphabet List: $alphabet');
      alphabet.shuffle();
      userAnswers = List.filled(animalList[currentPuzzle]['name'].length, '');
    });
  }

  ///Checks Answer
  void checkAnswer() {
    print("$currentPuzzle/${animalList.length}");
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alphabet Puzzle'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[400]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        listQuestions[currentPuzzle],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            imageUrls[currentPuzzle],
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(userAnswers.length, (index) {
                          return DragTarget<String>(
                            builder: (context, candidateData, rejectedData) {
                              return Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    alignment: Alignment.center,
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
                                      style: const TextStyle(
                                          fontSize: 25,
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
                      const SizedBox(height: 16),
                      SizedBox(
                        width: 500,
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                                        child: Container(
                                          height: 55,
                                          width: 55,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                    // const SizedBox(width: 10,),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: checkAnswer,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Check Answer',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
