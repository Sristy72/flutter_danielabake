import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:danielabake/features/Order_screen/screens/checkout2.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../../core/utils/app_svg.dart';
import '../../review_rating/controllers/rating_controller.dart';
import '../../review_rating/widget/review_card.dart';
import '../controller/cart_controller.dart';
import '../widgets/ingredients_list.dart';
import '../widgets/models/detail_food_model.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodModel food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  final _orderController = Get.find<OrderController>();
  final ratingController = Get.find<RatingController>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final RxString selectedImage = ''.obs;



  final Rx<String?> currentUserId = Rx<String?>(null);
  final RxInt quantity = 0.obs;

  @override
  void initState() {
    super.initState();
    selectedImage.value = widget.food.image;
    _initializeQuantity();
    ratingController.getReview(widget.food.id);
    _loadCurrentUserId();// Fetch reviews
  }

  // No setState needed anymore
  void _loadCurrentUserId() async {
    final userId = await _authStorageService.getUserId();
    currentUserId.value = userId!; // This automatically triggers rebuild in Obx
  }

  void _initializeQuantity() async {
    /// Fetch latest cart data always
    await _orderController.fetchCart();

    /// Find this item in cart
    final cartItem = _orderController.cart.value?.items.firstWhereOrNull(
      (i) => i.item?.id == widget.food.id,
    );

    quantity.value = cartItem?.quantity ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),

      bottomNavigationBar: Obx(
        () => Container(
          color: const Color(0x2EFFB972),
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.food.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _squareButton(
                          icon: Icons.remove,
                          onTap: () {
                            if (quantity.value <= 0) return;

                            quantity.value--;
                            _orderController.removeOneItemFromCart(
                              widget.food.id,
                            );

                            /// refresh cart after removing
                            _orderController.fetchCart();
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            '${quantity.value}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _squareButton(
                          icon: Icons.add,
                          onTap: () {
                            quantity.value++;

                            /// call add API
                            _orderController.addCart(widget.food.id, 1);

                            /// refresh cart after adding
                            _orderController.fetchCart();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                PrimaryButton(
                    text: 'Place Order',
                    key: const Key("food-details-screen"),
                    onSimplePressed: () {
                      if (quantity.value == 0) {
                        Get.snackbar(
                          'No Item Added',
                          'First add an item to place your order',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white24,
                          colorText: Colors.black,
                          margin: const EdgeInsets.all(12),
                          borderRadius: 10,
                          duration: const Duration(seconds: 2),
                        );
                        return;
                      }
                      Get.to(() => Checkout2Screen());
                    },
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Food Image
            Padding(
              padding: const EdgeInsets.only(left: 18.0,right: 18, ),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Obx(
                      ()=> ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(selectedImage.value),
                    ),
                  ),
                ),
              ),
            ),

            /// Extra Food Images (5 images)
            /// Extra Food Images (max 5)
            if (widget.food.images != null && widget.food.images!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.food.images!.length > 5
                        ? 5
                        : widget.food.images!.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final image = widget.food.images![index];

                      return GestureDetector(
                        onTap: () {
                          selectedImage.value = image; // 👈 GetX update
                        },
                        child: Obx(
                              () => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedImage.value == image
                                      ? Colors.orange
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Image.network(
                                image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            /// Title & Description
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.food.description,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Ingredients",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),

            //add ingredients image and name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 14,
              runSpacing: 14,
              children: widget.food.ingredients.map((ingredient) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: Color(0x2EFFB972),
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        ingredient.image ?? '',
                        height: 45,
                        width: 45,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) =>
                        const Icon(Icons.fastfood, size: 30),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ingredient.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),



          // /// Ingredients Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0),
            //   child: Wrap(
            //     spacing: 10,
            //     runSpacing: 12,
            //     children: IngredientData.allIngredients
            //         .where(
            //           (item) => widget.food.ingredients.contains(item["name"]),
            //         )
            //         .map((item) {
            //           return Column(
            //             children: [
            //               Container(
            //                 decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(100),
            //                   color: const Color(0x2EFFB972),
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(18.0),
            //                   child: SizedBox(
            //                     height: 40,
            //                     width: 40,
            //                     child: AppSvg(
            //                       asset: item["asset"]!,
            //                       width: 40,
            //                       height: 40,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               const SizedBox(height: 5),
            //               Text(
            //                 item["name"]!,
            //                 style: const TextStyle(fontSize: 12),
            //               ),
            //             ],
            //           );
            //         })
            //         .toList(),
            //   ),
            // ),

            const SizedBox(height: 20),
            
            // Padding(
            //   padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Row(
            //         children: [
            //           Text('Ratings and Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
            //           Text('(${widget.food.reviewsCount})')
            //         ],
            //       ),
            //       SizedBox(width: 30,),
            //
            //       if (widget.food.rating > 0)
            //         Row(
            //           children: [
            //             Text('${widget.food.rating}'),
            //             // 5 Stars
            //             ...List.generate(5, (index) {
            //               double starValue = index + 1.0;
            //               if (widget.food.rating >= starValue) {
            //                 return const Icon(
            //                   Icons.star,
            //                   color: Color(0xFF7F3615),
            //                   size: 18,
            //                 );
            //               } else if (widget.food.rating >= starValue - 0.5) {
            //                 return const Icon(
            //                   Icons.star_half,
            //                   color: Color(0xFF7F3615),
            //                   size: 18,
            //                 );
            //               } else {
            //                 return const Icon(
            //                   Icons.star_border,
            //                   color: Color(0xFF7F3615),
            //                   size: 18,
            //                 );
            //               }
            //             }),
            //
            //           ],
            //         )
            //     ],
            //   ),
            // ),
            //
            // //here fetch the review and show in the screen
            // Obx(() {
            //   if (ratingController.isLoading.value && ratingController.review.isEmpty) {
            //     return const Center(child: CircularProgressIndicator());
            //   }
            //
            //   if (ratingController.review.isEmpty) {
            //     return const Padding(
            //       padding: EdgeInsets.all(20),
            //       child: Text("No reviews yet. Be the first to review!", style: TextStyle(color: Colors.grey)),
            //     );
            //   }
            //
            //   return ListView.builder(
            //     shrinkWrap: true,
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemCount: ratingController.review.length,
            //     itemBuilder: (context, index) {
            //       final rev = ratingController.review[index];
            //       DPrint.log(rev.id);
            //       //final userId =  _authStorageService.getUserId();
            //       // Now this condition is properly typed as bool
            //       final bool isOwnReview = currentUserId.value != null && currentUserId.value == rev.user.id;
            //
            //       return ReviewCard(
            //       review: rev,
            //       onDelete: isOwnReview
            //       ? () => ratingController.deleteReview(rev.id)
            //       : null,
            //       );
            //     },
            //   );
            // })
          ],
        ),
      ),
    );
  }

  Widget _squareButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: const Color(0xFF4C8FFF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
