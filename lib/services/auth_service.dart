import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendiary/services/storage_service.dart';
import '../core/contants.dart';

class AuthResponse {
  final bool success;
  final String? message;

  AuthResponse({required this.success, this.message});
}

class AuthService {
  static Future<AuthResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      await StorageService.saveTokens(
        data['access_token'],
        data['refresh_token'],
      );

      return AuthResponse(success: true);
    } else {
      final data = jsonDecode(response.body);
      
      return AuthResponse(
        success: false,
        message: data['message'] ?? 'Login failed',
      );
    }
  }

  static Future<AuthResponse> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse(success: true);
    } else {
      final data = jsonDecode(response.body);
      
      return AuthResponse(
        success: false,
        message: data['message'] ?? 'Registration failed',
      );
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }
}