import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String source;
  final String destination;
  final String deadline;
  final String status; //  delivery status
  final bool isAssignedToMe; //  checks whether this driver owns it
  final VoidCallback onAssign;

  const OrderCard({
    super.key,
    required this.source,
    required this.destination,
    required this.deadline,
    required this.status,
    required this.isAssignedToMe,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    //  Decide header text
    String headerText;
    if (status == "pending") {
      headerText = "Pending";
    } else if (isAssignedToMe && status == "assigned") {
      headerText = "Assigned to me";
    } else if (isAssignedToMe && status == "in_delivery") {
      headerText = "Currently delivering";
    } else {
      headerText = "Assigned to another driver";
    }

    //  Decide button label
    String buttonText = "";
    if (isAssignedToMe && status == "assigned") {
      buttonText = "I’m delivering now!";
    } else if (isAssignedToMe && status == "in_delivery") {
      buttonText = "Cancel delivery";
    }

    bool showButton = buttonText.isNotEmpty;

    // Border color logic
    Color borderColor = Colors.grey;
    if (isAssignedToMe && status == "assigned") {
      borderColor = Colors.red; // red if assigned to me
    } else if (isAssignedToMe && status == "in_delivery") {
      borderColor = Colors.orange; // orange if currently delivering
    }

    // Button color logic
    Color buttonColor = Colors.orange;
    if (buttonText == "Cancel delivery") {
      buttonColor = Colors.red; // cancel button is red
    }

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 3), //  dynamic border
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 Header
            Text(
              headerText,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // 🔹 Pickup/Dropoff
            Text(
              "From: $source",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const Icon(Icons.arrow_downward),
            Text(
              "To: $destination",
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // 🔹 Deadline
            Text(
              "Deadline: $deadline",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // 🔹 Action button
            if (showButton)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: onAssign,
                child: Text(buttonText),
              ),
          ],
        ),
      ),
    );
  }
}
