import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widgets/widgets.dart';
import '../database/current_user.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: SimpleText(
              text: "Delivery Schedule View",
              fontSize: 25,
              textFamily: "Times New Roman",
              isBold: true,
              isItalic: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Row(
              children: [
                const SimpleText(
                  text: "View:",
                  fontSize: 20,
                  textFamily: "Times New Roman",
                  isBold: true,
                  isItalic: false,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SimpleCalendar(
                    labelText: "Select a Date",
                    fontSize: 15,
                    textFamily: "Times New Roman",
                    isBold: true,
                    isItalic: true,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: selectedDate == null
                ? const Center(child: Text("Please select a date"))
                : StreamBuilder<QuerySnapshot>(
              stream: _queryDeliveriesForDate(selectedDate!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No deliveries for this date"));
                }

                final docs = snapshot.data!.docs;
                final currentUser = CurrentUser().userID;

                // Only show pending or assigned to me
                final visibleDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final assignedDriver = data["assignedDriverID"];
                  final status = data["status"] ?? "pending";

                  // Show if pending and unassigned or assigned to current user
                  return (status == "pending" && (assignedDriver == null || assignedDriver == "null")) ||
                      (assignedDriver == currentUser);
                }).toList();


                if (visibleDocs.isEmpty) {
                  return const Center(child: Text("No deliveries for this date"));
                }

                return ListView.builder(
                  itemCount: visibleDocs.length,
                  itemBuilder: (context, index) {
                    final data = visibleDocs[index].data() as Map<String, dynamic>;
                    final assignedDriver = data["assignedDriverID"];
                    final status = data["status"] ?? "pending";
                    final deadline = data["deliveredAt"] != null
                        ? DateFormat("dd/MM/yyyy HH:mm").format(
                      (data["deliveredAt"] as Timestamp).toDate(),
                    )
                        : "No deadline";

                    return OrderCard(
                      source: data["pickupAddress"] ?? "Unknown",
                      destination: data["dropoffAddress"] ?? "Unknown",
                      deadline: deadline,
                      status: status,
                      assignedDriverID: assignedDriver,
                      currentUserID: currentUser,
                      onAssign: () async {
                        // your existing onAssign logic here
                      },
                    );
                  },
                );

              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _queryDeliveriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    print("📅 Querying deliveries from $startOfDay to $endOfDay");

    return FirebaseFirestore.instance
        .collection("deliveries")
        .where("deliveredAt", isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("deliveredAt", isLessThan: Timestamp.fromDate(endOfDay))
        .snapshots();
  }
}