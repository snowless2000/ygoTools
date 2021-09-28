import 'dart:io';

import 'package:blur/blur.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_background_tool/route/route_path.dart';
import 'package:my_background_tool/ui/pick_file.dart';
import 'package:my_background_tool/utils/tool_utils.dart';

class BackgroundChangePage extends StatefulWidget {
  BackgroundChangePage({Key? key}) : super(key: key);
  String title = "壁纸更换";
  @override
  State<StatefulWidget> createState() {
    return _BackgroundChangePageState();
  }

}

class _BackgroundChangePageState extends State<BackgroundChangePage> {
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "选择你要替换的壁纸：",
              style: TextStyle(
                  fontSize: 20
              ),),
            const SizedBox(height: 10),
            FilePickerWidget.show(imagePath, chooseImage, changeBackground),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: intentToAdvancedSetting, child: const Text("高级设置")),

          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void changeBackground() {
    if(imagePath.isNotEmpty) {
      String original = "";
      if(ToolUtils.getYGOVersion() == 2) {
        original = ToolUtils.getYGOPath() + r"\texture\common\desk.jpg";
      } else {
        original = ToolUtils.getYGOPath() + r"\texture\bg.jpg";
      }
      try {
        File originalFile = File(original);
        if(originalFile.existsSync()) {
          originalFile.deleteSync();
        }
        File newImage = File(imagePath);
        //todo: blur the image and save
        Image img = Image.file(newImage);
        img.blurred(
          colorOpacity: 0.2,
        );

        newImage.copySync(original);

        ToolUtils.showCommonDialog(context, "壁纸替换成功");
      } catch(e) {
        print(e);
      }

    }
  }
  void chooseImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择你想作为背景的图片",
        type: FileType.image
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        imagePath = result.files.single.path!;
        print("img path chosen : imagePath = $imagePath");
      });
    }
  }

  void intentToAdvancedSetting() async {
    var result;
    if(imagePath.isNotEmpty && imagePath != "" && ToolUtils.getYGOPath().isNotEmpty) {
      print('with args, path = $imagePath');
      result = await Navigator.pushNamed(context, advancedSetting, arguments: imagePath);
    } else {
      ToolUtils.showCommonDialog(context, "请先选择ygo目录并挑选一张图片再进入！");
    }

    if(result != null && (result as String) != "NULL") {
      print("高级设置返回 result = $result");
      setState(() {
        imagePath = result as String;
      });
    }
  }
}