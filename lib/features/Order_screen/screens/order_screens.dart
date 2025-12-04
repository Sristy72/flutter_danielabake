import 'package:danielabake/core/common/widgets/app_scaffold.dart';
import 'package:danielabake/core/common/widgets/button_widgets.dart';
import 'package:danielabake/features/Order_screen/screens/checkout_screen.dart';
import 'package:danielabake/features/Order_screen/widget/cart_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../widget/simmer_card.dart';

class OrderScreens extends StatefulWidget {
  const OrderScreens({super.key});

  @override
  State<OrderScreens> createState() => _OrderScreensState();
}

class _OrderScreensState extends State<OrderScreens> {
  final OrderController controller = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    controller.fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Cart Items Section
          Expanded(
            child: Obx(() {
              // Loading state → Show 4-6 shimmering cards
              if (controller.cart.value == null) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(), // optional: feels more like skeleton
                  itemCount: 5, // adjust as needed
                  itemBuilder: (context, index) => const ShimmerCartItemCard(),
                );
              }

              final cartItems = controller.cart.value!.items;

              // Empty state
              if (cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add delicious items to get started!',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              // Real data
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemCard(cartItem: item);
                },
              );
            }),
          ),

          // Only show the button if there are items in the cart
          Obx(() {
            if (controller.cart.value != null &&
                controller.cart.value!.items.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: PrimaryButton(
                  text: 'Place Order',
                  onSimplePressed: () async => Get.to(() => CheckoutScreen()),
                ),
              );
            } else {
              return const SizedBox.shrink(); // empty space if no items
            }
          }),
        ],
      ),
    );
  }
}
