import 'dart:convert';
import 'package:spendiary/core/contants.dart';
import 'package:spendiary/core/services/storage_service.dart';
import 'package:spendiary/core/models/saving.dart';
import 'package:http/http.dart' as http;

class SavingService {
  static Future<List<Saving>> getCurrentYearSaving() async {
    final accessToken = await StorageService.getAccessToken();

    if (accessToken == null) {
      throw Exception('Access token is missing. User may not be logged in.');
    }

    final year = DateTime.now().year.toString();

    final uri = Uri.parse(
      '$baseUrl/api/expenses/annual',
    ).replace(queryParameters: {'year': year});

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final error =
          json.decode(response.body)['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    final List<dynamic> jsonList = json.decode(response.body);

    return jsonList.map((json) => Saving.fromJson(json)).toList();
  }
}
