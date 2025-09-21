import 'package:flutter/material.dart';
class OrderCard extends StatelessWidget {
  final String source;
  final String destination;
  final String deadline;
  final String status;
  final String? assignedDriverID;
  final String? currentUserID;
  final VoidCallback onAssign;

  const OrderCard({
    super.key,
    required this.source,
    required this.destination,
    required this.deadline,
    required this.status,
    required this.assignedDriverID,
    required this.currentUserID,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    // Header text
    String headerText;
    if (status == "pending") {
      headerText = "Pending";
    } else if (assignedDriverID == currentUserID && status == "assigned") {
      headerText = "Assigned to me";
    } else if (assignedDriverID == currentUserID && status == "in_delivery") {
      headerText = "Currently delivering";
    } else {
      headerText = "Assigned to another driver";
    }

    // Button logic
    bool showButton = false;
    String buttonText = "";

    final isAssigned = assignedDriverID != null && assignedDriverID != "null";

    if (!isAssigned && status == "pending") {
      showButton = true;
      buttonText = "Assign to me!";
    } else if (assignedDriverID == currentUserID && status == "assigned") {
      showButton = true;
      buttonText = "I’m delivering now!";
    } else if (assignedDriverID == currentUserID && status == "in_delivery") {
      showButton = true;
      buttonText = "Cancel delivery";
    }


    // Border color
    Color borderColor = Colors.grey;
    if (assignedDriverID == currentUserID && status == "assigned") {
      borderColor = Colors.red;
    } else if (assignedDriverID == currentUserID && status == "in_delivery") {
      borderColor = Colors.orange;
    }

    // Button color
    Color buttonColor = Colors.orange;
    if (buttonText == "Cancel delivery") buttonColor = Colors.red;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 3),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              headerText,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
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
            Text(
              "Deadline: $deadline",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
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