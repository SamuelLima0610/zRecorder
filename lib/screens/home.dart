import 'dart:io';

import 'package:flutter/material.dart';
import 'package:z_recorder/backend/directory_information.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final inputController = TextEditingController();
  List<FileSystemEntity> files = [];
  String dir;
  int index = 0;

  @override
  Widget build(BuildContext context) {
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
            inputDirectory(),
            dir != "" ?
                FutureBuilder<List<String>>(
                    future: DirectoryInformation.getDirectories(dir),
                    builder: (context, snapshot){
                      if(snapshot.hasData)
                        return SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios_outlined),
                                  onPressed: index > 0?
                                      (){
                                    setState(() {
                                      index--;
                                    });
                                  }: null,
                                ),
                                Text(
                                  "${snapshot.data[index]}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10.0
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios_outlined),
                                  onPressed: index < snapshot.data.length - 1?
                                      (){
                                    setState(() {
                                      index++;
                                    });
                                  }: null,
                                )
                              ],
                            )
                        );
                      else
                        return Container();
                    }
                ):
                Container()
          ],
        ),
      ),
      floatingActionButton: IconButton(
          icon: Icon(Icons.navigate_next),
          onPressed: (){
            setState(() {
              dir = inputController.text;
            });
          }
      ),
    );
  }

  Widget inputDirectory(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(29.5)
      ),
      child: TextField(
        controller: inputController,
        decoration: InputDecoration(
            icon: Icon(Icons.folder),
            border: InputBorder.none
        ),
      ),
    );
  }
}
