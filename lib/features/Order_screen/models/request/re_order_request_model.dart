class ReOrderRequestModel {
  final String userId;

  ReOrderRequestModel({
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }

  factory ReOrderRequestModel.fromJson(Map<String, dynamic> json) {
    return ReOrderRequestModel(
      userId: json['userId'] as String,
    );
  }
}
