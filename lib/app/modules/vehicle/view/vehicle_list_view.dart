import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheelbase/app/modules/auth/controller/auth_controller.dart';
import '../controller/vehicle_controller.dart';
import '../../../widgets/vehicle_card.dart';
import '../../../widgets/app_loader.dart';
import '../../../widgets/app_appbar.dart';
import '../../../routes/app_routes.dart';

class VehicleListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleController vehicleController = Get.find();
    final authController = Get.find<AuthController>();

    // Fetch vehicles if not already loaded
    if (vehicleController.vehicles.isEmpty &&
        authController.userProfile.value != null) {
      vehicleController.fetchVehicles(
        authController.userProfile.value!.authUuid,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
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
        onPressed: () => Get.toNamed(AppRoutes.addVehicle),
        child: const Icon(Icons.add),
      ),
    );
  }
}
