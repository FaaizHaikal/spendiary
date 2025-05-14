import 'package:flutter/material.dart';
import 'package:spendiary/core/theme/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final EdgeInsetsGeometry padding;
  final bool isLoading;

  const AuthButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = AppColors.primaryAccent,
    this.isLoading = false,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
              if (isLoading || states.contains(WidgetState.disabled)) {
                return AppColors.primaryAccent.withValues(alpha: 0.5);
              }

              if (states.contains(WidgetState.hovered)) {
                return AppColors.primaryAccent.withValues(alpha: 0.8);
              }

              return color;
            }),
            padding: WidgetStateProperty.all(padding),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          child:
              isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                    ),
                  ),
        ),
      ),
    );
  }
}
