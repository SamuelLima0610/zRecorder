import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_sound/flutter_sound.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key key,
    @required this.videoFile,
  }) : super(key: key);

  final File videoFile;

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();
  VideoPlayerController _controller;
  bool _mRecorderIsInited = false;
  final String _mPath = 'flutter_sound_example3.aac';
  bool initialized = false;

  @override
  void initState() {
    _initVideo();
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  void stopRecorder() async {
    await _mRecorder.stopRecorder().then((value) {
    });
  }

  void record(){
    _mRecorder
        .startRecorder(
      toFile: widget.videoFile.parent.path + "/" + _mPath,
      //codec: Codec.aacADTS,
    ).then((value) {
      setState(() {});
    });
  }

  _initVideo() async {
    final video = widget.videoFile;
    _controller = VideoPlayerController.file(video)
    /* Play the video again when it ends
      ..setLooping(true)*/
    // initialize the controller and notify UI when done
      ..initialize().then((_){
        setState(() => initialized = true);
        _controller.pause();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initialized
      // If the video is initialized, display it
          ? Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            // Use the VideoPlayer widget to display the video.
            child: VideoPlayer(_controller),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Wrap the play or pause in a call to `setState`. This ensures the
            // correct icon is shown.
            setState(() {
              // If the video is playing, pause it.
              if (_controller.value.isPlaying) {
                _controller.pause();
                stopRecorder();
              } else {
                // If the video is paused, play it.
                _controller.play();
                record();
              }
            });
          },
          // Display the correct icon depending on the state of the player.
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      )
      // If the video is not yet initialized, display a spinner
          : Center(child: CircularProgressIndicator()),
    );
  }
}