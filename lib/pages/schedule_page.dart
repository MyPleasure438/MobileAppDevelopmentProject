import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class SecondPage extends StatelessWidget {
  SecondPage({super.key});

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
          Padding(
            padding: EdgeInsets.only(top: 10, left: 0, right: 0),
            child: Align(
              alignment: Alignment.center,
              child: OrderCard(
                source: "Pandan Indah",
                destination: "Jalan Jasmine",
                deadline: "11:00AM",
                onAssign: () {
                  // 👉 This will run when the button is pressed
                  print("Assigned order from Workshop Bay E.S. to Workshop Bay 69");

                  // Example: navigate to another page
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => OrderDetailsPage()),
                  // );

                  // Example: update backend
                  // FirebaseFirestore.instance.collection("orders").doc("123").update({
                  //   "assigned": true,
                },


              ),
            ),
          )


        ],
      ),
    );
  }
}
