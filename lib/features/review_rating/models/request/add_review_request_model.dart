class AddReviewRequestModel {
  final String userId;
  final String itemId;
  final String orderId;
  final int rating;
  final String comment;

  AddReviewRequestModel({
    required this.userId,
    required this.itemId,
    required this.orderId,
    required this.rating,
    required this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "itemId": itemId,
      "orderId": orderId,
      "rating": rating,
      "comment": comment,
    };
  }
}
