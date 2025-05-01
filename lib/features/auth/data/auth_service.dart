import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spendiary/core/contants.dart';
import 'package:spendiary/core/services/storage_service.dart';
import 'models/auth_response.dart';

class AuthService {
  static Future<AuthResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      final error = data['error'] ?? 'Failed to login';

      throw Exception(error);
    }

    return AuthResponse.fromJson(data);
  }

  static Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to register';

      throw Exception(error);
    }
  }

  static Future<bool> verifyAccessToken() async {
    final accessToken = await StorageService.getAccessToken();

    if (accessToken == null) {
      return false;
    }

    final response = await http.get(
      Uri.parse('$baseUrl/api/user/verify'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    return response.statusCode == 200;
  }

  static Future<bool> refreshAccessToken() async {
    final refreshToken = await StorageService.getRefreshToken();

    if (refreshToken == null) {
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/refresh'),
      body: jsonEncode({'refresh_token': refreshToken}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return false;
    }

    final accessToken = jsonDecode(response.body)['access_token'];
    await StorageService.saveAccessToken(accessToken);

    return true;
  }
}
