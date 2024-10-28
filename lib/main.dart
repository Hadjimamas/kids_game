import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kids_game/home_page.dart';
import 'package:kids_game/imagePuzzle/Core/app_string.dart';
import 'package:kids_game/imagePuzzle/Core/app_theme.dart';
import 'package:kids_game/imagePuzzle/Services/hive_db.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  initDB();
  //Disable the landscape
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      theme: getAppTheme(),
      home: const HomePage(),
    );
  }
}

void pageNavigation(context, Widget newPage) => Navigator.of(context)
    .push(MaterialPageRoute(builder: (context) => newPage));
