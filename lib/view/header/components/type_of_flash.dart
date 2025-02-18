import 'package:flutter/material.dart';
import 'package:object_recognition/res/colors.dart';
import 'package:object_recognition/res/constante.dart';

class TypeOfFlash extends StatefulWidget {
  const TypeOfFlash({super.key, required this.icons});

  final IconData icons;

  @override
  State<TypeOfFlash> createState() => _TypeOfFlashState();
}

class _TypeOfFlashState extends State<TypeOfFlash> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        widget.icons,
        size: 20,
        color: fourthColor,
      ),
    );
  }
}
