import 'dart:developer' as DPrint;
import 'package:danielabake/features/home/models/request/favorite_food_request_model.dart';
import 'package:danielabake/features/home/models/request/remove_favorite_request_model.dart';
import 'package:danielabake/features/home/repositories/favorite_food_repository.dart';
import 'package:danielabake/features/profile_screens/models/response/get_favorite_items_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../profile_screens/repositories/profile_repository.dart';

class FavoriteFoodController extends BaseController {
  final _profileRepository = Get.find<ProfileRepository>();
  final _favoriteRepository = Get.find<FavoriteFoodRepository>();
  final AuthStorageService _authStorageService = AuthStorageService();
  final RxList<GetFavoriteItemsResponseModel> favoriteItems = <GetFavoriteItemsResponseModel>[].obs;



  @override
  void onInit() {
    super.onInit();
    fetchFavoriteItem();
  }


  Future<void> favorite(String itemId) async {
    final userId = await _authStorageService.getUserId();
    DPrint.log('UserId: $userId');
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      setLoading(false);
      return;
    }
    final request = FavoriteFoodRequestModel(userId: userId, itemId: itemId);
    final result = await _favoriteRepository.favorite(request, userId, itemId);


    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Favorite success result : ${fail.message}");
        setLoading(false);
      },
          (success) {
        DPrint.log("Favorite success result : ${success.data.id}");
        Get.snackbar(
          "Success",
          "Item added to your favorites",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }


  Future<void> fetchFavoriteItem() async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      Get.snackbar('Error', 'Please log in again.');
      return;
    }

    setLoading(true);
    final result = await _profileRepository.fetchFavoriteItems(userId);

    result.fold(
          (fail) => setError(fail.message),
          (success) {
        // ← THIS IS THE MAGIC LINE
        favoriteItems.assignAll(success.data);
        // No need for .refresh() — assignAll() does it automatically
      },
    );
    setLoading(false);
  }

  Future<void> removeFavorite(String itemId) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) return;

    final request = RemoveFavoriteFoodRequestModel(userId: userId, itemId: itemId);
    final result = await _favoriteRepository.removeFavorite(request, userId, itemId);

    result.fold(
          (fail) => Get.snackbar('Error', fail.message),
          (success) {
        // INSTANT UI UPDATE — Remove from observable list
        favoriteItems.removeWhere((entry) => entry.item.id == itemId);
        favoriteItems.refresh();

        Get.snackbar(
          "Removed",
          "Item removed from favorites",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
