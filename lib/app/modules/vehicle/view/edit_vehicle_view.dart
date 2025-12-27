import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wheelbase/app/data/models/vehicle_model.dart';
import 'package:wheelbase/app/modules/vehicle/controller/vehicle_controller.dart';
import 'package:wheelbase/app/modules/vehicle/view/widgets/vehicle_form.dart';
import 'package:wheelbase/app/widgets/app_appbar.dart';


class EditVehicleView extends StatelessWidget {
  const EditVehicleView({super.key});

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
