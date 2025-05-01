import 'package:flutter/material.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/expenses_content.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/toggle_content.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text('Total Expenses', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            const Text(
              'Rp. 1.000.000',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ToggleContent(
              options: const ['Expenses', 'Savings'],
              selectedIndex: _selectedIndex,
              onSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 20),
            if (_selectedIndex == 0) ...[
              ExpensesContent(),
            ] else ...[
              const Text('Savings'),
            ],
          ],
        ),
      ),
    );
  }
}
