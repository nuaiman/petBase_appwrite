import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(ThemeData.dark());

  void chnageTheme() {
    if (state == ThemeData.light()) {
      state = ThemeData.dark();
    } else {
      state = ThemeData.light();
    }

    if (state == ThemeData.dark()) {
      state = ThemeData.light();
    } else {
      state = ThemeData.dark();
    }
  }
}
// -----------------------------------------------------------------------------

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
