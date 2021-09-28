import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as dartImg;
import 'package:my_background_tool/data_class/const.dart';
import 'package:my_background_tool/ui/image_painter.dart';
import 'package:my_background_tool/ui/trapezoid_cliper.dart';
import 'package:widget_to_image/widget_to_image.dart';

class AdvancedSetting extends StatefulWidget {
  const AdvancedSetting({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdvancedSettingState();
}

class _AdvancedSettingState extends State<AdvancedSetting> {
  final GlobalKey _globalKey = GlobalKey();

  String imgPath = "";
  bool inited = false;

  double _sliderBlurTopWidth = 50;
  double _sliderBlurBottomWidth = 50;
  double _sliderBlur = 5;

  bool trapeBlur = false;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null && !inited) {
      _setPath((ModalRoute.of(context)?.settings.arguments) as String);
      inited = true;
    }

    Image img = Image.file(
        File(imgPath),
        height: 720,
        width: 1280,
        fit: BoxFit.fill,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("高级设置"),
      ),
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 1280,
              height: 720,
              child:
              RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    img,
                    ClipPath(child: SizedBox(width: 1280, height: 720).blurred(
                        blurColor: Colors.transparent,
                        blur: _sliderBlur * 0.4,
                        colorOpacity: 0
                    ), clipper: TrapezoidClipper(top: _sliderBlurTopWidth, bottom: _sliderBlurBottomWidth),)
                  ],
                ),
              ),
            ),
            createSlider("模糊顶宽", _sliderBlurTopWidth, (data) {
              setState(() {
                _sliderBlurTopWidth = data;
              });
            }, max: 1280),
            createSlider("模糊底宽", _sliderBlurBottomWidth, (data) {
              setState(() {
                _sliderBlurBottomWidth = data;
              });
            }, max: 1280),
            createSlider("模糊度", _sliderBlur, (data) {
              setState(() {
                _sliderBlur = data;
              });
            }, max: 50),
            SizedBox(height: 50),
            ElevatedButton(onPressed: clickSaveReboundary, child: Text("保存")),
          ],
        ),
      )
    );
  }

  void _setPath(String path) {
    setState(() {
      imgPath = path;
      print("进入高级设置， path = $imgPath");
    });
  }

  Widget createSlider(
      String name, double sliderValue, ValueChanged<double>? onChanged,
      {double min = 0.0, double max = 1000.0, int divisions = 1000}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(name),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          child: Slider(
              value: sliderValue,
              onChanged: onChanged,
              min: min,
              max: max,
              divisions: divisions,
              label: '$sliderValue',
              activeColor: Colors.green,
              inactiveColor: Colors.grey,
              semanticFormatterCallback: (double newValue) {
                return '${newValue.round()} dollars}';
              }),
          width: 500,
        )
      ],
    );
  }

  @Deprecated("useless now")
  bool saveImg() {
    //todo: testing
    try {
      dartImg.Image? image = dartImg.decodeImage(File(imgPath).readAsBytesSync());
      dartImg.Image? originalImage = dartImg.decodeImage(File(imgPath).readAsBytesSync());
      if (image != null && originalImage != null) {
        image = dartImg.copyResize(image,width: 1920,height: 1080);
        originalImage = dartImg.copyResize(originalImage, width: 1920, height: 1080);
        dartImg.Image bluredImage = dartImg.gaussianBlur(image, _sliderBlur.round());
        double ratio = image.width / 1280;
        double blurWidth = _sliderBlurTopWidth * ratio;
        double blurHeight = _sliderBlurBottomWidth * ratio;
        int blurX = (image.width / 2.0 - blurWidth / 2.0).round();
        int blurY = (image.height / 2.0 - blurHeight / 2.0).round();
        print("properties:\n blurWidth = $blurWidth\n blurHeight = $blurHeight\n blurX = $blurX\n blurY = $blurY\n imageHeight = ${image.height}\n bluredImageHeight = ${bluredImage.height}");
        dartImg.Image resultImg = dartImg.copyInto(
            originalImage,
            bluredImage,
            dstX: blurX,
            dstY: blurY,
            srcX: blurX,
            srcY: blurY,
            srcH: blurHeight.round(),
            srcW: blurWidth.round()
        );
        print("saving, imgPath: $imgPath");
        File f = File(ConstUtils.TEMP_IMAGE);
        f.writeAsBytesSync(dartImg.encodeJpg(resultImg));
        imgPath = f.absolute.path;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  @Deprecated("useless now")
  void clickSave() {
    if(!trapeBlur) {
      Future(saveImg).then((value) {
        Navigator.pop(context, imgPath);
        return true;
      });
    } else {
      Future(saveTrapeImg).then((value) {
        Navigator.pop(context, imgPath);
        return true;
      });
    }
  }

  @Deprecated("useless now")
  Future<bool> saveTrapeImg() async{
    dartImg.Image? originalImage = dartImg.decodeImage(File(imgPath).readAsBytesSync());
    if(originalImage != null) {
      dartImg.Image tempImage = dartImg.copyResize(originalImage, width: 1920, height: 1080);
      File(ConstUtils.TRAPE_IMAGE).writeAsBytesSync(dartImg.encodeJpg(tempImage));
      List<int> data1 = File(ConstUtils.TRAPE_IMAGE).readAsBytesSync();
      ui.Image img = await loadImage(data1);
      img = await PngImagePainter(image: img).getImage(Size(1920, 1080));
      ByteData? data = await img.toByteData();
      if(data != null) {
        dartImg.Image trapeImage = dartImg.Image.fromBytes(1920, 1080, data.buffer.asInt8List());
        trapeImage = dartImg.gaussianBlur(trapeImage, _sliderBlur.round());
        dartImg.Image resImage = dartImg.copyInto(tempImage, trapeImage, center: true);
        print("saving, imgPath: $imgPath");
        File f = File(ConstUtils.TEMP_IMAGE);
        f.writeAsBytesSync(dartImg.encodeJpg(resImage));
        imgPath = f.absolute.path;
        return true;
      }
    }
    return false;
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.fromList(img), (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  void clickSaveReboundary() async{
    Image img = Image.file(
      File(imgPath),
      height: 1080,
      width: 1920,
      fit: BoxFit.fill,
    );
    double ratio = 1080/720;
    ByteData byteData = await WidgetToImage.widgetToImage(
      Directionality(textDirection: TextDirection.ltr,
        child:  Container(
          width: 1920,
          height: 1080,
          child: Stack(
            children: [
              img,
              ClipPath(child: SizedBox(
                width: 1920,
                height: 1080,
              ).blurred(
                  blurColor: Colors.transparent,
                  blur: _sliderBlur * 0.4,
                  colorOpacity: 0
              ), clipper: TrapezoidClipper(top: _sliderBlurTopWidth * ratio, bottom: _sliderBlurBottomWidth * ratio),)
            ],
          ),
        )
      )
    );
    List<int> data = byteData.buffer.asInt8List();
    File(ConstUtils.TEMP_IMAGE).writeAsBytesSync(data);
    Navigator.pop(context, ConstUtils.TEMP_IMAGE);
  }
}
