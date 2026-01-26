class CheckoutRequestModel {
  final String userId;
  final String address;
  final String phone;
  final DateTime scheduledFor;

  CheckoutRequestModel({
    required this.userId,
    required this.address,
    required this.phone,
    required this.scheduledFor,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'address': address,
      'phone': phone,
      'scheduledFor': scheduledFor.toIso8601String(),
    };
  }
}
