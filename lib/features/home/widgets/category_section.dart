import 'package:danielabake/features/profile_screens/screens/favorite_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_controller.dart';
import '../screens/food_item_by_category.dart';
import 'category_card.dart';
import '../../../core/common/shimmer/shimmer_loader.dart';
import '../../../core/common/shimmer/shimmer_placeholders.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoryController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _buildCategoryShimmer(),
          ),
        );
      }

      final response = controller.category.value;

      if (response == null) {
        return const SizedBox();
      }

      final categories = response.data; // List<Category>

      return SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length, //FIXED
          //padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final cat = categories[index];
            if (cat.name.toLowerCase() == "favorite items") {
              return CategoryCard(
                title: cat.name,
                imageUrl: cat.image,
                bgColor: Color(cat.bgColor),
                onTap: () => Get.to(() => const FavoriteItems()),
              );
            } else {
              return CategoryCard(
                title: cat.name,
                imageUrl: cat.image,
                bgColor: Color(cat.bgColor),
                onTap: () {
                  Get.to(
                    () => FoodListScreen(
                      categoryId: cat.id,
                      categoryName: cat.name,
                    ),
                  );
                },
              );
            } //FIXED
          },
        ),
      );
    });
  }

  Widget _buildCategoryShimmer() {
    return ShimmerLoader(
      isLoading: true,
      child: Container(
        width: 130, // Approximate width of CategoryCard
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerPlaceholders.circle(diameter: 70),
            const SizedBox(height: 12),
            ShimmerPlaceholders.textLine(
              width: 80,
              height: 16,
              borderRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
