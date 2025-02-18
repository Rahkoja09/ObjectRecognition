import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// Gère la position du curseur
class CursorPositionNotifier extends StateNotifier<Offset> {
  CursorPositionNotifier() : super(const Offset(30, 50));
  void updatePosition(Offset newPosition) {
    state = newPosition; // Met à jour l'état
  }
}

// Provider global
final cursorPositionProvider =
    StateNotifierProvider<CursorPositionNotifier, Offset>((ref) {
  return CursorPositionNotifier();
});
