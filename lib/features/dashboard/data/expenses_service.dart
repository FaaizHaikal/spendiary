import 'dart:convert';
import 'package:spendiary/core/services/dio_client.dart';
import 'package:spendiary/core/models/expense.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';

class ExpenseService {
  static Future<List<ChartPoint>> getExpensesByPeriod(String period) async {
    final response = await DioClient.dio.get(
      '/api/user/expenses/group',
      queryParameters: {'period': period},
    );

    if (response.statusCode != 200) {
      final error =
          json.decode(response.data)['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return (response.data as List)
        .map((item) => ChartPoint.fromJson(item))
        .toList();
  }

  static Future<List<Expense>> getRecentExpenses(int count) async {
    final response = await DioClient.dio.get(
      '/api/user/expenses/recent',
      queryParameters: {'count': count},
    );

    if (response.statusCode != 200) {
      final error = response.data['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return (response.data as List)
        .map((item) => Expense.fromJson(item))
        .toList();
  }

  static Future<List<Expense>> getCurrentMonthExpenses() async {
    final month = DateTime.now().year.toString();
    final year = DateTime.now().year.toString();

    final response = await DioClient.dio.get(
      '/api/user/expenses/monthly',
      queryParameters: {'year': year, 'month': month},
    );

    if (response.statusCode != 200) {
      final error = response.data['error'] ?? 'Failed to fetch expenses';
      throw Exception(error);
    }

    return (response.data as List)
        .map((item) => Expense.fromJson(item))
        .toList();
  }
}
