import '../models/auth_response.dart';
import '../services/api_service.dart';
import '../core/config.dart';
import 'dart:convert';

class AuthRepository {
  final ApiService apiService;
  
  AuthRepository(this.apiService);
  
  // Device registration using fixed assignment auth token.
  // Returns visitor token string if successful.
  Future<String?> registerDevice({
    required Map<String, dynamic> deviceInfo,
  }) async {
    try {
      final payload = {
        'action': 'deviceRegister',
        'deviceRegister': deviceInfo,
      };
      final response = await apiService.postWithAuthToken(
        '',
        authToken: Config.apiAuthToken,
        data: payload,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        // Try multiple common paths
        final token = data['visitorToken'] ??
            data['token'] ??
            (data['data'] is Map<String, dynamic> ? data['data']['token'] : null) ??
            (data['data'] is Map<String, dynamic> ? data['data']['visitorToken'] : null);
        if (token is String && token.isNotEmpty) {
          return token;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<AuthResponse> register({
    required String phone,
    String? name,
  }) async {
    try {
      final response = await apiService.post(
        Config.registerEndpoint,
        data: {
          'phone': phone,
          if (name != null) 'name': name,
        },
      );
      
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }
  
  Future<AuthResponse> login({
    required String phone,
  }) async {
    try {
      final response = await apiService.post(
        Config.loginEndpoint,
        data: {
          'phone': phone,
        },
      );
      
      return AuthResponse.fromJson(response.data);
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Login failed: ${e.toString()}',
      );
    }
  }
}
