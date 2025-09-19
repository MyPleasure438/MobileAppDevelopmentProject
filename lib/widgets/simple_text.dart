import 'package:flutter/material.dart';

class SimpleText extends StatelessWidget {
  const SimpleText({super.key, required this.text, required this.fontSize, required this.textFamily, required this.isBold, required this.isItalic,}); //Constructor of this widget
  final String text;
  final double fontSize;
  final String textFamily;
  final bool isBold;
  final bool isItalic;

  //The build function is responsible for building the widget's UI
  @override
  Widget build(BuildContext context) {
    //It returns a MaterialApp widget
    return Text(text, style: TextStyle(fontSize: fontSize,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        fontFamily: textFamily),
    );
  }
}