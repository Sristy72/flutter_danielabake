class GetReviewResponseModel {
  final String id;
  final User user;
  final String item;
  final String order;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  GetReviewResponseModel({
    required this.id,
    required this.user,
    required this.item,
    required this.order,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return GetReviewResponseModel(
      id: json['_id'] ?? '',
      user: User.fromJson(json['user']),
      item: json['item'] ?? '',
      order: json['order'] ?? '',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
