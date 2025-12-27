import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheelbase/app/modules/auth/controller/auth_controller.dart';
import '../controller/profile_controller.dart';
import '../../../widgets/app_loader.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find();
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authController.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: AppLoader());
        }
        if (controller.userProfile.value == null) {
          return const Center(child: Text('No profile data'));
        }
        final user = controller.userProfile.value!;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${user.name}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Email: ${user.email}'),
              const SizedBox(height: 8),
              Text('Phone: ${user.phone}'),
              const SizedBox(height: 8),
              Text('UUID: ${user.uuid}'),
              const SizedBox(height: 8),
              Text('Created: ${user.createdAt.toLocal()}'),
            ],
          ),
        );
      }),
    );
  }
}
