import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/data/savings_service.dart';
import 'package:spendiary/features/dashboard/logic/savings_state.dart';

class SavingsController extends StateNotifier<SavingsState> {
  SavingsController() : super(SavingsState.initial()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    state = state.copyWith(isChartLoading: true);

    await fetchSavingsTotal();
    await fetchCurrentYearSavingsTotal();

    state = state.copyWith(isChartLoading: false);

    await fetchRecentSavings();
  }

  Future<void> fetchSavingsTotal() async {
    try {
      final total = await SavingsService.getSavingsTotal();

      state = state.copyWith(savingsTotal: total);
    } catch (e) {
      state = state.copyWith(savingsTotal: 0);
    }
  }

  Future<void> fetchCurrentYearSavingsTotal() async {
    try {
      final total = await SavingsService.getCurrentYearSavingsTotal();

      state = state.copyWith(currentYearSavingsTotal: total);
    } catch (e) {
      state = state.copyWith(currentYearSavingsTotal: 0);
    }
  }

  Future<void> fetchRecentSavings({int count = 3}) async {
    try {
      final recentSavings = await SavingsService.getRecentSavings(count);

      state = state.copyWith(recentSavings: recentSavings);
    } catch (e) {
      state = state.copyWith(recentSavings: []);
    }
  }
}
