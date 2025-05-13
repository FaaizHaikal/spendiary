import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/data/expenses_service.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';
import 'package:spendiary/features/dashboard/logic/expenses_state.dart';

class ExpensesController extends StateNotifier<ExpensesState> {
  ExpensesController() : super(ExpensesState.initial()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    for (int index = 0; index < ExpensesState.periods.length; index++) {
      await fetchPeriodChart(index: index); // Pass index directly
    }

    await fetchRecentExpenses();
  }

  Future<void> fetchPeriodChart({int? index}) async {
    final effectiveIndex = index ?? state.selectedPeriodIndex;
    final String period = ExpensesState.periods[effectiveIndex];

    if (state.allChartData.containsKey(period)) {
      return;
    }

    state = state.copyWith(isChartLoading: true);
    final data = await ExpenseService.getExpensesByPeriod(period.toLowerCase());
    final updatedData = Map<String, List<ChartPoint>>.from(state.allChartData)
      ..[period] = data;
    state = state.copyWith(allChartData: updatedData, isChartLoading: false);
  }

  Future<void> fetchRecentExpenses({int count = 3}) async {
    state = state.copyWith(isRecentLoading: true);

    try {
      final recent = await ExpenseService.getRecentExpenses(count);
      state = state.copyWith(recentExpenses: recent, isRecentLoading: false);
    } catch (e) {
      state = state.copyWith(isRecentLoading: false);
    }
  }

  void updatePeriod(int index) {
    state = state.copyWith(selectedPeriodIndex: index);
  }
}
