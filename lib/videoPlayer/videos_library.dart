import 'package:flutter/material.dart';
import 'package:kids_game/videoPlayer/video_player.dart';

class VideosLibrary extends StatefulWidget {
  static String video01ID = 'ENXruHKtRIs';
  static String video02ID = 'zdvYnqV3-Sg';

  const VideosLibrary({super.key});

  @override
  VideosLibraryState createState() => VideosLibraryState();
}

class VideosLibraryState extends State<VideosLibrary> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TextButton.icon(
            icon: const Icon(Icons.emoji_nature),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayer(videoID: VideosLibrary.video02ID),
                ),
              );
            },
            label: const Text('Butterfly'),
          ),
          TextButton.icon(
            icon: const Icon(Icons.pets),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayer(videoID: VideosLibrary.video01ID),
                ),
              );
            },
            label: const Text('Animals'),
          ),
        ],
      ),
    );
  }
}
