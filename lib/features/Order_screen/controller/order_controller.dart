import 'dart:developer' as DPrint;
import 'package:danielabake/features/Order_screen/models/request/place_order_request_model.dart';
import 'package:danielabake/features/Order_screen/models/response/get_cart_response_model.dart';
import 'package:danielabake/features/Order_screen/models/response/get_order_by_id_response_model.dart';
import 'package:danielabake/features/Order_screen/repositories/cart_repository.dart';
import 'package:danielabake/features/Order_screen/repositories/place_order_repo.dart';
import 'package:danielabake/features/home/screens/home_screen.dart';
import 'package:danielabake/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../home/models/request/cart_request_model.dart';
import '../../home/models/request/remove_cart_request_model.dart';
import '../../home/repositories/cart_repository.dart';

class OrderController extends BaseController {
  final _cartRepo = Get.find<CartRepo>();
  final _placeOrderRepo = Get.find<PlaceOrderRepo>();
  final AuthStorageService _authStorageService = AuthStorageService();

  final Rxn<GetCartResponseModel> cart = Rxn<GetCartResponseModel>();
  final Rxn<GetOrderByIdResponseModel> ongoingOrder = Rxn<GetOrderByIdResponseModel>();
  final Rxn<GetOrderByIdResponseModel> completedOrder = Rxn<GetOrderByIdResponseModel>();

  final _addCartRepo = Get.find<CartRepository>();


  // final Rxn<OngoingOrderResponseModel> ongoingOrder = Rxn<OngoingOrderResponseModel>();
  // final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();

  @override
  void onInit() {
    super.onInit();
    fetchCart();
    fetchOngoingOrders();
    fetchCompletedOrders();
  }

  Future<void> fetchCart() async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final result = await _cartRepo.fetchCart(userId);

    result.fold(
      (fail) {
        setError(fail.message);
        DPrint.log('Fetch Cart failed');
      },
      (success) {
        cart.value = success.data;
        DPrint.log(success.message);
      },
    );
  }

  Future<void> addCart(String itemId, int quantity) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }

    final request = AddItemRequest(userId: userId, itemId: itemId, quantity: quantity);

    setLoading(true); // optional: show loading

    final result = await _addCartRepo.addCart(request, userId, itemId, quantity);

    result.fold(
          (fail) {
        setError(fail.message);
        Get.snackbar('Error', fail.message);
        setLoading(false);
      },
          (success) async {
        // SUCCESS: Now refresh the cart locally
        Get.snackbar(
          "Success",
          "Item added to cart",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 2),
        );

        // Option 1: Best - Re-fetch the entire cart (most reliable)
        await fetchCart(); // This will update cart.value → triggers Obx → badge appears

        // OR Option 2: If you want to avoid extra API call, manually update (less safe)
        // final currentCart = cart.value ?? GetCartResponseModel(items: []);
        // final existingItem = currentCart.items.firstWhereOrNull((e) => e.item.id == itemId);
        // if (existingItem != null) {
        //   existingItem.quantity += quantity;
        // } else {
        //   // You'd need to have item details here - usually not available
        // }
        // cart.value = currentCart;
        // cart.refresh();

        setLoading(false);
      },
    );
  }


  Future<void> removeCart(String itemId) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    // 1. Optimistically remove from UI IMMEDIATELY
    final currentCart = cart.value;
    if (currentCart != null) {
      final removedItem = currentCart.items.firstWhereOrNull((e) => e.item?.id == itemId);
      if (removedItem != null) {
        currentCart.items.removeWhere((e) => e.item?.id == itemId);
        cart.refresh(); // This triggers instant rebuild in Obx(() => CartItemCard)

        Get.snackbar(
          "Removed",
          "Item removed from cart",
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }

    // 2. Then call API in background
    final request = RemoveCartRequestModel(userId: userId, itemId: itemId);
    final result = await _addCartRepo.removeCart(request, userId, itemId);

    result.fold(
          (fail) {
        // API FAILED → Show error + restore item (optional but safe)
        Get.snackbar(
          "Failed",
          "Could not remove item. Try again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        // Optional: Restore the item if API failed
        // await fetchCart(); // safest way to sync
      },
          (success) {
        // API succeeded → already removed optimistically → do nothing
        DPrint.log("Item removed from server successfully");
      },
    );
  }

  Future<void> removeOneItemFromCart(String itemId)async{
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }
    final request = RemoveCartRequestModel(userId: userId, itemId: itemId);
    final result = await _addCartRepo.removeOneCartItem(request, userId, itemId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Favorite success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("Favorite success result : ${success.message}");
        Get.snackbar(
          "Success",
          "Item removed from favorites",
          snackPosition: SnackPosition.BOTTOM,
        );
        setLoading(false);
      },
    );
  }

  Future<void> fetchOngoingOrders() async {
    final result = await _cartRepo.fetchOngoingOrder();

    result.fold(
      (fail) {
        DPrint.log("Fetch Orders Failed: ${fail.message}");
      },
      (success) {
        DPrint.log("Raw order data: ${success.data}");
        ongoingOrder.value = success.data;
      },
    );
  }

  Future<void> fetchCompletedOrders() async {
    final result = await _cartRepo.fetchCompletedOrder();

    result.fold(
      (fail) {
        DPrint.log("Fetch Orders Failed: ${fail.message}");
      },
      (success) {
        DPrint.log("Raw order data: ${success.data}");
        completedOrder.value = success.data;
      },
    );
  }

  Future<void> placeOrder(String address, String phone) async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }

    final request = CheckoutRequestModel(userId: userId, address: address, phone: phone
    );

    final result = await _placeOrderRepo.placeOrder(request, userId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Place Order success result : ${fail.message}");
      },
          (success) {
        DPrint.log("Place order result : ${success.data.id}");
        Get.offAll(() => NavigationMenu());
      },
    );
  }
}
