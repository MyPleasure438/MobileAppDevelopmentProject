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

          // Show deliveries for that date
          Expanded(
            child: selectedDate == null
                ? const Center(
              child: Text("Please select a date"),
            )
                : StreamBuilder<QuerySnapshot>(
              stream: _queryDeliveriesForDate(selectedDate!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No deliveries for this date"),
                  );
                }

                final docs = snapshot.data!.docs;
                final currentUser = CurrentUser().userID;

                // Filter: pending without driver OR in_delivery assigned to current user
                final visibleDocs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final status = data["status"] ?? "Pending";
                  final assignedDriver = data["assignedDriverID"];

                  return (status == "Pending" &&
                      (assignedDriver == null ||
                          assignedDriver == "null" ||
                          assignedDriver == "")) ||
                      (status == "In_delivery" &&
                          assignedDriver == currentUser);
                }).toList();

                if (visibleDocs.isEmpty) {
                  return const Center(
                    child: Text("No deliveries to show"),
                  );
                }

                return ListView.builder(
                  itemCount: visibleDocs.length,
                  itemBuilder: (context, index) {
                    final data =
                    visibleDocs[index].data() as Map<String, dynamic>;
                    final assignedDriver = data["assignedDriverID"];
                    final status = data["status"] ?? "Pending";
                    final deliveredAtUtc = (data["deliveredAt"] as Timestamp).toDate().toUtc();
                    final deliveredAtMalaysia = deliveredAtUtc.add(const Duration(hours: 8));
                    final deadline = DateFormat("dd/MM/yyyy HH:mm").format(deliveredAtMalaysia);


                    return OrderCard(
                      source: data["pickupAddress"] ?? "Unknown",
                      destination: data["dropoffAddress"] ?? "Unknown",
                      deadline: deadline,
                      status: status,
                      isAssignedToMe: assignedDriver == currentUser,
                      onAssign: () async {
                        if (status == "Pending") {
                          // Claim delivery
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Claim delivery?"),
                              content: const Text(
                                  "Do you want to claim this delivery and start delivering?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  child: const Text("I'm delivering now!"),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection("deliveries")
                                .doc(visibleDocs[index].id)
                                .update({
                              "status": "In_delivery",
                              "assignedDriverID": currentUser,
                            });
                          }
                        } else if (status == "In_delivery" && assignedDriver == currentUser) {
                          // Cancel delivery
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Cancel delivery?"),
                              content: const Text(
                                  "Do you want to stop delivering this order and return it to 'Pending' status?"),
                              actions: [
                                TextButton(
                                  child: const Text("Keep it"),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  child: const Text("Cancel delivery"),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection("deliveries")
                                .doc(visibleDocs[index].id)
                                .update({
                              "status": "Pending",
                              "assignedDriverID": "null", // or null if your logic accepts it
                            });
                          }
                        }
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

  /// 🔧 Query all deliveries for selected date (no status filter here)
  Stream<QuerySnapshot> _queryDeliveriesForDate(DateTime date) {
    // Start/end of selected date in MYT (local)
    final startOfDayLocal = DateTime(date.year, date.month, date.day);
    final endOfDayLocal = startOfDayLocal.add(const Duration(days: 1));

    // Convert to UTC correctly for Firestore query
    final startOfDayUtc = startOfDayLocal.subtract(const Duration(hours: 8));
    final endOfDayUtc = endOfDayLocal.subtract(const Duration(hours: 8));


    print("Querying UTC: $startOfDayUtc to $endOfDayUtc");

    return FirebaseFirestore.instance
        .collection("deliveries")
        .where("deliveredAt",
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDayUtc))
        .where("deliveredAt",
        isLessThan: Timestamp.fromDate(endOfDayUtc))
        .orderBy("deliveredAt")
        .snapshots();
  }



}
