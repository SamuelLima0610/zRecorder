import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/widgets/list_of_audios.dart';
import 'package:z_recorder/widgets/studio_options.dart';

// ignore: must_be_immutable
class PlayerVideo extends StatefulWidget {

  InformationModel model;

  PlayerVideo({this.model});

  @override
  _PlayerVideoState createState() => _PlayerVideoState(model);
}

class _PlayerVideoState extends State<PlayerVideo> {

  bool initialized = false;
  InformationModel model;
  List<VideoPlayerController> controllers;

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

  _initVideo(){
    controllers = List.generate(model.videos.length, (index) => null);
    int index = 0;
    controllers = model.videos.map((e){
      VideoPlayerController _controller = VideoPlayerController.file(File(model.videos[index].path))
      // Play the video again when it ends
      //  ..setLooping(true)
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
    if(initialized && model.playAudio && model.isPlaying) {
      controllers[model.index].seekTo(Duration(seconds: 0)).then((value){
        controllers[model.index].play();
      });
      controllers[model.index].play();
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
              //ListOfAudios(pathParent:  model.videos[model.index].parent,file: model.videos[model.index],)
            ],
          ),
          color: Colors.white24,
        )
    ): Container();
  }

  void ifLopingDoThis(){
    if(controllers[model.index].value.position == controllers[model.index].value.duration)
      controllers[model.index].seekTo(Duration(seconds: 0)).then((value){
        controllers[model.index].play();
      });
  }

}