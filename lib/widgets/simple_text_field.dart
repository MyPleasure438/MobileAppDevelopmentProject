import 'package:flutter/material.dart';

class SimpleTextField extends StatefulWidget {
  const SimpleTextField({super.key, required this.labelText, required this.fontSize, required this.textFamily, required this.isBold, required this.isItalic, required this.inputKeyboardType, required this.controller});
  final String labelText;
  final double fontSize;
  final String textFamily;
  final bool isBold;
  final bool isItalic;
  final String inputKeyboardType;
  final TextEditingController? controller;

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  late final TextEditingController textCtrl;

  @override
  void initState() {
    super.initState();
    textCtrl = widget.controller ?? TextEditingController(); // use parent’s controller if passed
  }

  String getTextContent(){
    return textCtrl.text;
  }

  double getTextNumbersContent(){
    double textNumbers = double.parse(textCtrl.text);
    return textNumbers;
  }

  @override

  Widget build(BuildContext context) {
    final keyboardType = widget.inputKeyboardType == "n"
        ? TextInputType.number
        : widget.inputKeyboardType == "t"
        ? TextInputType.text
        : null;

    return TextField(controller: textCtrl,decoration: InputDecoration(labelText: widget.labelText,),
      style: TextStyle(fontSize: widget.fontSize,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          fontFamily: widget.textFamily),
      keyboardType: keyboardType,
    );
  }
}