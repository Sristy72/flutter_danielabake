import 'package:flutter/material.dart';
import '../models/response/get_popular_items_response_model.dart';

class WeeklyMenuCard extends StatelessWidget {
  final String day;
  final List<PopularItem> items;
// 3 image paths: top, middle, bottom

  const WeeklyMenuCard({
    super.key,
    required this.day,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      // clipBehavior: Clip.none,
      children: [
        /// Main content: Day and menu items
        Container(
          //width: double.infinity,
          //height: 160, // Reduced height
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF77A9EA),
                Color(0xFF6B8FEE),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                day,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const Text(
                  'No menu available',
                  style: TextStyle(color: Colors.white70),
                )
              else
                Column(
                  children: items.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),

        /// Images on the right – smaller and tighter for reduced height
        Positioned(
          top: -85, // Slightly less overflow
          right: 15,
          child: SizedBox(height: 180, width: 157, child: Image.asset('assets/images/11322202_4731931 32.png')),
        ),

        Positioned(
          top: 20, // Slightly less overflow
          right: 2,
          child: SizedBox(height: 180, width: 157, child: Image.asset('assets/images/11322202_4731931 33.png')),
        ),

        Positioned(
          top: 110, // Slightly less overflow
          right: 1,
          child: SizedBox(height: 180, width: 157, child: Image.asset('assets/images/11322202_4731931 34.png')),
        ),
      ],
    );
  }
}