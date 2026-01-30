import 'package:danielabake/features/home/screens/weekly_menu_items_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/response/get_popular_items_response_model.dart';

class WeeklyMenuCard extends StatelessWidget {
  final String day;
  final List<PopularItem> items;

  const WeeklyMenuCard({super.key, required this.day, required this.items});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF77A9EA), Color(0xFF6B8FEE)],
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
              const SizedBox(height: 9),

              // List (non-scrollable, limited to 4)
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (items.isEmpty)
                            const Text(
                              'No menu available',
                              style: TextStyle(color: Colors.white70),
                            )
                          else ...[
                            for (final item in items.take(4))
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 6,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
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
                              ),

                            // "... More" Button
                            if (items.length > 4)
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => WeeklyMenuItemsDetailsScreen(
                                      day: day,
                                      items: items,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 11,
                                    ), // Indent to align with text
                                    Text(
                                      "... ${items.length-4} More",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),

        // Right side decorative images
        Positioned(
          top: -48,
          right: 25,
          child: SizedBox(
            height: 130,
            width: 130,
            child: Image.asset('assets/images/11322202_4731931 32.png'),
          ),
        ),
        Positioned(
          top: 33,
          right: 10,
          child: SizedBox(
            height: 135,
            width: 135,
            child: Image.asset('assets/images/11322202_4731931 33.png'),
          ),
        ),
        Positioned(
          top: 110,
          right: 1,
          child: SizedBox(
            height: 140,
            width: 140,
            child: Image.asset('assets/images/11322202_4731931 34.png'),
          ),
        ),
      ],
    );
  }
}
