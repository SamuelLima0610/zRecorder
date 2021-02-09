import 'dart:io';
import 'package:path/path.dart' as path;

class DirectoryInformation{

  static Future<List<FileSystemEntity>> getDirectories(String directory, String extension) async {
    List<FileSystemEntity> files = [];
    var dir = Directory(directory);
    //print(dir.path);
    files = dir.listSync().where((element){
      return path.extension(element.path) == extension;
    }).toList();
    return files;
  }

  static Future<List<FileSystemEntity>> getAudios(FileSystemEntity paternPath, String baseName) async {
    List<FileSystemEntity> audios  = await DirectoryInformation.getDirectories(paternPath.path,".aac");
    return audios.where((element){
      return path.basename(element.path).contains(baseName);
    }).toList();
  }

  static String generateAudioFileName(FileSystemEntity file){
    int index = 1;
    bool loop = true;
    String pathAudio = "";
    while(loop){
      pathAudio =
          file.parent.path + "/"
              + path.basename(file.path).split(".")[0]
              +"[$index]"
              + ".aac";
      if(!File(pathAudio).existsSync())
        loop = false;
      else
        index++;
    }
    return pathAudio;
  }

}

//"/storage/emulated/0/Download"