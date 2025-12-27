import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:wheelbase/app/modules/auth/controller/auth_controller.dart';
import 'package:wheelbase/app/modules/vehicle/controller/vehicle_controller.dart';

class VehicleBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure AuthController is available for VehicleListView
    if (!Get.isRegistered<AuthController>()) {
      Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    }
    Get.lazyPut<VehicleController>(() => VehicleController());
  }
}
