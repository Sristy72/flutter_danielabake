import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownWithButton extends StatelessWidget {
  DropdownWithButton({
    super.key,
    required this.onDayChanged,
    required this.onTap,
  });

  final ValueChanged<String?> onDayChanged;
  final VoidCallback onTap;

  static const List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Rx selected value (local UI state)
  final RxString selectedDay = 'Today'.obs;

  /// Build dropdown items with Today logic
  List<String> getDropdownItems() {
    final now = DateTime.now();
    // DateTime.weekday: 1 = Monday, ..., 7 = Sunday
    final todayName = weekdays[now.weekday - 1];
    return ['Today', ...weekdays.where((d) => d != todayName)];
  }

  @override
  Widget build(BuildContext context) {
    final items = getDropdownItems();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Dropdown
        Obx(
          () => DropdownButton<String>(
            value: selectedDay.value,
            underline: const SizedBox(),
            dropdownColor: Color(0xFFFFF1DB),
            icon: const Icon(Icons.keyboard_arrow_down),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            items: items.map((day) {
              return DropdownMenuItem(value: day, child: Text(day));
            }).toList(),

            /// 🔥 FIX IS HERE
            onChanged: (value) {
              if (value == null) return;

              selectedDay.value = value; // ✅ UPDATE DROPDOWN STATE
              onDayChanged(value); // ✅ CALL PARENT
            },
          ),
        ),

        /// View all button
        TextButton(
          onPressed: onTap,
          child: const Text(
            'View all',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF1753FF),
            ),
          ),
        ),
      ],
    );
  }
}
