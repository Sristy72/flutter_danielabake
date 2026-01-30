// import 'dart:developer' as DPrint;
// import 'package:danielabake/features/home/repositories/cart_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../core/base/base_controller.dart';
// import '../../../core/network/services/auth_storage_service.dart';
import 'package:danielabake/features/auth/screens/login_screen.dart';
import '../../Order_screen/models/response/get_cart_response_model.dart';
import '../models/request/cart_request_model.dart';

//
// class AddToCartController extends BaseController {
//   final _addCartRepo = Get.find<CartRepository>();
//   final AuthStorageService _authStorageService = AuthStorageService();
//   final Rx<GetCartResponseModel?> cart = Rx<GetCartResponseModel?>(null);
//
//
//   Future<void> addCart(String itemId, int quantity) async {
//     final userId = await _authStorageService.getUserId();
//     DPrint.log('UserId: $userId');
//     if (userId == null || userId.isEmpty) {
//       if (Get.isDialogOpen == true) return; // Prevent double dialogs
//       Get.defaultDialog(
//         title: "Guest User",
//         middleText: "Please sign in to add items to cart.",
//         actions: [
//           TextButton(
//             onPressed: () => Get.back(),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back(); // Close dialog
//               Get.to(() => const LoginScreen());
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//             child: const Text("Sign In", style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       );
//       setLoading(false);
//       return;
//     }
//
//     final request = AddItemRequest(userId: userId, itemId: itemId, quantity: quantity);
//
//     final result = await _addCartRepo.addCart(request, userId, itemId, quantity);
//
//     result.fold(
//           (fail) {
//         setError(fail.message);
//         DPrint.log("Add cart success result : ${fail.message}");
//         setLoading(false);
//       },
//           (success) {
//         DPrint.log("add cart success result : ${success.data.id}");
//         /// Show snackbar when item is successfully added
//         Get.snackbar(
//           "''",
//           "Item added to cart",
//           backgroundColor: Colors.green,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//           margin: EdgeInsets.all(12),
//           duration: Duration(seconds: 2),
//         );
//         setLoading(false);
//       },
//     );
//   }
//
//
//   Future<void> removeCart(String itemId) async {
//     final userId = await _authStorageService.getUserId();
//     DPrint.log('UserId: $userId');
//     if (userId == null || userId.isEmpty) {
//       setError('User ID not found. Please log in again.');
//       Get.snackbar('Error', 'User ID not found. Please log in again.');
//       setLoading(false);
//       return;
//     }
//     final request = RemoveCartRequestModel(userId: userId, itemId: itemId);
//     final result = await _addCartRepo.removeCart(request, userId, itemId);
//
//     result.fold(
//             (fail) {
//           setError(fail.message);
//           DPrint.log("Favorite success result : ${fail.message}");
//           setLoading(false);
//         },
//             (success) {
//           // THIS IS THE KEY: Remove the item locally from the observable cart
//           final currentCart = cart.value;
//           if (currentCart != null) {
//             currentCart.items.removeWhere((item) => item.item.id == itemId);
//
//             // Important: Trigger update
//             cart.value = currentCart; // This triggers Obx rebuild
//             // OR better: cart.refresh();
//             DPrint.log("Favorite success result : ${success.message}");
//             Get.snackbar(
//               "Success",
//               "Item removed from cart",
//               snackPosition: SnackPosition.BOTTOM,
//             );
//             setLoading(false);
//           }
//         }
//     );
//   }
//
//   Future<void> removeOneItemFromCart(String itemId)async{
//     final userId = await _authStorageService.getUserId();
//     DPrint.log('UserId: $userId');
//     if (userId == null || userId.isEmpty) {
//       setError('User ID not found. Please log in again.');
//       Get.snackbar('Error', 'User ID not found. Please log in again.');
//       setLoading(false);
//       return;
//     }
//     final request = RemoveCartRequestModel(userId: userId, itemId: itemId);
//     final result = await _addCartRepo.removeOneCartItem(request, userId, itemId);
//
//     result.fold(
//           (fail) {
//         setError(fail.message);
//         DPrint.log("Favorite success result : ${fail.message}");
//         setLoading(false);
//       },
//           (success) {
//         DPrint.log("Favorite success result : ${success.message}");
//         Get.snackbar(
//           "Success",
//           "Item removed from favorites",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         setLoading(false);
//       },
//     );
//   }
// }
