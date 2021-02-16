import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:z_recorder/backend/directory_information.dart';


//Model to manager the states of videos files
class InformationModel extends Model{

  int index = 0; //the index to storage the video is been showed
  List<FileSystemEntity> videos = []; //the videos' path
  String directory = ""; // storage the directory
  bool playAudio = false; // show if it is the option to play the audio with video
  bool isPlaying = false; // show if the video is playing with the audio

  //static model to use the Model without the Widget ScopedModelDescendant
  static InformationModel of(BuildContext context) => ScopedModel.of<InformationModel>(context);

  incrementIndex(){
    index++;
    notifyListeners();
  }

  decrementIndex(){
    index--;
    notifyListeners();
  }

  //method to control the directory
  changeDirectory(String newDirectory) async{
    directory = newDirectory;
    //get all the videos storaged in the index
    videos = await DirectoryInformation.getDirectories(directory,".mp4");
    notifyListeners();
  }

  //method to control the execution of audio and video (play)
  play(){
    playAudio = true;
    isPlaying = true;
    notifyListeners();
  }

  //method to control the execution of audio and video (stop)
  stop(){
    isPlaying = false;
    notifyListeners();
  }

  //finalize the execution of audio and video
  resetPlay(){
    playAudio = false;
    notifyListeners();
  }
}