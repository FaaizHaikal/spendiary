import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spendiary/core/models/expense.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/core/utils.dart';

class ExpensesRecent extends StatelessWidget {
  final List<Expense> data;

  const ExpensesRecent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseScreen()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'See All >',
                  style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.25, // Adjust as needed
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children:
                  data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final expense = entry.value;
                    final isOdd = index.isOdd;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Date/Time and Description
                          Row(
                            children: [
                              // Date Circle
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color:
                                      isOdd
                                          ? AppColors.primaryAccent
                                          : AppColors.secondary,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          height: 1.1,
                                        ),
                                        expense.date.day.toString(),
                                      ),
                                      Text(
                                        _getMonthAbbreviation(
                                          expense.date.month,
                                        ),
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Description and Time
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      height: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    style: TextStyle(fontSize: 12, height: 0.9),
                                    '${expense.date.hour.toString().padLeft(2, '0')}:${expense.date.minute.toString().padLeft(2, '0')}',
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Amount
                          Text(
                            '-${(expense.amount).toIDR()}',
                            style: const TextStyle(
                              color: AppColors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
