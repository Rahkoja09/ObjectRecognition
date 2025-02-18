import 'dart:async';

import 'package:flutter/material.dart';
import 'package:object_recognition/res/colors.dart';

class Logo extends StatefulWidget {
  const Logo({super.key});

  @override
  State<Logo> createState() => _LogoState();
}

class _LogoState extends State<Logo> {
  bool redDot = true;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    clignotement();
  }

  clignotement() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        redDot = !redDot;
      });
    });
  }

  @override
  void dispose() {
    clignotement();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "OR",
        style: TextStyle(
            color: fourthColor, fontSize: 20, fontWeight: FontWeight.w700),
        children: [
          TextSpan(
            text: ".",
            style: TextStyle(
                color: redDot ? Colors.white : Colors.red, fontSize: 26),
          ),
          TextSpan(
            text: " (Object Recognition)",
            style: TextStyle(
                fontSize: 12, color: fourthColor, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
