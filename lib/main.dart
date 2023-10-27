import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kids_game/imagePuzzle/Core/app_string.dart';
import 'package:kids_game/imagePuzzle/Services/hive_db.dart';
import 'package:kids_game/imagePuzzle/Theme/app_theme.dart';

import 'game_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter<ImageStore>(ImageStoreAdapter());
  await Hive.openBox<ImageStore>(AppString.dbName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.teal,
          textTheme: Themes.textTheme),
      home: const AlphabetPuzzle(),
    );
  }
}

void pageNavigation(context, Widget newPage) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => newPage));
