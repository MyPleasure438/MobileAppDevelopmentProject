import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const DeliveryConfirmationScreen(),
    );
  }
}

class DeliveryConfirmationScreen extends StatefulWidget {
  const DeliveryConfirmationScreen({super.key});

  @override
  State<DeliveryConfirmationScreen> createState() => _DeliveryConfirmationScreenState();
}

class _DeliveryConfirmationScreenState extends State<DeliveryConfirmationScreen> {
  // checkboxes
  bool torqueMaster = false;
  bool flexiDrive = false;
  bool hydroCore = false;

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
    await _picker.pickImage(source: ImageSource.gallery); // or ImageSource.camera

    if (pickedFile != null) {
      setState(() {
        _attachedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitDelivery() async {
    // Example: Export signature as PNG
    final signature = await _signatureController.toPngBytes();

    // You can now send:
    // - signature (PNG bytes)
    // - _attachedImage (File)
    // - checkbox states
    // to your backend or local storage

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Delivery confirmed! (Signature & image captured)")),
    );
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
          onPressed: () {
            Navigator.pop(context); // Go back to previous screen
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Delivery Confirmation",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
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
                  children: const [
                    Text("Order ID: ORD_1234", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text("Pick Up: Workshop Bay E.S"),
                    Text("Destination: Workshop Bay 69"),
                    Text("Requested by : John"),
                    Text("Required By: 2025/07/08, 10:30AM"),
                    SizedBox(height: 4),
                    Text("Status: Incomplete",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Item Table
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              children: [
                // header row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  children: const [
                    Padding(padding: EdgeInsets.all(8), child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text("Item Name", style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text("Confirm Delivery", style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                // item rows
                TableRow(
                  children: [
                    const Padding(padding: EdgeInsets.all(8), child: Text("1")),
                    const Padding(padding: EdgeInsets.all(8), child: Text("TorqueMaster 9000")),
                    Checkbox(
                      value: torqueMaster,
                      onChanged: (val) => setState(() => torqueMaster = val ?? false),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(padding: EdgeInsets.all(8), child: Text("1")),
                    const Padding(padding: EdgeInsets.all(8), child: Text("FlexiDrive Shaft")),
                    Checkbox(
                      value: flexiDrive,
                      onChanged: (val) => setState(() => flexiDrive = val ?? false),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(padding: EdgeInsets.all(8), child: Text("2")),
                    const Padding(padding: EdgeInsets.all(8), child: Text("HydroCorePiston")),
                    Checkbox(
                      value: hydroCore,
                      onChanged: (val) => setState(() => hydroCore = val ?? false),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Photo placeholder (shows selected image if available)
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _attachedImage == null
                  ? const Center(
                child: Icon(Icons.image, size: 60, color: Colors.grey),
              )
                  : Image.file(_attachedImage!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),

            // Attach photo
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.add_box_outlined),
              label: const Text("Attach Photo"),
            ),
            const SizedBox(height: 16),

            // Signature pad
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Signature:", style: TextStyle(fontWeight: FontWeight.bold)),
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
              onPressed: _submitDelivery,
              child: const Text("Confirm Delivery", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
