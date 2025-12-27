import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Vehicle>> fetchVehicles(String userAuthUuid) async {
    final data = await _client
        .from('vehicles')
        .select()
        .eq('user_auth_uuid', userAuthUuid)
        .order('created_at', ascending: false);
    return (data as List).map((e) => Vehicle.fromMap(e)).toList();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await _client.from('vehicles').insert(vehicle.toMap());
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _client
        .from('vehicles')
        .update(vehicle.toMap())
        .eq('vehicle_id', vehicle.vehicleId);
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _client.from('vehicles').delete().eq('vehicle_id', vehicleId);
  }

  Future<String> getSignedImageUrl(String path) async {
    final res = await _client.storage
        .from('vehicle_images')
        .createSignedUrl(path, 60 * 60 * 24);
    return res;
  }
}
