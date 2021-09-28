import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_background_tool/data_class/const.dart';
import 'package:image/image.dart' as dartImg;
import 'package:my_background_tool/utils/tool_utils.dart';
import 'package:widget_to_image/widget_to_image.dart';
import 'custom_rect_clipper.dart';
class CardChangePage extends StatefulWidget {
  const CardChangePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CardChangePageState();
  }
}

class _CardChangePageState extends State<CardChangePage> {
  String path = ToolUtils.getYGOPath();
  double leftOffset = 0;
  double topOffset = 0;
  dartImg.Image? imageInfo;

  final GlobalKey _globalKey = GlobalKey();
  String originalCardPath = "";
  String givenImagePath = "";
  double maxLeftOffset = 0;
  double maxTopOffset = 0;
  double imgScale = 1.0;
  bool sample = true;
  @override
  Widget build(BuildContext context) {

    ExtendedImage img;
    if (originalCardPath.isNotEmpty) {
      img = createExImage(originalCardPath);
      sample = false;
    } else {
      img = createExImage(ConstUtils.SAMPLE_IMAGE);
    }

    Image givenImg;
    if (givenImagePath.isNotEmpty) {
      imageInfo = dartImg.decodeImage(File(givenImagePath).readAsBytesSync());
      givenImg = createGivenImage(givenImagePath, imgScale);
    } else {
      imageInfo = dartImg.decodeImage(File(ConstUtils.SAMPLE_IMAGE2).readAsBytesSync());
      givenImg = createGivenImage(ConstUtils.SAMPLE_IMAGE2, imgScale);
    }
    updateOffsets();

    return Scaffold(
      appBar: AppBar(
        title: Text("更换卡图"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(sample? "此图为样例，请勿保存":"",
                    style: TextStyle(fontSize: 20, color: Colors.red)),
                ElevatedButton(
                    onPressed: chooseOriginalCardImage, child: Text("选择原卡图")),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: chooseNewCardImage, child: Text("选择替换图")),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: saveCardImage, child: Text("应用卡图替换")),
                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: backToDefault, child: Text("恢复全部原卡图")),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: imgScale,
                    onChanged: scaleChanged,
                    min: 0.2,
                    max: 3.0,
                    divisions: 200,
                  ),
                ),
                SizedBox(height: 50,),
                RepaintBoundary(
                  key: _globalKey,
                  child: Stack(
                    // alignment: Alignment(0.0, 0.0),
                    children: [
                      img,
                      Positioned(
                        left: ConstUtils.LEFT_START,
                        top: ConstUtils.TOP_START,
                        child: SizedBox(
                          width: ConstUtils.CARD_IMAGE_WIDTH,
                          height: ConstUtils.CARD_IMAGE_HEIGHT,
                          child: ColoredBox(color: Colors.black,),),
                      ),
                      Positioned(
                        left: ConstUtils.LEFT_START - leftOffset,
                        top: ConstUtils.TOP_START - topOffset,
                        child: ClipPath(
                          clipper: CustomRectClipper(leftOffset, topOffset),
                          child: givenImg,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: Slider(
                    value: leftOffset,
                    onChanged: leftOffsetChanged,
                    min: 0,
                    max: maxLeftOffset,
                    divisions: (imageInfo!.width * imgScale / 10).round(),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 300,
              child:
              RotatedBox(
                quarterTurns: 1,
                child: Slider(
                    value: topOffset,
                    onChanged: topOffsetChanged,
                    min: 0,
                    max: maxTopOffset,
                    divisions: (imageInfo!.height * imgScale / 10).round()),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> chooseOriginalCardImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择你想修改的卡图原图, 可在 ygo目录/picture/card 找到",
        type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        originalCardPath = result.files.single.path!;
        print("img path chosen : imagePath = $originalCardPath");
      });
    }
  }

  ExtendedImage createExImage(String path) {
    return ExtendedImage.file(
      File(path),
      fit: BoxFit.fill,
      width: 322,
      height: 470,
    );
  }

  Image createGivenImage(String givenImagePath, double scale) {
    return Image.file(
      File(givenImagePath),
      fit: BoxFit.fitWidth,
      scale: 1/scale,
    );
  }

  void leftOffsetChanged(double value) {
    setState(() {
      leftOffset = value;
    });
  }

  void topOffsetChanged(double value) {
    setState(() {
      topOffset = value;
    });
  }

  void scaleChanged(double value) {
    setState(() {
      imgScale = value;
      updateOffsets();
      leftOffset = leftOffset > maxLeftOffset? maxLeftOffset : leftOffset;
      topOffset = topOffset > maxTopOffset? maxTopOffset : topOffset;
    });
  }

  void updateOffsets() {
    maxLeftOffset = (imageInfo!.width * imgScale) -
        ConstUtils.CARD_IMAGE_WIDTH;
    maxTopOffset = (imageInfo!.height * imgScale) -
        ConstUtils.CARD_IMAGE_HEIGHT;
    maxLeftOffset = maxLeftOffset > 0 ? maxLeftOffset : 1;
    maxTopOffset = maxTopOffset > 0 ? maxTopOffset : 1;
    print("maxOffset: $maxLeftOffset, $maxTopOffset");
  }

  Future<void> chooseNewCardImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: "选择你想修改成的图",
        type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        givenImagePath = result.files.single.path!;
        print("img path chosen : givenImagePath = $givenImagePath");
      });
    }
  }

  Future<void> saveCardImage() async {
    if(originalCardPath.isNotEmpty) {
      try {
        ByteData byteData = await WidgetToImage.repaintBoundaryToImage(_globalKey);
        List<int> data = byteData.buffer.asInt8List();
        bool res = ToolUtils.copyOriginalFileToBackup(originalCardPath);
        File(originalCardPath).writeAsBytesSync(data);
        if(res) {
          ToolUtils.showCommonDialog(context, "替换成功，备份成功");
        } else {
          ToolUtils.showCommonDialog(context, "替换成功，备份失败，请告知开发者以解决此问题");
        }
      } catch(e) {
        ToolUtils.showCommonDialog(context, "替换发生错误，请检查读写权限，可尝试用管理员身份运行该程序");
      }
    } else {
      ToolUtils.showCommonDialog(context, "请先选择原图");
    }

  }

  void backToDefault() {
    int res = ToolUtils.copyBackupFileToOriginal();
    if(res >= 0) {
      ToolUtils.showCommonDialog(context, "恢复备份成功");
    } else {
      String errorMessage = "";
      switch(res) {
        case -1 : errorMessage = "备份目录不存在，没有已备份的文件"; break;
        case -2 : errorMessage = "目标路径错误, 检查原卡图路径"; break;
        case -3 : errorMessage = "未知错误，请尝试用管理员身份运行"; break;
        default: errorMessage = "发生了未知的错误"; break;
      }
      ToolUtils.showCommonDialog(context, errorMessage);
    }
  }
}
