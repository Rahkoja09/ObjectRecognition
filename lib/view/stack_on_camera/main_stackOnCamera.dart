import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:object_recognition/StateManager/cursor_position_notifier.dart';
import 'package:object_recognition/view/stack_on_camera/components/box_camera.dart';

class MainStackoncamera extends StatefulWidget {
  const MainStackoncamera({super.key});

  @override
  State<MainStackoncamera> createState() => _MainStackoncameraState();
}

class _MainStackoncameraState extends State<MainStackoncamera> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final cursorPosition = ref.watch(cursorPositionProvider);
        final size = MediaQuery.of(context).size;

        double boxWidth = 240.0;
        double boxHeight = 240.0;

        double leftPosition = cursorPosition.dx;
        double topPosition = cursorPosition.dy;

        // limitation du box dans le camera
        if (leftPosition < 0) leftPosition = 0;
        if (leftPosition > size.width - boxWidth)
          leftPosition = size.width - boxWidth;
        if (topPosition < 0) topPosition = 0;
        if (topPosition > size.height - boxHeight)
          topPosition = size.height - boxHeight;

        return Positioned(
          left: leftPosition * 2,
          top: topPosition * 2,
          child: AbsorbPointer(
            child: GestureDetector(
              onPanUpdate: null,
              child: BoxCamera(),
            ),
          ),
        );
      },
    );
  }
}
