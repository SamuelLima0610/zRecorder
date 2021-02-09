import 'dart:io';

import 'package:flutter/material.dart';
import 'package:z_recorder/backend/directory_information.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:z_recorder/widgets/play_audio.dart';

// ignore: must_be_immutable
class ListOfAudios extends StatefulWidget {

  FileSystemEntity pathParent; // The path to parent directory of the video
  FileSystemEntity file; // the video's path
  bool isRecording; // variable to inform if the recorder is using by user

  //constructor
  ListOfAudios({this.file,this.pathParent,this.isRecording});

  @override
  _ListOfAudiosState createState() => _ListOfAudiosState();
}

class _ListOfAudiosState extends State<ListOfAudios> {

  //the list responsible to storage the audio's path
  List<FlutterSoundPlayer> audios;
  //responsible to storage the index of the audio file is being plated
  int chosen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
        // Method getAudios receive the basename of video and the parent directory
        // and pass all the videos attached by the video
        future: DirectoryInformation.getAudios(widget.pathParent,path.basename(widget.file.path).split(".")[0]),
        builder: (context,snapshot){
          //when get the information show the list
          if(snapshot.hasData){
            return Card(
              child: ExpansionTile(
                title: Text("Áudios"),
                leading: Icon(Icons.audiotrack_outlined),
                //generate a List<Widget> to be displayed
                children: List.generate(snapshot.data.length, (index) {
                  return Container(
                    //if it is the audio chosen by the user the background color is green
                    color: index == chosen ? Colors.green: Colors.white,
                    child: ListTile(
                      //Show the basename of file
                      title: Text(path.basename(snapshot.data[index].path),style: TextStyle(fontSize: 15.0),),
                      // Show the SimplePlayback(play_audio.dart) widget responsible
                      //to reproduce the audio
                      trailing: widget.isRecording ? null : SimplePlayback(uri: snapshot.data[index].path),
                      onTap: (){
                        //actualize the index
                        setState(() {
                          chosen = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            );
          }
          else
            return Container();
        }
    );
  }
}
