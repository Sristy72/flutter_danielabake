import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/response/get_review_response_model.dart';

class ReviewCard extends StatelessWidget {
  final GetReviewResponseModel review;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOwnReview = onDelete != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // ← Critical: gives space for outer shadow
      child: Material( // ← Best way for clean outer shadow
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        shadowColor: Colors.black.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.comment,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Stars
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < review.rating ? Icons.star : Icons.star_border,
                                color: const Color(0xFF7F3615),
                                size: 18,
                              );
                            }),
                          ),
                          const SizedBox(width: 12),
                          // User name
                          Text(
                            review.user.name.isNotEmpty ? review.user.name : "Anonymous",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatDate(review.createdAt),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete menu (only if own review)
                if (isOwnReview)
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    onSelected: (value) {
                      if (value == 'delete') {
                        Get.dialog(
                          AlertDialog(
                            title: const Text("Delete Review"),
                            content: const Text("Are you sure you want to delete your review?"),
                            actions: [
                              TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                  onDelete?.call();
                                },
                                child: const Text("Delete", style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text("Delete Review"),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}