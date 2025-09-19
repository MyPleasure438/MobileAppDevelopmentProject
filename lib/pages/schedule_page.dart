import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: SimpleText(
              text: "Delivery Schedule View",
              fontSize: 25,
              textFamily: "Times New Roman",
              isBold: true,
              isItalic: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Row(
              children: [
                const SimpleText(
                  text: "View",
                  fontSize: 15,
                  textFamily: "Times New Roman",
                  isBold: true,
                  isItalic: true,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SimpleCalendar(
                    labelText: "Select a Date",
                    fontSize: 15,
                    textFamily: "Times New Roman",
                    isBold: true,
                    isItalic: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SimpleCalendar(
                    labelText: "Select a Date",
                    fontSize: 15,
                    textFamily: "Times New Roman",
                    isBold: true,
                    isItalic: true,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: SimpleText(
              text: "Delivered by [insert date]",
              fontSize: 25,
              textFamily: "Times New Roman",
              isBold: true,
              isItalic: true,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SimpleText(
                text: "Pending",
                fontSize: 25,
                textFamily: "Times New Roman",
                isBold: true,
                isItalic: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
