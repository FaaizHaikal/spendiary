import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/features/dashboard/providers/savings_provider.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/recent_transaction.dart';

class SavingsContent extends ConsumerWidget {
  const SavingsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savingsControllerProvider);
    final controller = ref.read(savingsControllerProvider.notifier);

    return Column(
      children: [
        // Expenses Chart
        state.isChartLoading
            ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
            : state.currentYearSavingsTotal <= 0
            ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available'),
                  ),
                  ElevatedButton(
                    onPressed: controller.fetchCurrentYearSavingsTotal,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
              onRefresh: controller.fetchCurrentYearSavingsTotal,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SavingsProgress(value: state.currentYearSavingsTotal),
              ),
            ),

        state.isRecentLoading
            ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
            : state.recentSavings.isEmpty
            ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available'),
                  ),
                  ElevatedButton(
                    onPressed: controller.fetchRecentSavings,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
              onRefresh: controller.fetchRecentSavings,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: RecentTransaction(
                  data: state.recentSavings,
                  isExpense: false,
                ),
              ),
            ),
      ],
    );
  }
}
