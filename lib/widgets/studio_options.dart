import 'dart:io';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:z_recorder/backend/directory_information.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/widgets/list_of_audios.dart';

// ignore: must_be_immutable
class StudioOptions extends StatefulWidget {

  FileSystemEntity videoFile;
  InformationModel model;

  StudioOptions({this.videoFile,this.model});

  @override
  _StudioOptionsState createState() => _StudioOptionsState();
}

class _StudioOptionsState extends State<StudioOptions> {


  //Recording _recording = new Recording();
  bool _isRecording = false;
  bool _mRecorderIsInited = false;
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  @override
  Widget build(BuildContext context) {
    InformationModel model = InformationModel.of(context);
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: (){
                      _start();
                      model.play();
                    },
                    icon: Icon(Icons.mic,color: _isRecording ? Colors.grey : Colors.green,),
                  ),
                  IconButton(
                    onPressed: (){
                      _stop();
                      model.stop();
                    },
                    icon: Icon(Icons.stop,color: _isRecording ? Colors.red: Colors.grey,),
                  ),
                ],
              ),
              ListOfAudios(pathParent: widget.videoFile.parent,file: widget.videoFile, isRecording: _isRecording,)
            ]
        ),
      ),
    );
  }

  _start(){
    String pathAudio = DirectoryInformation.generateAudioFileName(widget.videoFile);
    _mRecorder
        .startRecorder(
      toFile: pathAudio,
      //codec: Codec.aacADTS,
    ).then((value) {
      setState(() {
        _isRecording = true;
      });
    });
  }

  _stop() async {
    await _mRecorder.stopRecorder().then((value) {
      setState(() {
        _isRecording = false;
      });
    });
  }

  /*_start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        String pathAudio = DirectoryInformation.generateAudioFileName(widget.videoFile);
        await AudioRecorder.start(
            path: pathAudio, audioOutputFormat: AudioOutputFormat.AAC);
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = File(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _recording = recording;
      _isRecording = isRecording;
    });
  }*/

}

