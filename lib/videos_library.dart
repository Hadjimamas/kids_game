import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosLibrary extends StatefulWidget {
  static String video01ID = 'ENXruHKtRIs';
  static String video02ID = 'zdvYnqV3-Sg';

  const VideosLibrary({super.key});

  @override
  VideosLibraryState createState() => VideosLibraryState();
}

class VideosLibraryState extends State<VideosLibrary> {
  late YoutubePlayerController youtubeController;
  bool isFullScreen = false;

  @override
  void initState() {
    super.initState();
    youtubeController = YoutubePlayerController(
      initialVideoId: VideosLibrary.video01ID,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    youtubeController.addListener(() {
      if (youtubeController.value.isFullScreen != isFullScreen) {
        setState(() {
          isFullScreen = youtubeController.value.isFullScreen;
        });
      }
    });
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    youtubeController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Videos',
        child: const Icon(Icons.list),
        onPressed: () {
          Scaffold.of(context).showBottomSheet(
            (BuildContext context) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton.icon(
                        icon: const Icon(Icons.emoji_nature),
                        onPressed: () {
                          youtubeController.load(VideosLibrary.video02ID);
                          Navigator.pop(context);
                        },
                        label: const Text('Butterfly'),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.pets),
                        onPressed: () {
                          youtubeController.load(VideosLibrary.video01ID);
                          Navigator.pop(context);
                        },
                        label: const Text('Animals'),
                      ),
                      IconButton.outlined(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Colors.red),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      body: Center(
        child: YoutubePlayer(
          controller: youtubeController,
          showVideoProgressIndicator: true,
        ),
      ),
    );
  }
}
