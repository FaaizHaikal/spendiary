import 'package:flutter/material.dart';
import 'package:spendiary/core/theme/app_colors.dart';

class TogglePeriods extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const TogglePeriods({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(options.length, (index) {
        final isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Text(
              options[index],
              style: TextStyle(
                color:
                    isSelected
                        ? AppColors.primaryAccent
                        : AppColors.textPrimary,
                fontSize: 13.0,
              ),
            ),
          ),
        );
      }),
    );
  }
}
