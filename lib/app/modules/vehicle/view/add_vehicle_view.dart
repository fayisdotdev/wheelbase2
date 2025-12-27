import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheelbase/app/modules/auth/controller/auth_controller.dart';
import 'package:wheelbase/app/modules/vehicle/controller/vehicle_controller.dart';
import 'package:wheelbase/app/modules/vehicle/view/widgets/vehicle_form.dart';
import 'package:wheelbase/app/widgets/app_appbar.dart';

class AddVehicleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleController vehicleController = Get.find();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Add Vehicle'),
      body: Obx(() {
        // Show loader while fetching user profile
        if (authController.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Ensure userProfile is available
        if (authController.userProfile.value == null) {
          return const Center(
              child: Text('User not logged in. Please try again.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: VehicleForm(
            loading: vehicleController.loading.value,
            onSubmit: (vehicle) async {
              await vehicleController.addVehicle(vehicle);
              Get.back();
            },
          ),
        );
      }),
    );
  }
}
