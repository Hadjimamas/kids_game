import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kids_game/home_page.dart';
import 'package:kids_game/imagePuzzle/Core/app_string.dart';
import 'package:kids_game/imagePuzzle/Core/app_theme.dart';
import 'package:kids_game/imagePuzzle/Services/hive_db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDB();
  runApp(const MyApp());
}

Future<void> initDB() async {
  await Hive.initFlutter();
  await Hive.openBox<ImageStore>(AppString.dbName);
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter<ImageStore>(ImageStoreAdapter());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0x4C3AB708),
        useMaterial3: true,
        primarySwatch: Colors.teal,
        textTheme: Themes.textTheme,
      ),
      home: const HomePage(),
    );
  }
}

void pageNavigation(context, Widget newPage) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => newPage));
