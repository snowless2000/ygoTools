import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:my_background_tool/ui/trapezoid_cliper.dart';
import 'package:my_background_tool/utils/tool_utils.dart';

class PngImagePainter extends CustomPainter {
  PngImagePainter({
    this.image,
  });

  ui.Image? image;

  @override
  void paint(Canvas canvas, Size size) {
    _drawCanvas(size, canvas);
    _saveCanvas(size);
  }

  Canvas _drawCanvas(Size size, Canvas canvas) {
    // final center = Offset(1920/2, 1080/2);
    // // final center = Offset(150, 50);
    // double radius = 500;

    // The circle should be paint before or it will be hidden by the path
    // Paint paintCircle = Paint()..color = Colors.black;
    // Paint paintBorder = Paint()
    //   ..color = Colors.white
    //   ..strokeWidth = size.width / 36
    //   ..style = PaintingStyle.stroke;
    // canvas.drawCircle(center, radius, paintCircle);
    // canvas.drawCircle(center, radius, paintBorder);

    // double drawImageWidth = 0;
    // var drawImageHeight = -size.height * 0.8;

    // Path path = Path()
    //   ..addOval(Rect.fromLTWH(drawImageWidth, drawImageHeight,
    //       image!.width.toDouble(), image!.height.toDouble()));

    // canvas.clipPath(path);
    canvas.clipPath(TrapezoidClipper().getClip(const Size(1920,1080)));
    canvas.drawImage(image!, Offset(0,0), Paint());
    return canvas;
  }

  _saveCanvas(Size size) async {
    var pictureRecorder = ui.PictureRecorder();
    var canvas = Canvas(pictureRecorder);
    var paint = Paint();
    paint.isAntiAlias = true;

    _drawCanvas(size, canvas);

    var pic = pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(image!.width, image!.height);
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    var buffer = byteData!.buffer.asUint8List();

    File file = File("${ToolUtils.getExeDirectory()}testClip.png");
    file.writeAsBytesSync(buffer);

    print(file.path);
  }

  Future<ui.Image> getImage(Size size) async {
    var pictureRecorder = ui.PictureRecorder();
    var canvas = Canvas(pictureRecorder);
    var paint = Paint();
    paint.isAntiAlias = true;
    _drawCanvas(size, canvas);
    var pic = pictureRecorder.endRecording();
    ui.Image img = await pic.toImage(image!.width, image!.height);
    return img;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}