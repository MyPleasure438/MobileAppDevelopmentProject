import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DeliveryConfirmationScreen extends StatefulWidget {
  final String deliveryId; // pass the deliveryId when navigating


  const DeliveryConfirmationScreen({super.key, required this.deliveryId});

  @override
  State<DeliveryConfirmationScreen> createState() =>
      _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState
    extends State<DeliveryConfirmationScreen> {
  // image file
  File? _attachedImage;
  final ImagePicker _picker = ImagePicker();

  // signature controller
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );


  Future<void> _pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _attachedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitDelivery(Map<String, dynamic> deliveryData) async {
    if (_attachedImage == null || _signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please attach a photo and signature")),
      );
      return;
    }

    // Check if all items are delivered
    List items = deliveryData["items"] ?? [];
    bool allDelivered =
    items.every((item) => item["delivered"] == true);

    if (!allDelivered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please confirm all items delivered")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection("deliveries")
          .doc(widget.deliveryId)
          .set({
        "status": "Confirmed",
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Delivery confirmed ")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Delivery Confirmation",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: const [

        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("deliveries")
            .doc(widget.deliveryId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          List items = data["items"] ?? [];
          Timestamp ts = data["deliveredAt"];
          DateTime dt = ts.toDate();

          // Format: 2025/07/08, 10:30 AM
          String formatted = DateFormat('yyyy/MM/dd, hh:mm a').format(dt);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order details card
                Card(
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order ID: ${widget.deliveryId}",
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text("Pick Up: ${data["pickupAddress"] ?? "-"}"),
                        Text("Destination: ${data["dropoffAddress"] ?? "-"}"),
                        Text("Requested by: ${data["partRequesterName"] ?? "-"}"),
                        Text("Delivered By:$formatted" ?? "-"),
                        const SizedBox(height: 4),
                        Text("Status: ${data["status"] ?? "Pending"}",),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Dynamic Item Table
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    // Header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey[300]),
                      children: const [
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Qty",
                                style:
                                TextStyle(fontWeight: FontWeight.bold))),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Item Name",
                                style:
                                TextStyle(fontWeight: FontWeight.bold))),
                        Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("Confirm Delivery",
                                style:
                                TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    // Dynamic rows
                    ...items.asMap().entries.map((entry) {
                      int index = entry.key;
                      var item = entry.value;

                      return TableRow(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(item["qty"].toString())),
                          Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(item["name"])),
                          Checkbox(
                            value: item["delivered"] ?? false,
                            onChanged: (val) async {
                              items[index]["delivered"] = val ?? false;
                              await FirebaseFirestore.instance
                                  .collection("deliveries")
                                  .doc(widget.deliveryId)
                                  .update({"items": items});
                            },
                          ),
                        ],
                      );
                    })
                  ],
                ),
                const SizedBox(height: 20),

                // Photo
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _attachedImage == null
                      ? const Center(
                    child: Icon(Icons.image,
                        size: 60, color: Colors.grey),
                  )
                      : Image.file(_attachedImage!, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),

                TextButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_box_outlined),
                  label: const Text("Attach Photo"),
                ),
                const SizedBox(height: 16),

                // Signature
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Signature:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Signature(
                        controller: _signatureController,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => _signatureController.clear(),
                          child: const Text("Clear Signature"),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Confirm button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _submitDelivery(data),
                  child: const Text("Confirm Delivery",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
