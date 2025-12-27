import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheelbase/app/modules/auth/controller/auth_controller.dart';
import 'package:wheelbase/app/modules/vehicle/controller/vehicle_controller.dart';
import 'package:wheelbase/app/routes/app_routes.dart';
import 'package:wheelbase/app/widgets/app_loader.dart';
import 'package:wheelbase/app/widgets/vehicle_card.dart';


class VehicleListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleController vehicleController = Get.find();
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Obx(() {
        // Wait for user profile
        if (authController.loading.value) {
          return const Center(child: AppLoader());
        }

        final user = authController.userProfile.value;
        if (user == null) {
          return const Center(child: Text('User not logged in'));
        }

        // Fetch vehicles if not loaded
        if (!vehicleController.loading.value &&
            vehicleController.vehicles.isEmpty) {
          vehicleController.fetchVehicles(user.authUuid);
        }

        if (vehicleController.loading.value) {
          return const Center(child: AppLoader());
        }

        if (vehicleController.vehicles.isEmpty) {
          return const Center(child: Text('No vehicles found'));
        }

        return ListView.builder(
          itemCount: vehicleController.vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicleController.vehicles[index];
            return VehicleCard(
              vehicle: vehicle,
              onTap: () =>
                  Get.toNamed(AppRoutes.vehicleDetail, arguments: vehicle),
              onEdit: () =>
                  Get.toNamed(AppRoutes.editVehicle, arguments: vehicle),
              onDelete: () =>
                  vehicleController.deleteVehicle(vehicle.vehicleId),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authController.userProfile.value != null) {
            Get.toNamed(AppRoutes.addVehicle);
          } else {
            Get.snackbar('Error', 'User profile not loaded yet');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
