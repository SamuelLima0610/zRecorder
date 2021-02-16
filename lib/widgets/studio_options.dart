import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:z_recorder/backend/directory_information.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/widgets/list_of_audios.dart';

// ignore: must_be_immutable
class StudioOptions extends StatefulWidget {

  //the information about the video file
  FileSystemEntity videoFile;
  InformationModel model;

  //constructor
  StudioOptions({this.videoFile,this.model});

  @override
  _StudioOptionsState createState() => _StudioOptionsState();
}

class _StudioOptionsState extends State<StudioOptions> {

  //help to manager the states of execution of recorder
  bool _isRecording = false;
  //help to manager the initialization of recorder
  bool _mRecorderIsInited = false;
  //object to manager the record
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    //initialize the recorder
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    //finalize the recorder
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
                      _start(); // start the record
                      model.play(); //play the video
                    },
                    icon: Icon(Icons.mic,color: _isRecording ? Colors.grey : Colors.green,),
                  ),
                  IconButton(
                    onPressed: (){
                      _stop(); //stop the recorder
                      model.stop(); //stop the video
                    },
                    icon: Icon(Icons.stop,color: _isRecording ? Colors.red: Colors.grey,),
                  ),
                ],
              ),
              //Widget responsible to display the audio of the specific video
              ListOfAudios(pathParent: widget.videoFile.parent,file: widget.videoFile, isRecording: _isRecording,)
            ]
        ),
      ),
    );
  }

  _start(){
    //get the name of audio files(new record)
    String pathAudio = DirectoryInformation.generateAudioFileName(widget.videoFile);
    //start the record
    _mRecorder.startRecorder(
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
}

