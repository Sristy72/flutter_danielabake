class GetCartResponseModel {
  final String id;
  final String user;
  final List<CartItem> items;
  final double total;
  final String createdAt;
  final String updatedAt;

  GetCartResponseModel({
    required this.id,
    required this.user,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GetCartResponseModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>? ?? [];
    return GetCartResponseModel(
      id: json['_id'],
      user: json['user'],
      items: itemsList
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .where((cartItem) => cartItem.item != null) // Optional: filter out deleted items
          .toList(),
      total: (json['total'] as num).toDouble(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class CartItem {
  final String id;
  final ItemDetails? item;
  int quantity;

  CartItem({
    required this.id,
     this.item,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final itemJson = json['item'];
    return CartItem(
      id: json['_id'] as String,
      item: itemJson == null
          ? null
          : ItemDetails.fromJson(itemJson as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }
}

class ItemDetails {
  final String id;
  final String name;
  final double price;
  final String description;
  final String image;

  ItemDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json["description"],
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }
}