import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryListPage extends StatelessWidget {
  const DeliveryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deliveries")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('deliveries').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          var docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data["partRequesterName"] ?? "No requester"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Status: ${data["status"] ?? "unknown"}"),
                    Text("Pickup: ${data["pickupAddress"] ?? "N/A"}"),
                    Text("Dropoff: ${data["dropoffAddress"] ?? "N/A"}"),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}