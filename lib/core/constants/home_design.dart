import 'package:flutter/material.dart';

class HomeDesign {
  const HomeDesign._();

  static const double cardRadius = 24;
  static const double spacing = 8;
  static const Color cyan = Color(0xFF53E3F3);
  static const Color navy = Color(0xFF0B1D2B);
  static const Color teal = Color(0xFF0B5961);

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1D2B), Color(0xFF0B5961)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF73F0F6), Color(0xFF25C5D5)],
  );

  static const LinearGradient helpGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEAF9FB), Color(0xFFF2F1FF)],
  );

  static const List<BoxShadow> cardShadows = [
    BoxShadow(color: Color(0x120B1D2B), blurRadius: 24, offset: Offset(0, 10)),
  ];

  static const List<BoxShadow> heroShadows = [
    BoxShadow(color: Color(0x260B1D2B), blurRadius: 28, offset: Offset(0, 16)),
  ];
}
