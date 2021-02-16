import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/widgets/studio_options.dart';

// ignore: must_be_immutable
class PlayerVideo extends StatefulWidget {

  InformationModel model;

  //constructor
  PlayerVideo({this.model});

  @override
  _PlayerVideoState createState() => _PlayerVideoState(model);
}

class _PlayerVideoState extends State<PlayerVideo> {

  //check if the video files was initialized
  bool initialized = false;
  InformationModel model;
  //List of VideoPlayerController to control the videos
  List<VideoPlayerController> controllers;


  //constructor
  _PlayerVideoState(this.model);

  @override
  void initState(){
    _initVideo();
    super.initState();
  }

  @override
  void dispose() {
    controllers.forEach((controller) {
      controller.dispose();
    });
    super.dispose();
  }

  //Initialized the display of video
  _initVideo(){
    controllers = List.generate(model.videos.length, (index) => null);
    int index = 0;
    //get the list(the videos' path) in the model and create a VideoPlayerController
    //for each file
    controllers = model.videos.map((e){
      VideoPlayerController _controller = VideoPlayerController.file(File(model.videos[index].path))
      // initialize the controller and notify UI when done
        ..initialize().then((value) {
          setState(() => {initialized = true});
        });
      _controller.pause();
      _controller.setVolume(0.0);
      index++;
      return _controller;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    //control the execution the video when the audio is playing
    if(initialized && model.playAudio && model.isPlaying) {
      //set the video to begin
      controllers[model.index].seekTo(Duration(seconds: 0)).then((value){
        controllers[model.index].play();
      });
    }
    else if(initialized && model.playAudio && !model.isPlaying){
      controllers[model.index].pause();
      model.resetPlay();
    }
    return  initialized ?  Card(
        child: Container(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.video_label),
                trailing: IconButton(
                    icon: Icon(controllers[model.index].value.isPlaying ? Icons.pause_circle_filled :Icons.play_circle_fill),
                    onPressed: (){
                      setState(() {
                        ifLopingDoThis();
                        // If the video is playing, pause it.
                        if(controllers[model.index].value.isPlaying) {
                          controllers[model.index].pause();
                        } else {
                          // If the video is paused, play it.
                          controllers[model.index].play();
                        }
                      });
                    }
                ),
              ),
              AspectRatio(
                aspectRatio:controllers[model.index].value.aspectRatio,
                // Use the VideoPlayer widget to display the video.
                child: VideoPlayer(controllers[model.index]),
              ),
              StudioOptions(videoFile: model.videos[model.index], model: model),
            ],
          ),
          color: Colors.white24,
        )
    ): Container();
  }

  //check if the video is in the end and restart the execution
  void ifLopingDoThis(){
    if(controllers[model.index].value.position == controllers[model.index].value.duration)
      controllers[model.index].seekTo(Duration(seconds: 0)).then((value){
        controllers[model.index].play();
      });
  }

}