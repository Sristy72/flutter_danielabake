// features/Order_screen/controller/rating_controller.dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  var selectedRating = 0.obs;           // RxInt
  final feedbackController = TextEditingController();

  void setRating(int rating) => selectedRating.value = rating;

  void clear() {
    selectedRating.value = 0;
    feedbackController.clear();
  }

  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
}