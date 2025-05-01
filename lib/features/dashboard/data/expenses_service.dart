import 'dart:convert';
import 'package:spendiary/core/contants.dart';
import 'package:spendiary/core/services/storage_service.dart';
import 'package:spendiary/core/models/expense.dart';
import 'package:http/http.dart' as http;
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';

class ExpenseService {
  static Future<List<ChartPoint>> getExpensesByPeriod(String period) async {
    final accessToken = await StorageService.getAccessToken();

    if (accessToken == null) {
      throw Exception('Missing access token');
    }

    final uri = Uri.parse(
      '$baseUrl/api/user/expenses/group',
    ).replace(queryParameters: {'period': period});

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

    final List<dynamic> jsonList = jsonDecode(response.body);

    return jsonList.map((e) => ChartPoint.fromJson(e)).toList();
  }

  static Future<List<Expense>> getCurrentMonthExpenses() async {
    final accessToken = await StorageService.getAccessToken();

    if (accessToken == null) {
      throw Exception('Missing access token');
    }

    final year = DateTime.now().year.toString();
    final month = DateTime.now().month.toString();

    final uri = Uri.parse(
      '$baseUrl/api/user/expenses/monthly',
    ).replace(queryParameters: {'year': year, 'month': month});

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

    return jsonList.map((json) => Expense.fromJson(json)).toList();
  }
}
