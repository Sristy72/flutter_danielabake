import 'get_item_ingredient.dart';

class GetPopularItemResponseModel {
  final int total;
  final int page;
  final int pages;
  final List<PopularItem> items;

  GetPopularItemResponseModel({
    required this.total,
    required this.page,
    required this.pages,
    required this.items,
  });

  factory GetPopularItemResponseModel.fromJson(Map<String, dynamic> json) {
    return GetPopularItemResponseModel(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pages: json['pages'] ?? 1,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PopularItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}


class PopularItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final List<String> images;
  final ItemCategory category;
  final List<ItemIngredient> ingredients;
  final double rating;
  final int reviewsCount;
  final List<String> specialDays;
  final String createdAt;
  final String updatedAt;

  PopularItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.images,
    required this.category,
    required this.ingredients,
    required this.rating,
    required this.reviewsCount,
    required this.specialDays,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PopularItem.fromJson(Map<String, dynamic> json) {
    return PopularItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: ItemCategory.fromJson(json['category'] ?? {}),
      ingredients: (json['ingredients'] as List<dynamic>? ?? [])
          .map((e) => ItemIngredient.fromJson(e))
          .toList(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: (json['reviewsCount'] as num?)?.toInt() ?? 0,
      specialDays: List<String>.from(json['specialDays'] ?? []), // ✅ FIXED
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}



class ItemCategory {
  final String id;
  final String name;
  final String image;

  ItemCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
