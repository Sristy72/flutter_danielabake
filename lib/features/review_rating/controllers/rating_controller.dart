import 'package:danielabake/core/base/base_controller.dart';
import 'package:danielabake/features/review_rating/models/request/add_review_request_model.dart';
import 'package:danielabake/features/review_rating/models/response/get_review_response_model.dart';
import 'package:danielabake/features/review_rating/repositories/rate_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import '../../../core/network/services/auth_storage_service.dart';

class RatingController extends BaseController {
  final _ratingRepo = Get.find<RateRepo>();

  final AuthStorageService _authStorageService = AuthStorageService();
  final RxList<GetReviewResponseModel> review = <GetReviewResponseModel>[].obs;

  Future<void> addReview(String orderId, String itemId, String comment, int rating) async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      setError('User ID not found. Please log in again.');
      Get.snackbar('Error', 'User ID not found. Please log in again.');
      return;
    }


    final request = AddReviewRequestModel(userId: userId, itemId: itemId, orderId: orderId, rating: rating, comment: comment);

    final result = await _ratingRepo.addReview(request);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log("Review success result : ${fail.message}");
      },
          (success) {
        DPrint.log("Review success result : ${success.data.id}");
        Get.snackbar(
          "Success",
          "Review submitted successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
        Get.back();
      },
    );
  }

  Future<void> getReview(String itemId) async {
    final result = await _ratingRepo.getReview(itemId);

    result.fold(
          (fail) {
        setError(fail.message);
        DPrint.log('data fetch failed');
      },
          (success) {
            review.assignAll(success.data);
        DPrint.log(success.message);
      },
    );
  }

  // Delete Review
  Future<void> deleteReview(String reviewId) async {
    // Optimistic update: Remove from UI immediately
    final removedReview = review.firstWhereOrNull((r) => r.id == reviewId);
    if (removedReview == null) {
      Get.snackbar('Error', 'Review not found');
      return;
    }

    review.removeWhere((r) => r.id == reviewId);

    final result = await _ratingRepo.deleteReview(reviewId);

    result.fold(
          (fail) {
        // Revert optimistic update on failure
        review.add(removedReview);
        review.sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Restore order

        setError(fail.message);
        DPrint.log("Delete review failed: ${fail.message}");
        Get.snackbar('Error', 'Failed to delete review',
            backgroundColor: Colors.red.withOpacity(0.8), colorText: Colors.white);
      },
          (success) {
        DPrint.log("Review deleted successfully: $reviewId");
        Get.snackbar(
          "Deleted",
          "Review removed successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[800],
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      },
    );
  }
}
