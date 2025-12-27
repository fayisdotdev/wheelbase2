import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vehicle_controller.dart';
import '../../../widgets/vehicle_card.dart';
import '../../../widgets/app_loader.dart';
import '../../../widgets/app_appbar.dart';
import '../../../routes/app_routes.dart';

class VehicleListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleController controller = Get.find();
    return Scaffold(
      appBar: const AppAppBar(title: 'Vehicles'),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: AppLoader());
        }
        if (controller.vehicles.isEmpty) {
          return const Center(child: Text('No vehicles found'));
        }
        return ListView.builder(
          itemCount: controller.vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = controller.vehicles[index];
            return VehicleCard(
              vehicle: vehicle,
              onTap: () =>
                  Get.toNamed(AppRoutes.vehicleDetail, arguments: vehicle),
              onEdit: () =>
                  Get.toNamed(AppRoutes.editVehicle, arguments: vehicle),
              onDelete: () => controller.deleteVehicle(vehicle.vehicleId),
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
