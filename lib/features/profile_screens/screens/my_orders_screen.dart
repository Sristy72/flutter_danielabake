import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:danielabake/features/profile_screens/controller/review_controller.dart';
import 'package:danielabake/features/review_rating/controllers/rating_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/button_widgets.dart';
import '../widgets/text_formatter.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final orderController = Get.find<OrderController>();
  // final ratingController = Get.find<RatingController>();
  //
  // // Review UI Controller (for stars & text field)
  // final reviewController = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    orderController.fetchOngoingOrders();
    orderController.fetchCompletedOrders();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      backgroundColor: const Color(0xffFFF8E8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffFFF8E8),
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: Color(0xFF7F3615)),
            insets: EdgeInsets.symmetric(horizontal: 40),
          ),
          labelColor: const Color(0xFF7F3615),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          tabs: const [
            Tab(text: "Ongoing"),
            Tab(text: "Completed"),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [_ongoingList(), _completedList()],
      ),
    );
  }

  Widget _ongoingList() {
    return Obx(() {
      if (orderController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = orderController.ongoingOrder.value;
      if (data == null || data.orders.isEmpty) {
        return const Center(child: Text("No ongoing orders"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.orders.length,
        itemBuilder: (context, index) {
          final order = data.orders[index];
          return _buildOrderCard(order);
        },
      );
    });
  }

  Widget _completedList() {
    return Obx(() {
      if (orderController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = orderController.completedOrder.value;
      if (data == null || data.orders.isEmpty) {
        return const Center(child: Text("No completed orders yet"));
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: data.orders.length,
        itemBuilder: (context, index) {
          final order = data.orders[index];
          return _buildOrderCard(order, isCompleted: true);
        },
      );
    });
  }

  Widget _buildOrderCard(dynamic order, {bool isCompleted = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Id: #${order.id.substring(order.id.length - 6)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              Text(
                order.status ?? "Delivered",
                style: TextStyle(
                  color: order.status == "Delivered"
                      ? Colors.green.shade700
                      : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Items List
          ...order.items.map<Widget>((orderItem) {
            final item = orderItem.item;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item.image,
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.fastfood, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Qty: ${orderItem.quantity}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          if (isCompleted) ...[
                            const SizedBox(height: 6),
                            // TextButton(
                            //   onPressed: () => _showRatingDialog(order, orderItem), // Pass order + orderItem
                            //   style: TextButton.styleFrom(
                            //     padding: EdgeInsets.zero,
                            //     minimumSize: const Size(0, 0),
                            //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            //   ),
                            //   child: const Text(
                            //     "Rate & Review",
                            //     style: TextStyle(
                            //       color: Color(0xFF7F3615),
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 14,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      "\$${item.price.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          const Divider(color: Color(0xFFAD653F), thickness: 1, height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "(${order.items.length} items)",
                style: const TextStyle(color: Colors.grey),
              ),
              Text(
                "Total: \$${order.totalAmount.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // // Rating Dialog
  // void _showRatingDialog(dynamic order, dynamic orderItem) {
  //   final item = orderItem.item;
  //   final int quantity = orderItem.quantity;
  //   final double itemTotal = item.price * quantity;
  //
  //   // Reset every time dialog opens
  //   reviewController.selectedRating.value = 0;
  //   reviewController.feedbackController.clear();
  //
  //   Get.dialog(
  //     barrierDismissible: true,
  //     Dialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
  //       backgroundColor: Colors.transparent,
  //       child: Container(
  //         padding: const EdgeInsets.all(20),
  //         decoration: BoxDecoration(
  //           color: const Color(0xffFFF3E0),
  //           borderRadius: BorderRadius.circular(24),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.15),
  //               blurRadius: 20,
  //               offset: const Offset(0, 10),
  //             ),
  //           ],
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             // Close Button
  //             Align(
  //               alignment: Alignment.topRight,
  //               child: GestureDetector(
  //                 onTap: () => Get.back(),
  //                 child: Container(
  //                   padding: const EdgeInsets.all(8),
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xffFFE0B2),
  //                     shape: BoxShape.circle,
  //                     border: Border.all(color: const Color(0xFFAD653F)),
  //                   ),
  //                   child: const Icon(Icons.close, size: 20, color: Color(0xFF7F3615)),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //
  //             const Text("Rate this item", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
  //             const SizedBox(height: 20),
  //
  //             // Item Preview Card
  //             Container(
  //               width: double.infinity,
  //               padding: const EdgeInsets.all(16),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFFFE8CC),
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //               child: Row(
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(12),
  //                     child: Image.network(
  //                       item.image,
  //                       height: 80,
  //                       width: 80,
  //                       fit: BoxFit.cover,
  //                       errorBuilder: (_, __, ___) => Container(
  //                         color: Colors.grey[300],
  //                         child: const Icon(Icons.fastfood),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 16),
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           item.name,
  //                           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text(
  //                           "\$${itemTotal.toStringAsFixed(2)}  •  $quantity item${quantity > 1 ? 's' : ''}",
  //                           style: TextStyle(color: Colors.grey[700]),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         const Text("Order delivered", style: TextStyle(fontWeight: FontWeight.w600)),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //             const SizedBox(height: 30),
  //
  //             // Rating Stars + Feedback
  //             Obx(() => Container(
  //               padding: const EdgeInsets.all(20),
  //               decoration: BoxDecoration(
  //                 color: const Color(0xFFFFE8CC),
  //                 borderRadius: BorderRadius.circular(16),
  //               ),
  //               child: Column(
  //                 children: [
  //                   const Text("How was your experience?", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
  //                   const SizedBox(height: 20),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: List.generate(5, (i) => GestureDetector(
  //                       onTap: () => reviewController.setRating(i + 1),
  //                       child: Container(
  //                         margin: const EdgeInsets.symmetric(horizontal: 8),
  //                         child: Icon(
  //                           i < reviewController.selectedRating.value ? Icons.star : Icons.star_border,
  //                           color: const Color(0xFF7F3615),
  //                           size: 40,
  //                         ),
  //                       ),
  //                     )),
  //                   ),
  //                   const SizedBox(height: 24),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.end, // Align word count to the right
  //                     children: [
  //                       TextField(
  //                         controller: reviewController.feedbackController,
  //                         maxLines: 4,
  //                         inputFormatters: [
  //                           MaxWordsInputFormatter(), // The formatter from previous response
  //                         ],
  //                         decoration: InputDecoration(
  //                           hintText: "Share your thoughts (optional)...",
  //                           hintStyle: const TextStyle(color: Colors.grey),
  //                           filled: true,
  //                           fillColor: const Color(0xFFFFEFD5),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                             borderSide: const BorderSide(color: Color(0xFF7F3615)),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                             borderSide: const BorderSide(color: Color(0xFF7F3615)),
  //                           ),
  //                           // Optional: Show word limit in the counter area inside the field
  //                           counterText: "",
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8), // Space between TextField and counter
  //                       ValueListenableBuilder<TextEditingValue>(
  //                         valueListenable: reviewController.feedbackController,
  //                         builder: (context, value, child) {
  //                           // Calculate word count
  //                           final text = value.text;
  //                           final words = text.trim().split(RegExp(r'\s+'));
  //                           final wordCount = text.isEmpty ? 0 : words.where((w) => w.isNotEmpty).length;
  //
  //                           // Optional: Change color when approaching or hitting the limit
  //                           final color = wordCount > 80
  //                               ? Colors.red
  //                               : wordCount > 70
  //                               ? Colors.orange
  //                               : Colors.grey;
  //
  //                           return Text(
  //                             "$wordCount/30 words",
  //                             style: TextStyle(
  //                               color: color,
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             )),
  //
  //             const SizedBox(height: 30),
  //
  //             // Submit Button
  //             SizedBox(
  //               width: double.infinity,
  //               child: PrimaryButton(
  //                 onApiPressed: () async => _submitRating(order, orderItem),
  //                 text: "Submit",
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Submit Review
  // Future<void> _submitRating(dynamic order, dynamic orderItem) async {
  //   if (reviewController.selectedRating.value == 0) {
  //     Get.snackbar(
  //       "Missing Rating",
  //       "Please select at least 1 star",
  //       backgroundColor: Colors.red.withOpacity(0.2),
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }
  //
  //   final int rating = reviewController.selectedRating.value;
  //   final String comment = reviewController.feedbackController.text.trim();
  //   final String orderId = order.id;                    // Correct: from parent order
  //   final String itemId = orderItem.item.id;            // Correct: from item
  //
  //   // Call API
  //   await ratingController.addReview(orderId, itemId, comment, rating);
  //
  //   // Note: Success snackbar + Get.back() is already handled inside RatingController
  //   // So we don't need to do it again here unless you want extra control
  // }
}