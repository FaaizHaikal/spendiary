import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;

  const ChartContainer({
    required this.height,
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(right: 28, left: 2.5, bottom: 10),
        child: SizedBox(width: width, child: child),
      ),
    );
  }
}
