/*
class Delivery {
  final String id;
  final String assignedDriverID;
  final String status;
  final String pickupAddress;
  final String dropoffAddress;
  final DateTime createdAt;

  Delivery({
    required this.id,
    required this.assignedDriverID,
    required this.status,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.createdAt,
  });

  factory Delivery.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Delivery(
      id: doc.id,
      assignedDriverID: data['assignedDriverID'] ?? "",
      status: data['status'] ?? "",
      pickupAddress: data['pickupAddress'] ?? "",
      dropoffAddress: data['dropoffAddress'] ?? "",
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
*/