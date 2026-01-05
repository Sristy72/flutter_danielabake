//import '../../models/response/get_popular_items_response_model.dart';

import '../../models/response/get_item_by_category_id_response_model.dart';
import '../../models/response/get_item_ingredient.dart';

class FoodModel {
  final String id;
  final String title;
  final String description;
  final String image; // network or asset
  final String price; // network or asset
  final List<ItemIngredient> ingredients;
  final double rating;
  final int reviewsCount;

  FoodModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.ingredients, required this.rating, required this.reviewsCount,
  });
}

