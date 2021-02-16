import 'dart:io';
import 'package:path/path.dart' as path;

class DirectoryInformation{

  //get the files of a specific directory and extension
  static Future<List<FileSystemEntity>> getDirectories(String directory, String extension) async {
    List<FileSystemEntity> files = [];
    var dir = Directory(directory);
    files = dir.listSync().where((element){
      return path.extension(element.path) == extension;
    }).toList();
    return files;
  }

  //get the files of a specific directory(video's parent directory) and extension(.aac)
  static Future<List<FileSystemEntity>> getAudios(FileSystemEntity paternPath, String baseName) async {
    List<FileSystemEntity> audios  = await DirectoryInformation.getDirectories(paternPath.path,".aac");
    return audios.where((element){
      return path.basename(element.path).contains(baseName);
    }).toList();
  }

  //return the audio's name
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