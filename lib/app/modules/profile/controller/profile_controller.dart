import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
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
}
