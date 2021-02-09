import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:z_recorder/backend/information_model.dart';

class InputField extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InformationModel>(
        builder: (context, child, model){
          return Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(29.5)
            ),
            child: TextField(
              decoration: InputDecoration(
                  icon: Icon(Icons.folder),
                  border: InputBorder.none
              ),
              onSubmitted: (value){
                model.changeDirectory(value);
              },
            ),
          );
        }
    );
  }
}
