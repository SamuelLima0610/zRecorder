import 'package:flutter_sound/flutter_sound.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class ActionVideoAudio extends Model{

  FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  VideoPlayerController _controller;
  bool _initialized = false;

  static ActionVideoAudio of(BuildContext context) => ScopedModel.of<ActionVideoAudio>(context);

  play(String uriAudio) async{
    await _mPlayer.openAudioSession();
    _mPlayer.startPlayer(
        fromURI: uriAudio,
        codec: Codec.aacADTS,
        whenFinished: () {
          _initialized = true;
          //_controller.play();
        });
  }

  stop() async{
    await _mPlayer.stopPlayer();
    _controller.pause();
  }

  Function getPlaybackFn() {
    if (!_initialized) {
      return null;
    }
    return _mPlayer.isStopped ? play: stop;
  }

  dispose(){
    _mPlayer = null;
    _controller = null;
  }

  changeVideo(VideoPlayerController controller){
    _controller = controller;
    notifyListeners();
  }
}