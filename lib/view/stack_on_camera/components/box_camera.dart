import 'package:flutter/material.dart';
import 'package:object_recognition/res/colors.dart';

class BoxCamera extends StatelessWidget {
  const BoxCamera({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(240, 240), 
      painter: CameraFramePainter(),
    );
  }
}

class CameraFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = secondarytColor
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double gap = size.width * 0.1; // Espace au centre des bords
    double length = size.width * 0.15; // Longueur des coins

    // Dessiner les coins
    Path path = Path()
      ..moveTo(0, length) 
      ..lineTo(0, 0)
      ..lineTo(length, 0)
      ..moveTo(size.width - length, 0) 
      ..lineTo(size.width, 0)
      ..lineTo(size.width, length)
      ..moveTo(size.width, size.height - length) 
      ..lineTo(size.width, size.height)
      ..lineTo(size.width - length, size.height)
      ..moveTo(length, size.height) 
      ..lineTo(0, size.height)
      ..lineTo(0, size.height - length);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
