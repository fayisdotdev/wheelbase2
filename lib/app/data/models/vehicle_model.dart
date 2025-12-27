import 'package:meta/meta.dart';

class Vehicle {
  final String vehicleId;
  final String ownerName;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleYear;
  final DateTime? createdAt;
  final DateTime? uploadedAt;
  final DateTime? insuranceStarts;
  final DateTime? insuranceEnds;
  final DateTime? pollutionStarts;
  final DateTime? pollutionEnds;
  final String? battery;
  final String? alignment;
  final String? serviceKm;
  final String? notes;
  final bool needNotification;
  final bool sharedWith;
  final String? imageUrl;
  final String userAuthUuid;
  final String vehicleAddedBy;

  Vehicle({
    required this.vehicleId,
    required this.ownerName,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleYear,
    this.createdAt,
    this.uploadedAt,
    this.insuranceStarts,
    this.insuranceEnds,
    this.pollutionStarts,
    this.pollutionEnds,
    this.battery,
    this.alignment,
    this.serviceKm,
    this.notes,
    this.needNotification = false,
    this.sharedWith = false,
    this.imageUrl,
    required this.userAuthUuid,
    required this.vehicleAddedBy,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      vehicleId: map['vehicle_id'] ?? '',
      ownerName: map['owner_name'] ?? '',
      vehicleName: map['vehicle_name'] ?? '',
      vehicleNumber: map['vehicle_number'] ?? '',
      vehicleYear: map['vehicle_year'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'])
          : null,
      uploadedAt: map['uploaded_at'] != null
          ? DateTime.parse(map['uploaded_at'])
          : null,
      insuranceStarts: map['insurance_starts'] != null
          ? DateTime.parse(map['insurance_starts'])
          : null,
      insuranceEnds: map['insurance_ends'] != null
          ? DateTime.parse(map['insurance_ends'])
          : null,
      pollutionStarts: map['pollution_starts'] != null
          ? DateTime.parse(map['pollution_starts'])
          : null,
      pollutionEnds: map['pollution_ends'] != null
          ? DateTime.parse(map['pollution_ends'])
          : null,
      battery: map['battery'],
      alignment: map['alignment'],
      serviceKm: map['service_km'],
      notes: map['notes'],
      needNotification: map['need_notification'] ?? false,
      sharedWith: map['shared_with'] ?? false,
      imageUrl: map['image_url'],
      userAuthUuid: map['user_auth_uuid'] ?? '',
      vehicleAddedBy: map['vehicle_added_by'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicle_id': vehicleId,
      'owner_name': ownerName,
      'vehicle_name': vehicleName,
      'vehicle_number': vehicleNumber,
      'vehicle_year': vehicleYear,
      'created_at': createdAt?.toIso8601String(),
      'uploaded_at': uploadedAt?.toIso8601String(),
      'insurance_starts': insuranceStarts?.toIso8601String(),
      'insurance_ends': insuranceEnds?.toIso8601String(),
      'pollution_starts': pollutionStarts?.toIso8601String(),
      'pollution_ends': pollutionEnds?.toIso8601String(),
      'battery': battery,
      'alignment': alignment,
      'service_km': serviceKm,
      'notes': notes,
      'need_notification': needNotification,
      'shared_with': sharedWith,
      'image_url': imageUrl,
      'user_auth_uuid': userAuthUuid,
      'vehicle_added_by': vehicleAddedBy,
    };
  }
}
