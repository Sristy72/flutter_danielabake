import 'dart:developer' as DPrint;
import 'package:danielabake/core/common/widgets/appbar_text.dart';
import 'package:danielabake/core/common/widgets/text_with_view_all_button.dart';
import 'package:danielabake/features/home/controller/favorite_food_controller.dart';
import 'package:danielabake/features/home/controller/home_controller.dart';
import 'package:danielabake/features/home/screens/all_category_screen.dart';
import 'package:danielabake/features/home/screens/all_popular_items.dart';
import 'package:danielabake/features/home/widgets/category_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/cart.dart';
import '../../Order_screen/controller/order_controller.dart';
import '../widgets/grid_layout.dart';
import '../widgets/models/detail_food_model.dart';
import '../widgets/popular_items.dart';
import '../widgets/responsive.dart';
import '../widgets/weekly_menu_slider.dart';
import 'food_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = Get.find<HomeController>();
  final _favoriteFoodController = Get.find<FavoriteFoodController>();
  final _cartController = Get.find<OrderController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarText(text: 'Place an order'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Cart(),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: rw(context, 0.03)),

              Text('Weekly Menu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              //Add slider here
              SizedBox(height: rw(context, 0.02)),

              const WeeklyMenuSlider(),

              // /// Responsive Banner
              // GestureDetector(
              //   onTap: () {},
              //   child: SizedBox(
              //     height: rw(context, 0.50), // FIXED for all screens
              //     width: double.infinity,
              //     child: Image.asset(
              //       Images.discount,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),

              SizedBox(height: rw(context, 0.03)),

              TextWithViewAllButton(
                text: 'Select by Category',
                onTap: () => Get.to(() => AllCategoryScreen()),
              ),
              CategorySection(),

              SizedBox(height: rw(context, 0.05)),

              TextWithViewAllButton(
                text: 'Today\'s Items',
                onTap: () => Get.to(() => AllPopularItems()),
              ),

              SizedBox(height: rw(context, 0.03)),

              /// Popular Items Grid
              Obx(() {
                final data = _homeController.popularItem.value;

                if (data == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridLayout(
                  // mainAxisExtent: MediaQuery.of(context).size.height * 0.30, // smaller height
                  itemCount: data.items.length,
                  itemBuilder: (_, index) {
                    final item = data.items[index];
                    final isFavorite = false.obs;

                    return GestureDetector(
                      onTap: () {
                        Get.to(() => FoodDetailScreen(
                          food: FoodModel(
                            title: item.name,
                            description: item.description,
                            image: item.image,
                            ingredients: item.ingredients
                                .map((e) => e.name)
                                .toList(),
                            price: item.price.toString(),
                            id: item.id, rating: item.rating, reviewsCount: item.reviewsCount,
                          ),
                        ));
                      },
                      child: FoodCard(
                        imagePath: item.image,
                        title: item.name,
                        description: item.description,
                        price: item.price.toString(),
                        itemId: item.id,
                        isFavorite: isFavorite,
                        onAdd: () async {
                          try {
                            await _cartController.addCart(item.id, 1);
                            Get.snackbar('Success', '${item.name} added to cart', backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(12),
                                  duration: const Duration(seconds: 2),);
                          } catch (e) {
                            Get.snackbar(
                                'Error', 'Failed to add ${item.name} to cart');
                          }
                        },
                        onFavoriteToggle: (newValue) async {
                          try {
                            if (newValue) {
                              await _favoriteFoodController.favorite(item.id);
                              isFavorite.value = true;
                            } else {
                              await _favoriteFoodController
                                  .removeFavorite(item.id);
                              isFavorite.value = false;
                            }
                          } catch (e) {
                            DPrint.log("Favorite toggle error: $e");
                          }
                        }, rating: item.rating, reviewCount: item.reviewsCount,
                      ),
                    );
                  },
                );
              }),

              //SizedBox(height: rw(context, 0.05)),
            ],
          ),
        ),
      ),
    );
  }
}
