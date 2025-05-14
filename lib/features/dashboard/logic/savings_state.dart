import 'package:spendiary/core/models/saving.dart';

class SavingsState {
  final List<Saving> recentSavings;
  final double savingsTotal;
  final double currentYearSavingsTotal;
  final bool isChartLoading;
  final bool isRecentLoading;

  SavingsState({
    required this.recentSavings,
    required this.savingsTotal,
    required this.currentYearSavingsTotal,
    required this.isChartLoading,
    required this.isRecentLoading,
  });

  factory SavingsState.initial() => SavingsState(
    recentSavings: [],
    savingsTotal: 0,
    currentYearSavingsTotal: 0,
    isChartLoading: false,
    isRecentLoading: false,
  );


  SavingsState copyWith({
    List<Saving>? recentSavings,
    double? savingsTotal,
    double? currentYearSavingsTotal,
    bool? isChartLoading,
    bool? isRecentLoading,
  }) {
    return SavingsState(
      recentSavings: recentSavings ?? this.recentSavings,
      savingsTotal: savingsTotal ?? this.savingsTotal,
      currentYearSavingsTotal: currentYearSavingsTotal ?? this.currentYearSavingsTotal,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      isRecentLoading: isRecentLoading ?? this.isRecentLoading,
    );
  }
}
