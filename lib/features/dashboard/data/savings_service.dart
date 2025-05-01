import 'dart:convert';
import 'package:spendiary/core/services/dio_client.dart';
import 'package:spendiary/core/models/saving.dart';

class SavingService {
  static Future<List<Saving>> getCurrentYearSaving() async {
    final year = DateTime.now().year.toString();

    final response = await DioClient.dio.get(
      '/api/expenses/annual',
      queryParameters: {'year': year},
    );

    if (response.statusCode != 200) {
      final error =
          json.decode(response.data)['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return response.data.map((item) => Saving.fromJson(item)).toList();
  }
}
