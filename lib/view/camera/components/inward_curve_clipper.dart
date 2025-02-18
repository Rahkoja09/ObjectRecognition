import 'dart:ui';

import 'package:flutter/material.dart';

class OutwardCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double curveDepth = 14; // Profondeur du bombé
    Path path = Path();

    path.moveTo(size.width, 0); // Départ en haut à droite
    path.lineTo(0, 0); // Aller à gauche

    // 🌀 BOMBÉ VERS L'EXTÉRIEUR sur le côté gauche
    path.quadraticBezierTo(
      curveDepth * 2, size.height / 2, // Point de contrôle pour le bombé
      0, size.height, // Fin de la courbe
    );

    path.lineTo(size.width, size.height); // Bas à droite
    path.close(); // Ferme le chemin

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
