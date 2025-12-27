import 'dart:async';
import 'package:danielabake/features/home/widgets/weekly_menu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/weekly_menu_controller.dart';

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

  /// 👇 THIS FUNCTION decides today's index
  int _getTodayIndex() {
    // DateTime.weekday: Monday = 1 ... Sunday = 7
    // Your days list: ['Monday', 'Tuesday', ..., 'Sunday']
    final todayIndex = DateTime.now().weekday;


    // Safety check: if list shorter (e.g., only Mon-Fri)
    return todayIndex.clamp(0, _controller.days.length);
  }

  @override
  void initState() {
    super.initState();

    // Start from today
    _currentPage = _getTodayIndex();
    _pageController = PageController();

    // Jump to today AFTER first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(_currentPage);
      }
    });

    // Auto-slide every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _currentPage = (_currentPage + 1) % _controller.days.length;

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
      height: 210,
      child: Obx(() {
        final weeklyMenu = _controller.weeklyMenuByDay;

        if (weeklyMenu.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return PageView.builder(
          controller: _pageController,
          itemCount: _controller.days.length,
          itemBuilder: (_, index) {
            final day = _controller.days[index];
            final items = weeklyMenu[day] ?? [];

            return WeeklyMenuCard(
              day:day,
              items: items,
            );
          },
        );
      }),
    );
  }
}
