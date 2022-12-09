import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:pontabac/configquizz.dart';
import 'package:pontabac/quizzclass.dart';

//<PMLV2>
class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'VideoPol',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  static bool boolTexfield = false;
  bool feuVert = false;
  List<PhotoBase> listVideoBase = [];
  int memoStockidRandom = 0;
  bool getVideoBaseState = false;
  int cetteVideo = 0;

  @override
  void initState() {
    super.initState();
    cetteVideo = 0;
    getVideoBase();
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    _controller = VideoPlayerController.network(
      'https://lamemopole.com/videopol/PHL_01_MM-VIDEOMEME_29565375.mp4',
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();
    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final myPerso = ModalRoute.of(context)!.settings.arguments as GameCommons;

    return Scaffold(
      appBar: AppBar(actions: <Widget>[
        Expanded(
          child: Row(
            children: [
              ElevatedButton(
                  onPressed: () => {Navigator.pop(context)},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      textStyle: const TextStyle(
                          fontSize: 14,
                          backgroundColor: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: const Text('Exit')),

            ],
          ),
        ),
      ]),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Column(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(_controller),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      bottomNavigationBar: Row(children: [
        IconButton(
            icon: const Icon(Icons.gavel),
            iconSize: 30,
            color: Colors.blue,
            tooltip: 'Next',
            onPressed: () {
              setState(() {
                cetteVideo = Random().nextInt(listVideoBase.length - 1);

                _controller = VideoPlayerController.network(
                  'https://lamemopole.com/videopol/' +
                      listVideoBase[cetteVideo].photofilename +
                      "." +
                      listVideoBase[cetteVideo].photofiletype,
                );

                // Initialize the controller and store the Future for later use.
                _initializeVideoPlayerFuture = _controller.initialize();
                // Use the controller to loop the video.
                _controller.setLooping(true);
                _controller.play();
              });
            }),
      ]),
    );
  }

  Future getVideoBase() async {
    Uri url = Uri.parse(pathPHP + "readVIDEOBASE.php");
    getVideoBaseState = false;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listVideoBase =
            datamysql.map((xJson) => PhotoBase.fromJson(xJson)).toList();
        getVideoBaseState = true;
        //   cestCeluiLa = Random().nextInt(listPhotoBase.length);
        //getPhotoCat();
        feuVert = true;
      });
    } else {
      feuVert = false;
    }
  }
}
