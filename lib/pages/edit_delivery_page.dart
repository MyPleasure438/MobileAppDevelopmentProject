import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditDeliveryPage extends StatefulWidget {
  final String deliveryId; // pass the doc id

  const EditDeliveryPage({super.key, required this.deliveryId});

  @override
  State<EditDeliveryPage> createState() => _EditDeliveryPageState();
}

class _EditDeliveryPageState extends State<EditDeliveryPage> {
  final List<String> statusOptions = [
    "On-Delivery",
    "Delivered",
    "Pending",
    "Delayed",
    "Canceled"
  ];

  String? status; // current selected status (always kept to one of statusOptions or null)
  final TextEditingController _receiverController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();

  bool _initializedFromSnapshot = false; // guard to init controllers only once

  @override
  void dispose() {
    _receiverController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _saveEdits() async {
    // Validate or provide defaults
    final updatedStatus = status ?? statusOptions.first;
    final updatedReceiver = _receiverController.text.trim();
    final updatedInstructions = _instructionsController.text.trim();

    try {
      await FirebaseFirestore.instance
          .collection("deliveries")
          .doc(widget.deliveryId)
          .set({
        "status": updatedStatus,
        "partRequesterName": updatedReceiver,
        "notes": updatedInstructions,
      }, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved successfully")),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Delivery Details"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("deliveries")
            .doc(widget.deliveryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Delivery not found"));
          }

          final data = snapshot.data!.data()! as Map<String, dynamic>;

          // Initialize local UI state from firestore snapshot ONCE
          if (!_initializedFromSnapshot) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // safe to call setState in next frame
              final rawStatus = (data['status'] as String?) ?? '';
              // ensure status is one of our options; otherwise fallback
              final normalized =
              statusOptions.contains(rawStatus) ? rawStatus : statusOptions.first;

              setState(() {
                status = normalized;
                _receiverController.text = (data['partRequesterName'] as String?) ?? '';
                _instructionsController.text = (data['notes'] as String?) ?? '';
                _initializedFromSnapshot = true;
              });
            });
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("OrderID: ${widget.deliveryId}"),
                const SizedBox(height: 16),

                // Status dropdown
                DropdownButtonFormField<String>(
                  value: status, // may be null briefly until init runs
                  items: statusOptions
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() => status = val);
                  },
                  decoration: const InputDecoration(labelText: "Change Status"),
                ),

                const SizedBox(height: 12),

                // Receiver name
                TextFormField(
                  controller: _receiverController,
                  decoration: const InputDecoration(labelText: "Receiver Name"),
                ),

                const SizedBox(height: 12),

                // Notes / instructions
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(labelText: "New Instructions"),
                  maxLines: 3,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _saveEdits,
                      style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                      child: const Text("Confirm Edit"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Cancel Edit"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
