import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:object_recognition/StateManager/cursor_position_notifier.dart';
import 'package:object_recognition/res/colors.dart';

class Touchpad extends ConsumerStatefulWidget {
  Touchpad({super.key, required this.isDoubleTap, required this.activateBtn});
  bool isDoubleTap;
  VoidCallback activateBtn;

  @override
  ConsumerState<Touchpad> createState() => _TouchpadState();
}

class _TouchpadState extends ConsumerState<Touchpad> {
  bool greenDot = false;
  late Timer _timer;
  Offset previousPosition = Offset.zero;

  final double touchpadWidth = 100;
  final double touchpadHeight = 65;
  final double cursorSize = 20;

  @override
  void initState() {
    super.initState();
    _startClignotement();
  }

  void _onDoubleTap() {
    widget.isDoubleTap = !widget.isDoubleTap;
  }

  void _startClignotement() {
    _timer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      setState(() {
        greenDot = true;
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    previousPosition = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final cursorNotifier = ref.read(cursorPositionProvider.notifier);

    Offset newCursorPos = ref.read(cursorPositionProvider) +
        (details.localPosition - previousPosition);

    cursorNotifier.updatePosition(newCursorPos);

    previousPosition = details.localPosition;
  }

  void _onPanEnd(DragEndDetails details) {
    previousPosition = Offset.zero;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cursorPosition = ref.watch(cursorPositionProvider);

    return Stack(
      children: [
        GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onDoubleTap: _onDoubleTap,
          child: Container(
            height: touchpadHeight,
            width: touchpadWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1),
              color: fourthColor.withOpacity(0.7),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),

        // Icône de swipe
        Positioned(
          bottom: 3,
          right: 10,
          child: Icon(
            Icons.swipe,
            size: 15,
            color: blackColor.withOpacity(0.7),
          ),
        ),

        // Point clignotant
        Positioned(
          top: 5,
          right: 7,
          child: Icon(
            Icons.circle,
            size: 6,
            color: greenDot
                ? const Color.fromARGB(255, 3, 255, 12)
                : Colors.black.withOpacity(0.3),
          ),
        ),
      ],
    );
  }
}
