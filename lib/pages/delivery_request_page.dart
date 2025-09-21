import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'delivery_confirmation.dart';
import 'item_details_page.dart'; // NEW PAGE

class DeliveryRequestPage extends StatelessWidget {
  final String userId;
  const DeliveryRequestPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Requests"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("deliveries")
            .where("assignedDriverID", isEqualTo: userId)
            .where("status", isEqualTo: "In_delivery")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No delivery requests available."));
          }

          final deliveries = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: deliveries.length,
            itemBuilder: (context, index) {
              final data = deliveries[index].data() as Map<String, dynamic>;
              final deliveryId = deliveries[index].id;

              // format time
              String formatted = "";
              if (data["deliveredAt"] != null) {
                final ts = data["deliveredAt"] as Timestamp;
                formatted =
                    DateFormat('yyyy/MM/dd, hh:mm a').format(ts.toDate());
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DeliveryConfirmationScreen(deliveryId: deliveryId),
                    ),
                  );
                },
                child: Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Info icon in top-right corner
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          icon: const Icon(Icons.info_outline,
                              color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ItemDetailsPage(deliveryId: deliveryId),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order ID: ${data["orderId"] ?? deliveryId}",
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text("Pick Up: ${data["pickupAddress"] ?? "-"}"),
                            Text(
                                "Destination: ${data["dropoffAddress"] ?? "-"}"),
                            Text(
                                "Requested by: ${data["partRequesterName"] ?? "-"}"),
                            Text("Delivered by: $formatted"),
                            const SizedBox(height: 4),
                            Text(
                              "Status: ${data["status"] ?? "Incomplete"}",
                              style: TextStyle(
                                color: (data["status"] == "confirmed")
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}