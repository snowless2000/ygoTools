
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_background_tool/data_class/const.dart';
import 'package:my_background_tool/ui/pick_file.dart';
import 'package:my_background_tool/utils/tool_utils.dart';

class PathChoose extends StatefulWidget {

  @override
  State<PathChoose> createState() => _PathChooseState();

}

class _PathChooseState extends State<PathChoose>{
  bool inited = false;
  String path = '';

  void _setPath(String path) {
    setState(() {
      this.path = path;
      print("set path, path = ${this.path}");
    });
  }

  @override
  Widget build(BuildContext context) {
      if(!inited) {
        _setPath(ToolUtils.getYGOPath());
        inited = true;
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text("选择你的ygo路径"),
        ),
        body: Center(
            child: FilePickerWidget.show(path, chooseFile, saveSettings),
        ),
      );
  }

  Future<void> chooseFile() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory != null) {
      _setPath(selectedDirectory);
    }
  }

  void saveSettings() {
    String filePath = ConstUtils.SETTINGS_PATH;
    try {
      File file = File(filePath);
      ToolUtils.globalSetting.filePath = path;
      String str = const JsonEncoder().convert(ToolUtils.globalSetting);
      file.writeAsString(str);
      Navigator.pop(context, path);
    } catch(e) {
      print(e);
    }
  }
}