import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class ListFiles extends StatefulWidget {
  @override
  _ListFilesState createState() => _ListFilesState();
}

class _ListFilesState extends State<ListFiles> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
        future: getDirectories(),
        builder: (context, snapshot){
          if(snapshot.hasData)
            return Container(
              color: Colors.green,
            );
          else
            return CircularProgressIndicator();
        }
    );
  }

  Future<List<FileSystemEntity>> getDirectories() async {
    List<FileSystemEntity> files = [];
    var dir = Directory("/storage/emulated/0/Download");
    //var dir = await getExternalStorageDirectory();
    print(dir.path);
    dir.listSync().forEach((element) {
      if(element is File) {
        files.add(element);
      }
    });
    files = files.where((element){
      return path.extension(element.path) == ".mp4";
    }).toList();
    files.forEach((element) {
      print(element.path);
    });
    return files;
  }
}
