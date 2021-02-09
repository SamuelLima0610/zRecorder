import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:video_player/video_player.dart';
import 'package:z_recorder/backend/directory_information.dart';

class InformationModel extends Model{

  int index = 0;
  List<FileSystemEntity> videos = [];
  String directory = "";
  bool playAudio = false;
  bool isPlaying = false;

  static InformationModel of(BuildContext context) => ScopedModel.of<InformationModel>(context);

  incrementIndex(){
    index++;
    notifyListeners();
  }

  decrementIndex(){
    index--;
    notifyListeners();
  }

  changeDirectory(String newDirectory) async{
    directory = newDirectory;
    videos = await DirectoryInformation.getDirectories(directory,".mp4");
    notifyListeners();
  }

  play(){
    playAudio = true;
    isPlaying = true;
    notifyListeners();
  }

  stop(){
    isPlaying = false;
    notifyListeners();
  }

  resetPlay(){
    playAudio = false;
    notifyListeners();
  }
}