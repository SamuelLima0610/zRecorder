import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path/path.dart' as path;
import 'package:z_recorder/backend/information_model.dart';

class ListOfFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<InformationModel>(
        builder: (context, child, model){
          return SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined),
                    onPressed: model.index > 0?
                        (){
                          model.decrementIndex();
                        }: null,
                  ),
                  Text(
                    "${path.basename(model.videos[model.index].path)}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios_outlined),
                    onPressed: model.index < model.videos.length - 1?
                        (){
                          model.incrementIndex();
                        }: null,
                  )
                ],
              )
          );
        }
    );
  }
}

