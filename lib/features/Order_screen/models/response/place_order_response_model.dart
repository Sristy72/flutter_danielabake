class OrderItem {
  final String item;
  final int quantity;
  final String id;

  OrderItem({
    required this.item,
    required this.quantity,
    required this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      item: json['item'] ?? '',
      quantity: json['quantity'] ?? 0,
      id: json['_id'] ?? '',
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


class PlaceOrderResponseModel {
  final String user;
  final List<OrderItem> items;
  final double totalAmount;
  final String address;
  final String phone;
  final String status;
  final bool pickOrder;
  final String paymentStatus;
  final DateTime? scheduledFor;
  final String estimatedDelivery;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  PlaceOrderResponseModel({
    required this.user,
    required this.items,
    required this.totalAmount,
    required this.address,
    required this.phone,
    required this.status,
    required this.pickOrder,
    required this.paymentStatus,
    required this.scheduledFor,
    required this.estimatedDelivery,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return PlaceOrderResponseModel(
      user: json['user'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e))
          .toList() ??
          [],
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      pickOrder: json['pickOrder'] ?? false,
      scheduledFor: json['scheduledFor'] != null
          ? DateTime.parse(json['scheduledFor'])
          : null,
      estimatedDelivery: json['estimatedDelivery'] ?? '',
      id: json['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'address': address,
      'phone': phone,
      'status': status,
      'paymentStatus': paymentStatus,
      if (scheduledFor != null)
        'scheduledFor': scheduledFor!.toIso8601String(),
      'estimatedDelivery': estimatedDelivery,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

