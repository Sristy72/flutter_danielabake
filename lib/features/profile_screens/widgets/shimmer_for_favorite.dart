
import 'package:danielabake/core/common/shimmer/shimmer_loader.dart';
import 'package:danielabake/core/common/shimmer/shimmer_placeholders.dart';
import 'package:flutter/material.dart';

class ShimmerFoodCard extends StatelessWidget {
  const ShimmerFoodCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      isLoading: true,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFE0B2).withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            ShimmerPlaceholders.rectangle(
              height: 160,
              borderRadius: 12,
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPlaceholders.textLine(height: 16, width: 120),
                  const SizedBox(height: 8),
                  ShimmerPlaceholders.textLine(height: 12, width: 80),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerPlaceholders.textLine(height: 16, width: 60),
                      ShimmerPlaceholders.circle(diameter: 32),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}