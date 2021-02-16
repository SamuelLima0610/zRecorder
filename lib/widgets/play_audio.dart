import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:z_recorder/backend/information_model.dart';

///Widget responsible to play the audio
class SimplePlayback extends StatefulWidget {

  //audio's uri
  String uri;

  //constructor
  SimplePlayback({this.uri});

  @override
  _SimplePlaybackState createState() => _SimplePlaybackState();
}

class _SimplePlaybackState extends State<SimplePlayback> {

  //object to manager the actions of audio
  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  //storage the state of the object _mPlayer
  bool _mPlayerIsInited = false;
  //the model Information model
  InformationModel model;

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    //open the session of audios
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    //call the method to stop the reproduction
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    //stop the session
    _mPlayer.closeAudioSession();
    _mPlayer = null;
    super.dispose();
  }

  //method to play the audio
  void play() async {
    await _mPlayer.startPlayer(
        fromURI: widget.uri, //audio's uri
        codec: Codec.aacADTS, //extension of file
        whenFinished: () {
          //callback(execute this code when the reproduction finishes);
          setState(() {});
          //alert the model to warn the player of video to stop the reproduction
          model.stop();
        });
    setState(() {});
  }

  //method to stop the reproduction
  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer.stopPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    //get the InformationModel
    model = InformationModel.of(context);
    return IconButton(
      //check if the player was initialized
      onPressed: !_mPlayerIsInited == null ? null : (){
        if(_mPlayer.isStopped){
          play(); //execute the audio
          model.play(); //execute the video
        }else{
          stopPlayer().then((value){
            //stop the reproduction of audio and video
            model.stop();
            setState(() {});
          });
        }
      },
      color: Colors.white,
      disabledColor: Colors.grey,
      icon: Icon(_mPlayer.isPlaying ? Icons.stop: Icons.play_arrow),
    );
  }
}