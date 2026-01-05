class ItemIngredient {
  final String id;
  final String name;
  final bool isAllergen;
  final String? image;

  ItemIngredient({
    required this.id,
    required this.name,
    required this.isAllergen,
    this.image,
  });

  factory ItemIngredient.fromJson(Map<String, dynamic> json) {
    return ItemIngredient(
      id: json['_id'],
      name: json['name'],
      isAllergen: json['isAllergen'],
      image: json['image'],
    );
  }
}
