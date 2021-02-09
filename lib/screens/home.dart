import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/widgets/input_field.dart';
import 'package:z_recorder/widgets/list_of_files.dart';
import 'package:z_recorder/widgets/player_video.dart';

class Home extends StatelessWidget {

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
                  model.directory != "" ? ListOfFiles() : Container(),
                  model.videos.isEmpty ? Container() : PlayerVideo(model: model,)
                ],
              ),
            ),
            /*floatingActionButton: IconButton(
                icon: Icon(Icons.navigate_next),
                onPressed: (){
                  model.directory = inputController.text;
                }
            ),*/
          );
        }
    );
  }
}

