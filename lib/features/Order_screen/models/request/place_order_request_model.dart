class CheckoutRequestModel {
  final String userId;
  final String address;
  final String phone;
  final DateTime scheduledFor;
  final DateTime scheduledTo;
  final bool pickOrder;

  CheckoutRequestModel({
    required this.userId,
    required this.address,
    required this.phone,
    required this.scheduledFor,
    required this.scheduledTo,
    required this.pickOrder,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'address': address,
      'phone': phone,
      'scheduledFor': scheduledFor.toIso8601String(),
      'scheduledTo': scheduledTo.toIso8601String(),
      'pickOrder': pickOrder,
    };
  }
}
