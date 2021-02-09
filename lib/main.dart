import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:z_recorder/backend/information_model.dart';
import 'package:z_recorder/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zRecprder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScopedModel(
          model: InformationModel(), // model to control some variables
          child: Home() //the page of zRecorder
      )
    );
  }
}
