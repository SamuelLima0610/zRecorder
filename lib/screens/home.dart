import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/widgets/input_field.dart';
import 'package:z_recorder/widgets/list_of_files.dart';
import 'package:z_recorder/widgets/player_video.dart';

//The home page

class Home extends StatelessWidget {

  /// (1) - If the variable directory(managed by model InformationModel) is empty
  /// show a empty container, else display the files of extension .mp4
  /// through the listOfFiles widget.
  /// (2) - If the list(FileSystemEntity) videos(managed by model InformationModel)
  /// is empty show a empty container, else display a widget responsible to reproduce
  /// the videos through the PlayerVideo. The PlayerVideo receive the model

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InformationModel>(
        builder: (context, child, model){
          return Scaffold(
            appBar: AppBar(
              title: Text("zDub",style: TextStyle(color: Colors.white),),
              centerTitle: true,
              backgroundColor: Colors.redAccent,
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InputField(),
                  model.directory != "" ? ListOfFiles() : Container(), //(1)
                  model.videos.isEmpty ? Container() : PlayerVideo(model: model,) //(2)
                ],
              ),
            ),
          );
        }
    );
  }
}

