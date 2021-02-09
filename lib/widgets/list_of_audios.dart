import 'dart:io';

import 'package:flutter/material.dart';
import 'package:z_recorder/backend/directory_information.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:z_recorder/widgets/play_audio.dart';

// ignore: must_be_immutable
class ListOfAudios extends StatefulWidget {

  FileSystemEntity pathParent;
  FileSystemEntity file;
  bool isRecording;

  ListOfAudios({this.file,this.pathParent,this.isRecording});

  @override
  _ListOfAudiosState createState() => _ListOfAudiosState();
}

class _ListOfAudiosState extends State<ListOfAudios> {

  List<FlutterSoundPlayer> audios;
  int chosen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
        future: DirectoryInformation.getAudios(widget.pathParent,path.basename(widget.file.path).split(".")[0]),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Card(
              child: ExpansionTile(
                title: Text("Áudios"),
                leading: Icon(Icons.audiotrack_outlined),
                children: List.generate(snapshot.data.length, (index) {
                  return Container(
                    color: index == chosen ? Colors.green: Colors.white,
                    child: ListTile(
                      title: Text(path.basename(snapshot.data[index].path),style: TextStyle(fontSize: 15.0),),
                      trailing: widget.isRecording ? null : SimplePlayback(uri: snapshot.data[index].path),
                      onTap: (){
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
