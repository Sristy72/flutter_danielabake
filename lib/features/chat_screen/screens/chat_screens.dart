import 'dart:ui';
import 'package:danielabake/features/auth/screens/login_screen.dart';
import 'package:danielabake/features/chat_screen/controller/message_controller.dart';
import 'package:danielabake/features/profile_screens/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/common/widgets/app_scaffold.dart';
import '../../../core/network/services/secure_store_services.dart';
import '../../../core/network/services/auth_storage_service.dart';
import '../../profile_screens/widgets/chat_list_tile.dart';
import '../widgets/profile.dart';
import 'messaging_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _profileController = Get.find<ProfileController>();
  final _msgController = Get.find<MessageController>();
  final AuthStorageService _authStorageService = AuthStorageService();

  String conversationId = "";
  final RxBool _isGuest = false.obs;
  final RxBool _isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final userId = await _authStorageService.getUserId();
    if (userId == null || userId.isEmpty) {
      _isGuest.value = true;
    } else {
      _isGuest.value = false;
      await initChat();
    }
    _isLoading.value = false;
  }

  Future<void> initChat() async {
    // Fetch admin
    await _msgController
        .getAdmin(); // Make sure getAdmin() is async and returns after fetching admin
    // Once admin is fetched, create conversation if needed
    final admin = _msgController.admin.value;
    if (admin != null) {
      conversationId = await _msgController.getConversationId(admin.id);
    }

    _msgController.socketInitChat();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Obx(() {
        if (_isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_isGuest.value) {
          return Stack(
            children: [
              ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: _buildChatContent(isGuest: true),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Not Signed In",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please sign in to view messages.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Get.to(() => const LoginScreen()),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF7F3615),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text("Sign In"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        return _buildChatContent(isGuest: false);
      }),
    );
  }

  Widget _buildChatContent({required bool isGuest}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User profile
          if (isGuest)
            const Profile(
              name: "Guest User",
              imagePath: "https://via.placeholder.com/150",
            )
          else
            Obx(() {
              final user = _profileController.userInfo.value;
              if (user == null) return const CircularProgressIndicator();

              return Profile(name: user.fullName, imagePath: user.avatarUrl);
            }),

          const SizedBox(height: 30),

          // Chat with admin
          if (isGuest)
            const ChatListTile(
              name: "Admin",
              avatarUrl: "https://via.placeholder.com/150",
            )
          else
            Obx(() {
              final admin = _msgController.admin.value;
              final error = _msgController.errorMessage.value;

              if (admin == null) {
                if (error.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }

              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => MessagingScreen(
                      adminId: admin.id,
                      conversationId: conversationId,
                    ),
                  );
                },
                child: ChatListTile(name: admin.name, avatarUrl: admin.avatar),
              );
            }),
        ],
      ),
    );
  }
}
