import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../models/response/get_popular_items_response_model.dart';

class WeeklyMenuController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _homeController.popularItem.value;
  }

  final List<String> days = const [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];

  Map<String, String> dayMap = {
    "mon": "Monday",
    "tue": "Tuesday",
    "wed": "Wednesday",
    "thu": "Thursday",
    "fri": "Friday",
  };

  /// Group items by availableDays
  Map<String, List<PopularItem>> get weeklyMenuByDay {
    final data = _homeController.weeklyMenu.value;
    if (data == null) return {};

    // Standard day list
    final Map<String, List<PopularItem>> map = {
      'Monday': [],
      'Tuesday': [],
      'Wednesday': [],
      'Thursday': [],
      'Friday': [],
    };

    // Map abbreviations from backend to full names
    const Map<String, String> dayMap = {
      "mon": "Monday",
      "tue": "Tuesday",
      "wed": "Wednesday",
      "thu": "Thursday",
      "fri": "Friday",
    };

    for (final item in data.items) {
      for (final dayAbbr in item.specialDays) {
        final normalizedDay = dayMap[dayAbbr.toLowerCase().trim()];
        if (normalizedDay != null) {
          map[normalizedDay]!.add(item); // Add item to the correct day
        }
      }
    }

    return map;
  }
}
