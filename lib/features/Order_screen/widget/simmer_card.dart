import 'package:flutter/material.dart';
import '../../../core/common/shimmer/shimmer_loader.dart';
import '../../../core/common/shimmer/shimmer_placeholders.dart';

class ShimmerCartItemCard extends StatelessWidget {
  const ShimmerCartItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoader(
      isLoading: true,
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50, // ← Brighter highlight = more visible wave
      duration: const Duration(milliseconds: 1400),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x2EFFB972),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ShimmerPlaceholders.rectangle(
                    width: 100,
                    height: 100,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholders.textLine(height: 18, borderRadius: 8),
                      const SizedBox(height: 8),
                      ShimmerPlaceholders.textLine(width: 200, height: 14),
                      const SizedBox(height: 6),
                      ShimmerPlaceholders.textLine(width: 160, height: 14),
                      const SizedBox(height: 12),
                      ShimmerPlaceholders.textLine(width: 110, height: 12),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    ShimmerPlaceholders.textLine(width: 80, height: 22),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerPlaceholders.textLine(width: 80, height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerPlaceholders.rectangle(width: 28, height: 28, borderRadius: 8),
                      const SizedBox(width: 16),
                      ShimmerPlaceholders.textLine(width: 30, height: 18),
                      const SizedBox(width: 16),
                      ShimmerPlaceholders.rectangle(width: 28, height: 28, borderRadius: 8),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Colors.grey),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerPlaceholders.textLine(width: 100, height: 16),
                ShimmerPlaceholders.textLine(width: 90, height: 22),
              ],
            ),
          ],
        ),
      ),
    );
  }
}