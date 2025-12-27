import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_appbar.dart';
import '../../../data/models/vehicle_model.dart';

class VehicleDetailView extends StatelessWidget {
  const VehicleDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Vehicle vehicle = Get.arguments as Vehicle;
    return Scaffold(
      appBar: const AppAppBar(title: 'Vehicle Details'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            if (vehicle.imageUrl != null && vehicle.imageUrl!.isNotEmpty)
              Image.network(vehicle.imageUrl!, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              'Name: ${vehicle.vehicleName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Number: ${vehicle.vehicleNumber}'),
            const SizedBox(height: 8),
            Text('Year: ${vehicle.vehicleYear}'),
            const SizedBox(height: 8),
            Text('Service KM: ${vehicle.serviceKm ?? ''}'),
            const SizedBox(height: 8),
            Text(
              'Insurance: ${vehicle.insuranceStarts?.toLocal()} - ${vehicle.insuranceEnds?.toLocal()}',
            ),
            const SizedBox(height: 8),
            Text(
              'Pollution: ${vehicle.pollutionStarts?.toLocal()} - ${vehicle.pollutionEnds?.toLocal()}',
            ),
            const SizedBox(height: 8),
            Text('Notes: ${vehicle.notes ?? ''}'),
          ],
        ),
      ),
    );
  }
}
