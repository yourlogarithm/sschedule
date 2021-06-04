import 'package:flutter/material.dart';

class Circle extends CustomPainter {
  late double radius;
  late Offset offset;
  late Color color;

  Circle({required this.radius, required this.offset, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    //a circle
    canvas.drawCircle(offset, radius, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


class Lines extends CustomPainter {
  final timeColor;
  Lines({this.timeColor});
  @override
  void paint(Canvas canvas, Size size){
    final paint = Paint()
      ..color = timeColor
      ..strokeWidth = 2.5;
    canvas.drawLine(
        Offset(0, size.height * 0.1),
        Offset(size.width/2, size.height * 0.1),
        paint
    );
    canvas.drawLine(
        Offset(0, size.height/2),
        Offset(size.width/1.5, size.height/2),
        paint
    );
    canvas.drawLine(
        Offset(0, size.height * 0.9),
        Offset(size.width/2, size.height * 0.9),
        paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate){
    return true;
  }
}