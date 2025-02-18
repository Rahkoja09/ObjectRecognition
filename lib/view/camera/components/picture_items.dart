import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:object_recognition/res/colors.dart';
import 'package:object_recognition/res/constante.dart';
import 'package:object_recognition/view/camera/components/inward_curve_clipper.dart';
import 'package:object_recognition/view/camera/components/touchpad.dart';

class PictureItems extends StatefulWidget {
   PictureItems(
      {super.key,
      required this.cameraController,
       required this.isDoubleTap, required this.activateBtn
});
  final CameraController cameraController;
  bool isDoubleTap;
  VoidCallback activateBtn;


  @override
  State<PictureItems> createState() => _PictureItemsState();
}

Future<void> _takeAndSavePicture(CameraController cameraController) async {
  try {
    XFile takePicture = await cameraController.takePicture();

    Gal.putImage(takePicture.path);
  } catch (e) {
    print("Erreur pendant la prise de photo : $e");
  }
}

class _PictureItemsState extends State<PictureItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              await _takeAndSavePicture(widget.cameraController);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border:
                    Border.all(color: fourthColor.withOpacity(0.5), width: 2),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: fourthColor.withOpacity(0.9)),
                child: Icon(
                  Icons.camera_alt,
                  color: blackColor,
                  size: 35,
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipPath(
              clipper: OutwardCurveClipper(),
              child: Touchpad(isDoubleTap: widget.isDoubleTap, activateBtn: widget.activateBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
