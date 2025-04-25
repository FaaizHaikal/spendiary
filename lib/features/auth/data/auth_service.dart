import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spendiary/core/contants.dart';
import 'models/auth_response.dart';

class AuthService {
  static Future<AuthResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(data);
    } else {
      final error = data['error'] ?? 'Failed to login';

      throw Exception(error);
    }
  }

  static Future<void> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      return;
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to register';

      throw Exception(error);
    }
  }
}
