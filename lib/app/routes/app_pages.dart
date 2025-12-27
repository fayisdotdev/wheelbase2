import 'package:get/get.dart';
import '../modules/splash/view/splash_view.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/auth/view/login_view.dart';
import '../modules/auth/view/signup_view.dart';
import '../modules/auth/binding/auth_binding.dart';
import '../modules/profile/view/profile_view.dart';
import '../modules/profile/binding/profile_binding.dart';
import '../modules/vehicle/view/vehicle_list_view.dart';
import '../modules/vehicle/view/add_vehicle_view.dart';
import '../modules/vehicle/view/edit_vehicle_view.dart';
import '../modules/vehicle/view/vehicle_detail_view.dart';
import '../modules/vehicle/binding/vehicle_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.vehicleList,
      page: () => VehicleListView(),
      binding: VehicleBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addVehicle,
      page: () => AddVehicleView(),
      binding: VehicleBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.editVehicle,
      page: () => EditVehicleView(),
      binding: VehicleBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.vehicleDetail,
      page: () => VehicleDetailView(),
      binding: VehicleBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
