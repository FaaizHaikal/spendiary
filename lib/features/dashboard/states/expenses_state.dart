import 'package:spendiary/core/models/expense.dart';
import 'package:spendiary/features/dashboard/models/chart_point.dart';

class ExpensesState {
  final Map<String, List<ChartPoint>> allChartData;
  final List<Expense> recentExpenses;
  final int selectedPeriodIndex;
  final bool isChartLoading;
  final bool isRecentLoading;

  static const periods = ['Day', 'Week', 'Month', 'Year'];

  ExpensesState({
    required this.allChartData,
    required this.recentExpenses,
    required this.selectedPeriodIndex,
    required this.isChartLoading,
    required this.isRecentLoading,
  });

  factory ExpensesState.initial() => ExpensesState(
    allChartData: {},
    recentExpenses: [],
    selectedPeriodIndex: 2,
    isChartLoading: false,
    isRecentLoading: false,
  );

  String get currentPeriod => periods[selectedPeriodIndex];

  List<ChartPoint> get currentChartData => allChartData[currentPeriod] ?? [];

  double get total =>
      currentChartData.fold(0.0, (sum, item) => sum + item.total);

  ExpensesState copyWith({
    Map<String, List<ChartPoint>>? allChartData,
    List<Expense>? recentExpenses,
    int? selectedPeriodIndex,
    bool? isChartLoading,
    bool? isRecentLoading,
  }) {
    return ExpensesState(
      allChartData: allChartData ?? this.allChartData,
      recentExpenses: recentExpenses ?? this.recentExpenses,
      selectedPeriodIndex: selectedPeriodIndex ?? this.selectedPeriodIndex,
      isChartLoading: isChartLoading ?? this.isChartLoading,
      isRecentLoading: isRecentLoading ?? this.isRecentLoading,
    );
  }
}
