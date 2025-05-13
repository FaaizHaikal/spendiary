import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendiary/core/utils.dart';
import 'package:spendiary/features/dashboard/logic/expenses_provider.dart';
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
            // Move Consumer only around the parts that need provider data
            Consumer(
              builder: (context, ref, _) {
                final total = ref.watch(
                  expensesControllerProvider.select((state) => state.total)
                );

                return Column(
                  children: [
                    _selectedIndex == 0
                        ? const Text('Total Expenses', style: TextStyle(fontSize: 16))
                        : const Text('Total Savings', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      total.toIDR(decimalDigits: 0),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            ToggleContent(
              options: const ['Expenses', 'Savings'],
              selectedIndex: _selectedIndex,
              onSelected: (index) => setState(() => _selectedIndex = index),
            ),
            const SizedBox(height: 20),
            if (_selectedIndex == 0) 
              const ExpensesContent() 
            else 
              const Text('Savings'),
          ],
        ),
      ),
    );
  }
}
