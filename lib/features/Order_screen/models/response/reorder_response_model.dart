class ReorderResponseModel {
  final String id;
  final String user;
  final List<CartItemModel> items;
  final int total;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  ReorderResponseModel({
    required this.id,
    required this.user,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory ReorderResponseModel.fromJson(Map<String, dynamic> json) {
    return ReorderResponseModel(
      id: json['_id'],
      user: json['user'],
      items: (json['items'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      total: json['total'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      version: json['__v'],
    );
  }
}

class CartItemModel {
  final String id;
  final String item;
  final int quantity;

  CartItemModel({
    required this.id,
    required this.item,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['_id'],
      item: json['item'],
      quantity: json['quantity'],
    );
  }
}
