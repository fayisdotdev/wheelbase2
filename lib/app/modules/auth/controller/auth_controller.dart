import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:wheelbase/app/data/models/user_profile_model.dart';
import 'package:wheelbase/app/data/services/auth_service.dart';
import 'package:wheelbase/app/modules/vehicle/controller/vehicle_controller.dart';
import 'package:wheelbase/app/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  // LOGIN
  Future<void> login(String email, String password) async {
    loading.value = true;
    error.value = '';
    try {
      await _authService.login(email, password);
      await fetchUserProfile();
      if (userProfile.value != null) {
        Get.offAllNamed(AppRoutes.vehicleList);
      } else {
        error.value = "User profile not found after login";
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint("Login error: $e");
    } finally {
      loading.value = false;
    }
  }

  // SIGNUP
  Future<void> signup(
      String email, String password, String name, String phone) async {
    loading.value = true;
    error.value = '';
    try {
      await _authService.signup(email, password, name, phone);
      await fetchUserProfile();
      if (userProfile.value != null) {
        Get.offAllNamed(AppRoutes.vehicleList);
      } else {
        error.value = "User profile not found after signup";
      }
    } catch (e) {
      error.value = e.toString();
      debugPrint("Signup error: $e");
    } finally {
      loading.value = false;
    }
  }

  // FETCH PROFILE
  Future<void> fetchUserProfile() async {
    loading.value = true;
    try {
      final profile = await _authService.fetchUserProfile();
      userProfile.value = profile;
      debugPrint("User profile fetched: $profile");
    } catch (e) {
      userProfile.value = null;
      error.value = e.toString();
      debugPrint("Fetch user profile error: $e");
    } finally {
      loading.value = false;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    await _authService.logout();
    userProfile.value = null;

    // Clear vehicles on logout
    try {
      final vehicleController = Get.find<VehicleController>();
      vehicleController.vehicles.clear();
    } catch (_) {}

    Get.offAllNamed(AppRoutes.login);
  }
}
