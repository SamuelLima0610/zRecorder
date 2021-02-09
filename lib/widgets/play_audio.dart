import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:z_recorder/backend/information_model.dart';

///
typedef Fn = void Function();

/// Example app.
class SimplePlayback extends StatefulWidget {

  String uri;

  SimplePlayback({this.uri});

  @override
  _SimplePlaybackState createState() => _SimplePlaybackState();
}

class _SimplePlaybackState extends State<SimplePlayback> {

  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  InformationModel model;

  @override
  void initState() {
    super.initState();
    // Be careful : openAudioSession return a Future.
    // Do not access your FlutterSoundPlayer or FlutterSoundRecorder before the completion of the Future
    _mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    super.dispose();
  }

  // -------  Here is the code to playback a remote file -----------------------

  void play() async {
    await _mPlayer.startPlayer(
        fromURI: widget.uri,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {});
          model.stop();
        });
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer.stopPlayer();
    }
  }

  // --------------------- (it was very simple, wasn't it ?) -------------------

  /* Fn getPlaybackFn(InformationModel model) {
    if (!_mPlayerIsInited) {
      return null;
    }
    model.play();
    return _mPlayer.isStopped
        ? play
        : () {
      stopPlayer().then((value) => setState(() {}));
    };
  }*/

  @override
  Widget build(BuildContext context) {
    model = InformationModel.of(context);
    return IconButton(
      onPressed: !_mPlayerIsInited == null ? null : (){
        if(_mPlayer.isStopped){
          play();
          model.play();
        }else{
          stopPlayer().then((value){
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

//getPlaybackFn(model)