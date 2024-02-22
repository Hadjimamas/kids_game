import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  final String videoID;
  static String video01ID = 'ENXruHKtRIs';
  static String video02ID = 'zdvYnqV3-Sg';

  const VideoPlayer({super.key, required this.videoID});

  @override
  VideoLibraryState createState() => VideoLibraryState();
}

class VideoLibraryState extends State<VideoPlayer> {
  late YoutubePlayerController youtubeController;
  bool isFullScreen = false;
  bool enableFloatingButton = true;

  @override
  void initState() {
    super.initState();
    youtubeController = YoutubePlayerController(
      initialVideoId: widget.videoID,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
    youtubeController.addListener(() {
      if (youtubeController.value.isFullScreen) {
        setState(() {
          isFullScreen = true;
          enableFloatingButton = false;
        });
      } else if (!youtubeController.value.isFullScreen) {
        setState(() {
          enableFloatingButton = true;
          isFullScreen = false;
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
      floatingActionButton: Visibility(
        visible: enableFloatingButton,
        child: FloatingActionButton(
          tooltip: 'Videos',
          child: const Icon(Icons.list),
          onPressed: () {
            showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
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
                            youtubeController.load(VideoPlayer.video02ID);
                            Navigator.pop(context);
                          },
                          label: const Text('Butterfly'),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.pets),
                          onPressed: () {
                            youtubeController.load(VideoPlayer.video01ID);
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
