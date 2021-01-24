import 'dart:io';

import 'package:flutter/material.dart';
import 'package:z_recorder/screens/home.dart';

import 'codeteste/play_video.dart';
//import 'package:video_player/video_player.dart';
//import 'package:z_recorder/codeteste/listFIles.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home()
    );
  }
}