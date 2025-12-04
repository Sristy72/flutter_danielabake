class OrderResponse {
  final String? id;
  final String? user;
  final List<CartItem>? items;
  final num? total;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  OrderResponse({
    this.id,
    this.user,
    this.items,
    this.total,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['_id'],
      user: json['user'],
      items: json['items'] != null
          ? List<CartItem>.from(json['items'].map((x) => CartItem.fromJson(x)))
          : [],
      total: json['total'],
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
      json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'items': items?.map((x) => x.toJson()).toList(),
      'total': total,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
    };
  }
}

class CartItem {
  final String? item;
  final int? quantity;
  final String? id;

  CartItem({
    this.item,
    this.quantity,
    this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      item: json['item'],
      quantity: json['quantity'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item': item,
      'quantity': quantity,
      '_id': id,
    };
  }
}
