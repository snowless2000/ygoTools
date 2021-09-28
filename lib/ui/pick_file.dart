import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilePickerWidget {
  static Widget show(String text, VoidCallback? onBrowsePressed, VoidCallback? onSavePressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(padding: const EdgeInsets.all(5),
          constraints: const BoxConstraints( minWidth: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(width: 1,color: Colors.blue),
          ),
          child: Text(text,
            style: const TextStyle(
                fontSize: 20
            ),),),
        SizedBox(width: 30),
        ElevatedButton(child: const Text("浏览"),onPressed: onBrowsePressed),
        SizedBox(width: 10),
        ElevatedButton(child: const Text("保存"),onPressed: onSavePressed)
      ],
    );
  }
}