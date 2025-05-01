import 'package:spendiary/core/models/expense.dart';
import 'package:spendiary/features/dashboard/data/expenses_service.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';

class ExpensesController {
  static Future<List<ChartPoint>> getExpensesByPeriod(String period) async {
    try {
      return await ExpenseService.getExpensesByPeriod(period);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Expense>> getRecentExpenses(int count) async {
    try {
      return await ExpenseService.getRecentExpenses(count);
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Expense>> getCurrentMonthExpenses() async {
    try {
      return await ExpenseService.getCurrentMonthExpenses();
    } catch (e) {
      rethrow;
    }
  }
}
