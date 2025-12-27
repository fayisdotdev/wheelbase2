import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controller/auth_controller.dart';

class SplashController extends GetxController {
  final RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 1));

    final authController = Get.put(AuthController(), permanent: true);
    final supabaseUser = Supabase.instance.client.auth.currentUser;

    if (supabaseUser != null) {
      try {
        await authController.fetchUserProfile();
        if (authController.userProfile.value != null) {
          Get.offAllNamed(AppRoutes.vehicleList);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
      } catch (e) {
        debugPrint("Error fetching user profile: $e");
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
