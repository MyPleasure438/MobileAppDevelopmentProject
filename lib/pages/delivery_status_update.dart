import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:practical_assignment_project/pages/edit_delivery_page.dart';
import 'delivery_confirmation.dart'; // import your confirmation page

class DeliveryUpdatePage extends StatelessWidget {
  final String userId;
  const DeliveryUpdatePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delivery Status Update"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("deliveries")
            .where("assignedDriverID", isEqualTo: userId)
            .snapshots(), // listen to all deliveries
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
              String formated = "";
              if (data["deliveredAt"] != null) {
                final ts = data["deliveredAt"] as Timestamp;
                formated = DateFormat('yyyy/MM/dd, hh:mm a').format(ts.toDate());
              }

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditDeliveryPage(
                        deliveryId: deliveryId, // pass the document ID
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Colors.grey[200],
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${data["orderId"] ?? deliveryId}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Pick Up: ${data["pickupAddress"] ?? "-"}"),
                        Text("Destination: ${data["dropoffAddress"] ?? "-"}"),
                        Text("Requested by: ${data["partRequesterName"] ?? "-"}"),
                        Text("Delivered by: $formated "),
                        Text("Instructions: ${data["notes"] ?? "-"}"),
                        const SizedBox(height: 4),
                        Text(
                          "Status: ${data["status"] ?? "Pending"}",
                          style: TextStyle(
                            color: (data["status"] == "In_delivery")
                                ? Colors.orange
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
