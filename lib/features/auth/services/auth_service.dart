import 'package:spendiary/core/services/dio_client.dart';
import 'package:spendiary/core/services/storage_service.dart';
import '../models/auth_response.dart';

class AuthService {
  static Future<AuthResponse> login(String username, String password) async {
    final response = await DioClient.dio.post(
      '/api/login',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode != 200) {
      final error = response.data['error'] ?? 'Failed to login';

      throw Exception(error);
    }

    return AuthResponse.fromJson(response.data);
  }

  static Future<void> register(String username, String password) async {
    final response = await DioClient.dio.post(
      '/api/register',
      data: {'username': username, 'password': password},
    );

    if (response.statusCode != 201) {
      final error = response.data['error'] ?? 'Failed to register';

      throw Exception(error);
    }
  }

  static Future<bool> verifyAccessToken() async {
    final response = await DioClient.dio.get('/api/user/verify');

    return response.statusCode == 200;
  }

  static Future<bool> refreshAccessToken() async {
    final refreshToken = await StorageService.getRefreshToken();

    if (refreshToken == null) {
      return false;
    }

    final response = await DioClient.dio.post(
      '/api/refresh',
      data: {'refresh_token': refreshToken},
    );

    if (response.statusCode != 200) {
      await StorageService.clearTokens();

      return false;
    }

    final accessToken = response.data['access_token'];
    await StorageService.saveAccessToken(accessToken);

    return true;
  }
}
