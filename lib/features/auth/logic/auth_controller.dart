import 'package:spendiary/features/auth/data/auth_service.dart';
import 'package:spendiary/core/services/storage_service.dart';

class AuthController {
  static Future<String?> login(String username, String password) async {
    try {
      final response = await AuthService.login(username, password);

      await StorageService.saveTokens(response.accessToken, response.refreshToken);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> register(String username, String password) async {
    try {
      await AuthService.register(username, password);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<void> logout() async {
    await StorageService.clearTokens();
  }
}