import 'package:flutter/material.dart';
import 'package:spendiary/core/theme/app_colors.dart';

class ToggleContent extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const ToggleContent({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.secondary,
                borderRadius: BorderRadius.circular(5.0), // All corners rounded
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 36.0,
                vertical: 10.0,
              ),
              child: Text(
                options[index],
                style: TextStyle(color: AppColors.textPrimary, fontSize: 10.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}
