import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile_model.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<User?> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    // Supabase API call: signInWithPassword
    if (response.user == null) {
      // Failure handling: throws Exception, but no logging or analytics
      // SUGGESTION: Add try/catch and log error for analytics
      throw Exception('Login failed');
    }
    // Success: returns user, but not logged/tracked
    // SUGGESTION: Log successful login for analytics
    return response.user;
  }

  Future<User?> signup(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name, 'phone': phone},
    );
    // Supabase API call: signUp
    // No explicit error handling for signup failure (e.g., response.user == null)
    // SUGGESTION: Add check for response.user == null and handle failure/logging
    // Insert into users table
    await _client.from('users').insert({
      'email': email,
      'name': name,
      'phone': phone,
      'auth_uuid': response.user!.id,
      'uuid': response.user!.id,
    });
    // Success: returns user, but not logged/tracked
    // SUGGESTION: Log successful signup for analytics
    return response.user;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    // Supabase API call: signOut
    // No error handling or logging
    // SUGGESTION: Add try/catch and log logout event for analytics
  }

  Future<UserProfile?> fetchUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final data = await _client
        .from('users')
        .select()
        .eq('auth_uuid', user.id)
        .single();
    // Supabase API call: get current user
    // No error handling for failed query (e.g., network error, not found)
    // SUGGESTION: Add try/catch and log errors for analytics
    if (data == null) return null;
    // Success: returns UserProfile, but not logged/tracked
    // SUGGESTION: Log profile fetch for analytics
    return UserProfile.fromMap(data);
  }

  // ...existing code...
}
