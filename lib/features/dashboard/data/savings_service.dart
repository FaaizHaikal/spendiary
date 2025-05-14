import 'dart:convert';
import 'package:spendiary/core/services/dio_client.dart';
import 'package:spendiary/core/models/saving.dart';

class SavingsService {
  static Future<double> getSavingsTotal() async {
    final response = await DioClient.dio.get('/api/expenses/total');

    if (response.statusCode != 200) {
      final error =
          json.decode(response.data)['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return response.data['amount'].toDouble();
  }

  static Future<List<Saving>> getCurrentYearSavings() async {
    final year = DateTime.now().year.toString();

    final response = await DioClient.dio.get(
      '/api/user/savings/annual',
      queryParameters: {'year': year},
    );

    if (response.statusCode != 200) {
      final error =
          json.decode(response.data)['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return (response.data as List)
        .map((item) => Saving.fromJson(item))
        .toList();
  }

  static Future<double> getCurrentYearSavingsTotal() async {
    final year = DateTime.now().year.toString();

    final response = await DioClient.dio.get(
      '/api/user/savings/annual/total',
      queryParameters: {'year': year},
    );

    if (response.statusCode != 200) {
      final error =
          json.decode(response.data)['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return response.data['amount'].toDouble();
  }

  static Future<List<Saving>> getRecentSavings(int count) async {
    final response = await DioClient.dio.get(
      '/api/user/savings/recent',
      queryParameters: {'count': count},
    );

    if (response.statusCode != 200) {
      final error = response.data['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return (response.data as List)
        .map((item) => Saving.fromJson(item))
        .toList();
  }
}
