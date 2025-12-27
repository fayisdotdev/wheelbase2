import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/user_profile_model.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);

  Future<void> login(String email, String password) async {
    loading.value = true;
    error.value = '';
    try {
      await _authService.login(email, password);
      await fetchUserProfile();
      Get.offAllNamed(AppRoutes.vehicleList);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> signup(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    loading.value = true;
    error.value = '';
    try {
      await _authService.signup(email, password, name, phone);
      await fetchUserProfile();
      Get.offAllNamed(AppRoutes.vehicleList);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchUserProfile() async {
    loading.value = true;
    try {
      userProfile.value = await _authService.fetchUserProfile();
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    userProfile.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
