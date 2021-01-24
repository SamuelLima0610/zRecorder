import 'dart:io';
import 'package:path/path.dart' as path;

class DirectoryInformation{

  static Future<List<String>> getDirectories(String directory) async {
    List<FileSystemEntity> files = [];
    List<String> onlyFilesName = [];
    var dir = Directory(directory);
    print(dir.path);
    files = dir.listSync().where((element){
      return path.extension(element.path) == ".mp4";
    }).toList();
    onlyFilesName = files.map((e){
      return path.basename(e.path);
    }).toList();
    return onlyFilesName;
  }

}

//"/storage/emulated/0/Download"