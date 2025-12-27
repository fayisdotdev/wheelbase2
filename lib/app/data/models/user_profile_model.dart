import 'package:meta/meta.dart';

class UserProfile {
  final int id;
  final String email;
  final String name;
  final String phone;
  final String authUuid;
  final String uuid;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.authUuid,
    required this.uuid,
    required this.createdAt,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as int,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      authUuid: map['auth_uuid'] ?? '',
      uuid: map['uuid'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'auth_uuid': authUuid,
      'uuid': uuid,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
