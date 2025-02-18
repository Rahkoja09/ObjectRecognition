import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_recognition/res/colors.dart';
import 'package:object_recognition/res/constante.dart';
import 'package:object_recognition/view/header/components/type_of_flash.dart';

class FlashLight extends StatefulWidget {
  const FlashLight({super.key, required this.cameraControlleur});
  final CameraController cameraControlleur;

  @override
  State<FlashLight> createState() => _FlashLightState();
}

class _FlashLightState extends State<FlashLight> {
  String selectedMode = "Auto";

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: primaryColor.withOpacity(0.2),
      offset: const Offset(0, 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: secondarytColor, width: 0.5),
      ),
      onSelected: (String value) {
        setState(
          () {
            selectedMode = value;
            switch (value) {
              case ("Auto"):
                {
                  widget.cameraControlleur.setFlashMode(FlashMode.auto);
                }
              case ("Off"):
                {
                  widget.cameraControlleur.setFlashMode(FlashMode.off);
                }
              case ("On"):
                {
                  widget.cameraControlleur.setFlashMode(FlashMode.always);
                }
            }
          },
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "Auto",
          child: SizedBox(
            child: Center(
              child: TypeOfFlash(
                icons: Icons.flash_auto_outlined,
              ),
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: "On",
          child: SizedBox(
            child: TypeOfFlash(
              icons: Icons.flash_on,
            ),
          ),
        ),
        PopupMenuItem<String>(
          value: "Off",
          child: SizedBox(
            child: TypeOfFlash(
              icons: Icons.flash_off,
            ),
          ),
        ),
      ],
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: deffaultPadding / 4),
          Icon(
            selectedMode == "Auto"
                ? Icons.flash_auto_outlined
                : selectedMode == "On"
                    ? Icons.flash_on
                    : Icons.flash_off,
            color: fourthColor,
            size: 20,
          ),
          SizedBox(width: deffaultPadding),
        ],
      ),
    );
  }
}
