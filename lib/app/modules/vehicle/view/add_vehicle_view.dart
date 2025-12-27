import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vehicle_controller.dart';
import 'widgets/vehicle_form.dart';
import '../../../widgets/app_appbar.dart';

class AddVehicleView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VehicleController controller = Get.find();
    return Scaffold(
      appBar: const AppAppBar(title: 'Add Vehicle'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(
            () => VehicleForm(
              loading: controller.loading.value,
              onSubmit: (vehicle) async {
                await controller.addVehicle(vehicle);
                Get.back();
              },
            ),
          ),
        ),
      ),
    );
  }
}
