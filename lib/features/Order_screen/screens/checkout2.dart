import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutx_core/core/validation/validators.dart';
import 'package:get/get.dart';
import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/common/widgets/button_widgets.dart';
import '../../../core/constants/assets_const.dart';
import '../../../core/utils/app_svg.dart';

class Checkout2Screen extends StatefulWidget {
  const Checkout2Screen({super.key});

  @override
  State<Checkout2Screen> createState() => _Checkout2ScreenState();
}

class _Checkout2ScreenState extends State<Checkout2Screen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final orderController = Get.find<OrderController>();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    orderController.fetchCart();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null) {
      Get.snackbar('Error', 'Please select a delivery date');
      return;
    }

    String timeText = timeController.text.toLowerCase().trim();
    int? totalMinutes;

    if (timeText.contains("hr") || timeText.contains("hour")) {
      String numericPart = timeText.replaceAll(RegExp(r'[a-z]'), '').trim();
      double? hours = double.tryParse(numericPart);
      if (hours != null) {
        totalMinutes = (hours * 60).toInt();
      }
    } else {
      String numericPart = timeText.replaceAll(RegExp(r'[a-z]'), '').trim();
      totalMinutes = int.tryParse(numericPart);
    }

    if (totalMinutes == null || totalMinutes < 30) {
      Get.snackbar(
        'Invalid Time',
        'Minimum delivery time is 30 mins. Please use formats like "30" or "1 hr"',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final now = DateTime.now();
    final calculatedTime = now.add(Duration(minutes: totalMinutes));

    // Combine the date from selectedDate with the time part calculated from duration
    final scheduledFor = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      calculatedTime.hour,
      calculatedTime.minute,
    );

    orderController.placeOrder(
      addressController.text,
      phoneController.text,
      scheduledFor,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final isAfter11AM = now.hour >= 11;
    final tomorrow = now.add(const Duration(days: 1));
    final firstSelectableDate = now.add(Duration(days: isAfter11AM ? 2 : 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: null,
      helpText: "You can't order for tomorrow after 11:00 AM",
      firstDate: firstSelectableDate,
      lastDate: now.add(const Duration(days: 30)),
      selectableDayPredicate: (DateTime day) {
        // Disable Today
        if (day.year == now.year &&
            day.month == now.month &&
            day.day == now.day) {
          return false;
        }
        // Disable Saturday (6) and Sunday (7)
        if (day.weekday == DateTime.saturday ||
            day.weekday == DateTime.sunday) {
          return false;
        }
        // Disable Tomorrow if after 11 AM
        if (isAfter11AM) {
          if (day.year == tomorrow.year &&
              day.month == tomorrow.month &&
              day.day == tomorrow.day) {
            return false;
          }
        }
        return true;
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFAD653F),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    child!, // This is the DatePickerDialog
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0x2EFFB972), // full width to bottom
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            left: 15,
            right: 15,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // important to avoid full-screen height
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "\$${orderController.cart.value!.total.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              PrimaryButton(
                text: 'Place Order',
                key: Key("checkout"),
                onApiPressed: () => _submit(),
              ),
            ],
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // The main container with address, phone, delivery
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0x2EFFB972),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTile(
                      imagePath: Images.address,
                      title: "Home",
                      child: TextFormField(
                        controller: addressController,
                        validator: Validators.name,
                        decoration: const InputDecoration(
                          hintText: "Enter address",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    _divider(),
                    _buildTile(
                      imagePath: Images.phone,
                      title: "Phone",
                      child: TextFormField(
                        validator: Validators.phone,
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          hintText: "+88 00-1111-2222",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    _divider(),
                    _buildTile(
                      imagePath: Images.calendar,
                      title: "Delivery Date",
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: TextFormField(
                          enabled: false,
                          controller: dateController,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: "Select delivery date",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                    _divider(),
                    _buildTile(
                      imagePath: Images.delivery,
                      title: "Delivery Time",
                      child: TextFormField(
                        controller: timeController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter delivery time";
                          }
                          String timeText = value.toLowerCase().trim();
                          int? totalMinutes;

                          if (timeText.contains("hr") ||
                              timeText.contains("hour")) {
                            String numericPart = timeText
                                .replaceAll(RegExp(r'[a-z]'), '')
                                .trim();
                            double? hours = double.tryParse(numericPart);
                            if (hours != null) {
                              totalMinutes = (hours * 60).toInt();
                            }
                          } else {
                            String numericPart = timeText
                                .replaceAll(RegExp(r'[a-z]'), '')
                                .trim();
                            totalMinutes = int.tryParse(numericPart);
                          }

                          if (totalMinutes == null) {
                            return "Invalid format (e.g. 30 mins, 1 hr)";
                          }
                          if (totalMinutes < 30) {
                            return "Minimum duration is 30 mins";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "e.g. 30 mins or 1 hr",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Divider(color: Color(0xFFAD653F), thickness: 1),
    );
  }

  Widget _buildTile({
    required String imagePath,
    String? suffixImagePath,
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFEFD5),
              borderRadius: BorderRadius.circular(44),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppSvg(asset: imagePath, width: 22, height: 22),
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child,
              ],
            ),
          ),

          if (suffixImagePath != null)
            Image.asset(suffixImagePath, width: 22, height: 22),
        ],
      ),
    );
  }
}
