import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String source;
  final String destination;
  final String deadline;
  final String status;
  final bool isAssignedToMe;
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
    // Header text
    String headerText = status == "pending"
        ? "Pending"
        : isAssignedToMe && status == "in_delivery"
        ? "Currently delivering"
        : "Delivery";

    // Button logic
    bool showButton = status == "pending" || (status == "in_delivery" && isAssignedToMe);
    String buttonText = "";
    if (status == "pending") {
      buttonText = "I'm delivering now!";
    } else if (status == "in_delivery" && isAssignedToMe) {
      buttonText = "Cancel delivery";
    }

    // Button color
    Color buttonColor = status == "pending" ? Colors.orange : Colors.red;

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isAssignedToMe ? Colors.orange : Colors.red,
          width: 3,
        ),
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
