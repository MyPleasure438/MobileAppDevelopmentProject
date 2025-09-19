import 'package:flutter/material.dart';

class SimpleCalendar extends StatefulWidget {
  const SimpleCalendar({super.key, required this.labelText, required this.fontSize, required this.textFamily, required this.isBold, required this.isItalic});
  final String labelText;
  final double fontSize;
  final String textFamily;
  final bool isBold;
  final bool isItalic;


  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  final textCtrl = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    textCtrl.dispose(); //
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    textCtrl.text = selectedDate == null
        ? ''
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";



    return TextFormField(
      readOnly: true, // prevent manual typing
      decoration: InputDecoration(labelText: widget.labelText, labelStyle: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          fontFamily: widget.textFamily),
        border: OutlineInputBorder(),
      ),
      controller: textCtrl,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),       // default today
          firstDate: DateTime(2000),         // earliest allowed
          lastDate: DateTime(2100),          // latest allowed
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });
        }
      },
    );
  }
}