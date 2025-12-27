import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 2));
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      Get.offAllNamed(AppRoutes.vehicleList);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
