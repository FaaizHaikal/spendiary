import 'package:flutter/material.dart';
import 'package:spendiary/core/models/expense.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';
import 'package:spendiary/features/dashboard/logic/expenses_controller.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/expenses_chart.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/expenses_recent.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/toggle_periods.dart';

class ExpensesContent extends StatefulWidget {
  const ExpensesContent({super.key});

  @override
  State<ExpensesContent> createState() => _ExpensesContentState();
}

class _ExpensesContentState extends State<ExpensesContent> {
  final List<String> _periodOptions = ['Day', 'Week', 'Month', 'Year'];
  int _selectedIndex = 2;

  late List<ChartPoint> _chartData;
  late List<Expense> _recentExpenses;
  bool _isRecentExpensesLoading = true;
  bool _isChartLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecentExpenses();
    _fetchExpensesChart();
  }

  Future<void> _fetchRecentExpenses() async {
    try {
      setState(() {
        _isRecentExpensesLoading = true;
      });

      final data = await ExpensesController.getRecentExpenses(3);

      if (mounted) {
        setState(() {
          _recentExpenses = data;
          _isRecentExpensesLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _recentExpenses = [];
        _isRecentExpensesLoading = false;
      });
      debugPrint('Error fetching recent expenses: $e');
    }
  }

  Future<void> _fetchExpensesChart() async {
    final period = _periodOptions[_selectedIndex];
    try {
      setState(() {
        _isChartLoading = true;
      });

      final data = await ExpensesController.getExpensesByPeriod(
        period.toLowerCase(),
      );

      if (mounted) {
        setState(() {
          _chartData = data;
          _isChartLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _chartData = [];
          _isChartLoading = false;
        });
      }
      debugPrint('Error refreshing $period data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TogglePeriods(
          options: _periodOptions,
          selectedIndex: _selectedIndex,
          onSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
            // Refresh data when period changes
            _fetchExpensesChart();
          },
        ),
        const SizedBox(height: 20),

        // Expenses Chart
        _isChartLoading
            ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
            : _chartData.isEmpty
            ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available'),
                  ),
                  ElevatedButton(
                    onPressed: _fetchExpensesChart,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
              onRefresh: _fetchExpensesChart,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ExpensesChart(data: _chartData),
              ),
            ),

        _isRecentExpensesLoading
            ? const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(),
              ),
            )
            : _recentExpenses.isEmpty
            ? Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text('No data available'),
                  ),
                  ElevatedButton(
                    onPressed: _fetchRecentExpenses,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
            : RefreshIndicator(
              onRefresh: _fetchExpensesChart,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ExpensesRecent(data: _recentExpenses),
              ),
            ),
      ],
    );
  }
}
