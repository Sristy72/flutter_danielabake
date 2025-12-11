import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/shimmer/shimmer_loader.dart';
import '../../../core/common/shimmer/shimmer_placeholders.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../home/widgets/popular_items.dart';

class FavoriteItems extends StatefulWidget {
  const FavoriteItems({super.key});

  @override
  State<FavoriteItems> createState() => _FavoriteItemsState();
}

class _FavoriteItemsState extends State<FavoriteItems> {
  final _favoriteFoodController = Get.put(FavoriteFoodController());

  @override
  void initState() {
    super.initState();
    _favoriteFoodController.fetchFavoriteItem(); // Already called in onInit, but safe to call again
  }

  // Build a single shimmer card (same size as real FoodCard)
  Widget _buildShimmerCard() {
    return ShimmerLoader(
      isLoading: true,
      child: Container(
        //margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Expanded(
              flex: 6,
              child: ShimmerPlaceholders.rectangle(
                borderRadius: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholders.textLine(height: 16, borderRadius: 8),
                  const SizedBox(height: 8),
                  ShimmerPlaceholders.textLine(width: 80, height: 14, borderRadius: 6),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerPlaceholders.textLine(width: 60, height: 20, borderRadius: 10),
                      ShimmerPlaceholders.circle(diameter: 40),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    double font(double v) => v * (width / 390);

    int gridCount = width > 900
        ? 4
        : width > 650
        ? 3
        : 2;

    return AppScaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Favorite Items',
          style: TextStyle(
            fontSize: font(17),
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: EdgeInsets.only(bottom: width * 0.04, top: height * 0.02, left: 16),
            child: Text(
              'Your All Favorite Items',
              style: TextStyle(
                color: Colors.black,
                fontSize: font(15),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              final isLoading = _favoriteFoodController.isLoading.value;
              final items = _favoriteFoodController.favoriteItems;

              // Show shimmer when loading
              if (isLoading) {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridCount,
                    mainAxisExtent: height * 0.3,
                    crossAxisSpacing: width * 0.035,
                    mainAxisSpacing: height * 0.02,
                  ),
                  itemCount: 6, // Show 6 shimmer cards as placeholder
                  itemBuilder: (context, index) => _buildShimmerCard(),
                );
              }

              // Show empty state
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No favorite items found.',
                    style: TextStyle(
                      fontSize: font(13),
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              // Show real data
              return GridView.builder(
                //padding: const EdgeInsets.all(16),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridCount,
                  mainAxisExtent: height * 0.3,
                  crossAxisSpacing: width * 0.035,
                  mainAxisSpacing: height * 0.02,
                ),
                itemBuilder: (_, index) {
                  final food = items[index].item;

                  return FoodCard(
                    imagePath: food!.image,
                    title: food.name,
                    price: food.price.toString(),
                    itemId: food.id,
                    isFavorite: true.obs,
                    description: '',
                    onAdd: () => print('Add ${food.name}'),
                    onFavoriteToggle: (val) async {
                      if (!val) {
                        await _favoriteFoodController.removeFavorite(food.id);
                      }
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
