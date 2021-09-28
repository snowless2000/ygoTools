import 'package:flutter/cupertino.dart';
import 'package:my_background_tool/data_class/const.dart';


class CustomRectClipper extends CustomClipper<Path> {
  CustomRectClipper(this.leftOffset, this.topOffset);
  double leftOffset;
  double topOffset;
  @override
  Path getClip(Size size) {
    final path = Path();
    double startY = topOffset ;
    double startX = leftOffset;
    path.moveTo(startX, startY);
    path.lineTo(startX + ConstUtils.CARD_IMAGE_WIDTH, startY);
    path.lineTo(startX + ConstUtils.CARD_IMAGE_WIDTH, startY + ConstUtils.CARD_IMAGE_HEIGHT);
    path.lineTo(startX, startY + ConstUtils.CARD_IMAGE_HEIGHT);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomRectClipper oldClipper) => true;
}