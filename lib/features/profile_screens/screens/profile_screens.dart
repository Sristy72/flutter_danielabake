// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/profile_controller.dart';
// import '../widgets/profile_card.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final _profileController = Get.find<ProfileController>();
//
//   @override
//   void initState() {
//     super.initState();
//     _profileController.fetchProfile();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Obx(() {
//           final user = _profileController.userInfo.value;
//
//           if (user == null) {
//             return const CircularProgressIndicator(); // Loading state
//           }
//
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ProfileCard(
//                 name: user.fullName,
//                 imagePath: user.avatarUrl,
//                 orders: user.totalOrders.toString(),
//                 favorites: user.totalFavorites.toString(),
//                 onEdit: () {
//                   print('Edit clicked');
//                 },
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui'; // For ImageFilter
import 'package:danielabake/features/auth/screens/login_screen.dart'; // Safe package import
import '../controller/profile_controller.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isGuest = _profileController.isGuest.value;
        final user = _profileController.userInfo.value;

        // If guest, show blurred dummy content + Sign In button
        if (isGuest) {
          return Stack(
            children: [
              // Blurred Background (Dummy Content)
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ProfileCard(
                      name: "Guest User",
                      imagePath: "", // Placeholder or empty
                      orders: "0",
                      favorites: "0",
                      onEdit: () {},
                    ),
                  ),
                ),
              ),

              // Sign In / Sign Up Button
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Please sign in to view your profile",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.to(() => const LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Match app theme
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "Sign In / Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // If authenticated but data not loaded yet
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Authenticated Content
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ProfileCard(
              name: user.fullName,
              imagePath: user.avatarUrl,
              orders: user.totalOrders.toString(),
              favorites: user.totalFavorites.toString(),
              onEdit: () {
                print('Edit clicked');
              },
            ),
          ),
        );
      }),
    );
  }
}
