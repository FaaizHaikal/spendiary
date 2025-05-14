import 'package:flutter/material.dart';
import 'package:spendiary/core/models/expense.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/core/utils.dart';

class RecentTransaction extends StatelessWidget {
  final List<Expense> data;
  final bool isExpense;

  const RecentTransaction({super.key, required this.data, required this.isExpense});

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
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => const Transaction()));
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
                MediaQuery.of(context).size.height * 0.25,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children:
                  data.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
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
                                        item.date.day.toString(),
                                      ),
                                      Text(
                                        item.date.month.monthAbbreviate(),
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
                                    item.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      height: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    style: TextStyle(fontSize: 12, height: 0.9),
                                    '${item.date.hour.toString().padLeft(2, '0')}:${item.date.minute.toString().padLeft(2, '0')}',
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Amount
                          isExpense ?
                          Text(
                            '-${(item.amount).toIDR()}',
                            style: const TextStyle(
                              color: AppColors.redAccent,
                              fontSize: 12,
                            ),
                          ) :
                          Text(
                            '+${(item.amount).toIDR()}',
                            style: const TextStyle(
                              color: AppColors.greenAccent,
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
}
