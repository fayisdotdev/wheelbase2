import 'package:get/get.dart';
import '../../../data/services/vehicle_service.dart';
import '../../../data/models/vehicle_model.dart';
import '../../../data/services/image_service.dart';

class VehicleController extends GetxController {
  final VehicleService _vehicleService = VehicleService();
  final ImageService _imageService = ImageService();
  final RxList<Vehicle> vehicles = <Vehicle>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  Future<void> fetchVehicles(String userAuthUuid) async {
    loading.value = true;
    try {
      vehicles.value = await _vehicleService.fetchVehicles(userAuthUuid);
    } catch (e) {
      error.value = e.toString();
      vehicles.clear();
    } finally {
      loading.value = false;
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    loading.value = true;
    try {
      await _vehicleService.addVehicle(vehicle);
      vehicles.add(vehicle);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    loading.value = true;
    try {
      await _vehicleService.updateVehicle(vehicle);
      int idx = vehicles.indexWhere((v) => v.vehicleId == vehicle.vehicleId);
      if (idx != -1) vehicles[idx] = vehicle;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteVehicle(String vehicleId) async {
    loading.value = true;
    try {
      await _vehicleService.deleteVehicle(vehicleId);
      vehicles.removeWhere((v) => v.vehicleId == vehicleId);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<String?> pickAndUploadImage(String fileName) async {
    loading.value = true;
    try {
      final file = await _imageService.pickImage();
      if (file == null) return null;
      return await _imageService.uploadImage(file, fileName);
    } catch (e) {
      error.value = e.toString();
      return null;
    } finally {
      loading.value = false;
    }
  }
}
