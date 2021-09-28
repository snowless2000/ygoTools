import 'package:flutter/cupertino.dart';

class TrapezoidClipper extends CustomClipper<Path> {
  TrapezoidClipper({this.top = 800, this.bottom = 1600});
  double top = 800;
  double bottom = 1600;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2 - top/2, 0.0);
    path.lineTo(size.width / 2 + top/2, 0.0);
    path.lineTo(size.width / 2 + bottom/2, size.height);
    path.lineTo(size.width / 2 - bottom/2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TrapezoidClipper oldClipper) => true;
}
