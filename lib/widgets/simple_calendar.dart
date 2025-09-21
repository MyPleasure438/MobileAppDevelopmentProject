import 'package:flutter/material.dart';

class SimpleCalendar extends StatefulWidget {
  final String labelText;
  final double fontSize;
  final String textFamily;
  final bool isBold;
  final bool isItalic;
  final Function(DateTime) onDateSelected; // 🔹 callback

  const SimpleCalendar({
    super.key,
    required this.labelText,
    required this.fontSize,
    required this.textFamily,
    required this.isBold,
    required this.isItalic,
    required this.onDateSelected,
  });

  @override
  State<SimpleCalendar> createState() => _SimpleCalendarState();
}

class _SimpleCalendarState extends State<SimpleCalendar> {
  final textCtrl = TextEditingController();
  DateTime? selectedDate;

  @override
  void dispose() {
    textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textCtrl.text = selectedDate == null
        ? ''
        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";

    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.isBold ? FontWeight.bold : FontWeight.normal,
          fontStyle: widget.isItalic ? FontStyle.italic : FontStyle.normal,
          fontFamily: widget.textFamily,
        ),
        border: const OutlineInputBorder(),
      ),
      controller: textCtrl,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
          });

          widget.onDateSelected(pickedDate); // 🔹 pass back up
        }
      },
    );
  }
}
