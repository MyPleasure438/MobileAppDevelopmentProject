import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/widgets.dart';
import 'package:intl/intl.dart'; // 🔹 for formatting dates
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
      //appBar: AppBar(title: const Text("Login Page")),
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
                  return const Center(child: CircularProgressIndicator());
                }

                print(" Docs returned: ${snapshot.data?.docs.length}");

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No deliveries for this date"),
                  );
                }

                final docs = snapshot.data!.docs;

                // 🔍 Debugging
                print("Selected date: $selectedDate");
                for (var doc in docs) {
                  final ts = doc["deliveredAt"] as Timestamp?;
                  print("Delivery doc ${doc.id} => ${ts?.toDate()}");
                }

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    final deadline = data["deliveredAt"] != null
                        ? DateFormat("dd/MM/yyyy HH:mm").format(
                      (data["deliveredAt"] as Timestamp).toDate(),
                    )
                        : "No deadline";

                    final status = data["status"] ?? "pending";
                    final assignedDriver = data["assignedDriverID"];
                    final currentUser = CurrentUser().userID;

                    return OrderCard(
                      source: data["pickupAddress"] ?? "Unknown",
                      destination: data["dropoffAddress"] ?? "Unknown",
                      deadline: deadline,
                      status: status, //  pass status
                      isAssignedToMe: assignedDriver == currentUser, // ✅ true if this driver owns it
                      onAssign: () async {
                        if (status == "assigned" && assignedDriver == currentUser) {
                          // Driver starts delivery
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Start delivery?"),
                              content: const Text("Do you want to mark this order as 'In Delivery'?"),
                              actions: [
                                TextButton(
                                  child: const Text("Not yet"),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                ElevatedButton(
                                  child: const Text("I’m delivering now!"),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection("deliveries")
                                .doc(docs[index].id)
                                .update({
                              "status": "in_delivery", // 🔹 mark delivery as started
                            });
                          }
                        } else if (status == "in_delivery" && assignedDriver == currentUser) {
                          // Driver cancels/backs out
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Cancel delivery?"),
                              content: const Text(
                                  "Do you want to stop delivering this order and return it to 'Assigned' status?"),
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
                                .doc(docs[index].id)
                                .update({
                              "status": "assigned", // 🔹 roll back to assigned
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

  /// 🔧 Firestore query for the logged-in driver and selected date
  Stream<QuerySnapshot> _queryDeliveriesForDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final driverID = CurrentUser().userID; // use your custom ID like u0005
    print(
        "📅 Querying deliveries from $startOfDay to $endOfDay for driver: $driverID");

    return FirebaseFirestore.instance
        .collection("deliveries") // ✅ must match write
        .where("deliveredAt",
        isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("deliveredAt", isLessThan: Timestamp.fromDate(endOfDay))
        .where("assignedDriverID",
        isEqualTo:
        driverID) // ✅ only deliveries for this driver will show
        .snapshots();
  }
}
