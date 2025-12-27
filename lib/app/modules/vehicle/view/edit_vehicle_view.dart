import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vehicle_controller.dart';
import 'widgets/vehicle_form.dart';
import '../../../widgets/app_appbar.dart';
import '../../../data/models/vehicle_model.dart';

class EditVehicleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleController controller = Get.find();
    final Vehicle vehicle = Get.arguments as Vehicle;
    return Scaffold(
      appBar: const AppAppBar(title: 'Edit Vehicle'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Obx(
          () => VehicleForm(
            vehicle: vehicle,
            loading: controller.loading.value,
            onSubmit: (updated) async {
              await controller.updateVehicle(updated);
              Get.back();
            },
          ),
        ),
      ),
    );
  }
}
