import 'package:flutter/material.dart';
import 'package:object_recognition/res/colors.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {super.key, this.title, this.textsize, this.textcolor, this.fontweight});
  final String? title;
  final double? textsize;
  final Color? textcolor;
  final FontWeight? fontweight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      style: TextStyle(
          color: textcolor ?? fullWhiteColor,
          fontSize: textsize ?? 14,
          fontWeight: fontweight ?? FontWeight.w300),
    );
  }
}
