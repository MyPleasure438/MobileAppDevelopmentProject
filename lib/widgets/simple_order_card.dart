import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String source;
  final String destination;
  final String deadline;
  final VoidCallback onAssign;

  OrderCard({
    super.key,
    required this.source,
    required this.destination,
    required this.deadline,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "from $source",
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.arrow_downward),
            Text(
              "to $destination",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              "by $deadline complete.",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Do you want to take this delivery?",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: onAssign,
              child: const Text("Yes, Assign to me!"),
            ),
          ],
        ),
      ),
    );
  }
}
