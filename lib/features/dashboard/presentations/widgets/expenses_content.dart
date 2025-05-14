import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/providers/expenses_provider.dart';
import 'package:spendiary/features/dashboard/presentations/widgets/expenses_chart.dart';
import 'package:spendiary/features/dashboard/presentations/widgets/recent_transaction.dart';
import 'package:spendiary/features/dashboard/presentations/widgets/toggle_periods.dart';

class ExpensesContent extends ConsumerWidget {
  const ExpensesContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(expensesControllerProvider);
    final controller = ref.read(expensesControllerProvider.notifier);

    const periodOptions = ['Day', 'Week', 'Month', 'Year'];

    return Column(
      children: [
        TogglePeriods(
          options: periodOptions,
          selectedIndex: state.selectedPeriodIndex,
          onSelected: controller.updatePeriod,
        ),
        const SizedBox(height: 20),

        // Expenses Chart
        state.isChartLoading
            ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
            : state.currentChartData.isEmpty
            ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available'),
                  ),
                  ElevatedButton(
                    onPressed: controller.fetchPeriodChart,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
              onRefresh: controller.fetchPeriodChart,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ExpensesChart(data: state.currentChartData),
              ),
            ),

        state.isRecentLoading
            ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
            : state.recentExpenses.isEmpty
            ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available'),
                  ),
                  ElevatedButton(
                    onPressed: controller.fetchRecentExpenses,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
              onRefresh: controller.fetchRecentExpenses,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RecentTransaction(
                  data: state.recentExpenses,
                  isExpense: true,
                ),
              ),
            ),
      ],
    );
  }
}
