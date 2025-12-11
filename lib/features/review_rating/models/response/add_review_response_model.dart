class AddReviewResponseModel {
  final String id;
  final String user;
  final String item;
  final String order;
  final int rating;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final int v;

  AddReviewResponseModel({
    required this.id,
    required this.user,
    required this.item,
    required this.order,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AddReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return AddReviewResponseModel(
      id: json["_id"],
      user: json["user"],
      item: json["item"],
      order: json["order"],
      rating: json["rating"],
      comment: json["comment"],
      createdAt: json["createdAt"],
      updatedAt: json["updatedAt"],
      v: json["__v"],
    );
  }
}
