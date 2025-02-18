import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_recognition/view/header/components/flash_light.dart';
import 'package:object_recognition/view/header/components/logo.dart';

class MainHeader extends StatefulWidget {
  const MainHeader({super.key, required this.cameraController});
  final CameraController cameraController;

  @override
  State<MainHeader> createState() => _MainHeaderState();
}

class _MainHeaderState extends State<MainHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // logo -----
        Logo(),
        // flash light -----
        FlashLight(cameraControlleur: widget.cameraController),
      ],
    ));
  }
}
