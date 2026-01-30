import 'dart:async';
import 'package:danielabake/features/home/widgets/weekly_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/weekly_menu_controller.dart';
import '../controller/home_controller.dart';
import '../../../core/common/shimmer/shimmer_loader.dart';
import '../../../core/common/shimmer/shimmer_placeholders.dart';
import '../screens/weekly_menu_items_details_screen.dart';

class WeeklyMenuSlider extends StatefulWidget {
  const WeeklyMenuSlider({super.key});

  @override
  State<WeeklyMenuSlider> createState() => _WeeklyMenuSliderState();
}

class _WeeklyMenuSliderState extends State<WeeklyMenuSlider> {
  final WeeklyMenuController _controller = Get.find<WeeklyMenuController>();

  late final PageController _pageController;
  Timer? _timer;
  late int _currentPage;

  int _getTodayIndex() {
    // Monday = 1 ... Sunday = 7
    final today = DateTime.now().weekday - 1;
    return today.clamp(0, _controller.days.length - 1);
  }

  @override
  void initState() {
    super.initState();

    final todayIndex = _getTodayIndex();

    _currentPage = 1000 + todayIndex;

    _pageController = PageController(initialPage: _currentPage);

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _currentPage++;

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Obx(() {
        final weeklyMenu = _controller.weeklyMenuByDay;

        if (weeklyMenu.isEmpty) {
          return PageView.builder(
            itemCount: 1,
            itemBuilder: (_, __) => _buildSliderShimmer(),
          );
        }

        return PageView.builder(
          controller: _pageController,
          clipBehavior: Clip.none,
          // ❌ REMOVE itemCount → infinite
          itemBuilder: (_, index) {
            final dayIndex = index % _controller.days.length;
            final day = _controller.days[dayIndex];
            final items = weeklyMenu[day] ?? [];

            return GestureDetector(
              onTap: () {
                Get.to(
                  () => WeeklyMenuItemsDetailsScreen(day: day, items: items),
                );
              },
              child: WeeklyMenuCard(day: day, items: items),
            );
          },
        );
      }),
    );
  }

  Widget _buildSliderShimmer() {
    return Container(
      width: double.infinity,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFDEB8),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day title placeholder
          Container(
            width: 120,
            height: 22,
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(width: 12),

              // Items placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _itemPlaceholder(),
                    const SizedBox(height: 8),
                    _itemPlaceholder(),
                    const SizedBox(height: 8),
                    _itemPlaceholder(width: 140),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemPlaceholder({double width = double.infinity}) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
