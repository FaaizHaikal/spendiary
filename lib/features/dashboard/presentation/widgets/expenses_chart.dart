import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/core/utils.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';

class ExpensesChart extends StatefulWidget {
  final List<ChartPoint> data;

  const ExpensesChart({super.key, required this.data});

  @override
  State<ExpensesChart> createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> {
  late final TransformationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();
    _controller.value *= Matrix4.identity();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(double num) {
    if (num >= 1000000) return '${(num / 1000000).toStringAsFixed(1)}M';
    if (num >= 1000) return '${(num / 1000).toStringAsFixed(1)}K';
    return num.toInt().toString();
  }

  double _calculateRoundedMaxY(double maxValue, double interval) =>
      (maxValue / interval).ceil() * interval;

  double _calculateYInterval(double maxY) {
    if (maxY <= 5000) return 1000;
    if (maxY <= 50000) return 10000;
    if (maxY <= 100000) return 20000;
    if (maxY <= 500000) return 100000;
    return 500000;
  }

  void initializeZoom(double chartWidth, double screenWidth) {
    if (screenWidth > chartWidth) {
      _controller.value = Matrix4.identity();

      return;
    }

    final ratio = (chartWidth - screenWidth) / screenWidth + 1;

    final currentPan = _controller.value.getTranslation().x;

    double clampedPan = currentPan.clamp(-50.0, 0.0);

    _controller.value = Matrix4.diagonal3Values(ratio, ratio, 1)
      ..translate(clampedPan);
  }

  @override
  Widget build(BuildContext context) {
    final rawMaxY = widget.data
        .map((e) => e.total)
        .reduce((a, b) => a > b ? a : b);
    final yInterval = _calculateYInterval(rawMaxY);
    final maxY = _calculateRoundedMaxY(rawMaxY, yInterval);

    final pointSpacing = 40.0;
    final chartWidth = widget.data.length * pointSpacing;
    final screenWidth = MediaQuery.of(context).size.width;
    final panEnabled = chartWidth > screenWidth;

    initializeZoom(chartWidth, screenWidth);

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(right: 28, left: 2.5, bottom: 10),
        child: SizedBox(
          width: max(chartWidth, 300.0),
          child: LineChart(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.fastEaseInToSlowEaseOut,
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      if (value >= 0 &&
                          value < widget.data.length &&
                          value == value.toInt()) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.data[value.toInt()].label,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }
                      return const Text('');
                    },
                    reservedSize: 20,
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: yInterval, // Use calculated interval
                    getTitlesWidget: (value, meta) {
                      return Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 4.0, top: 8.0),
                        child: Text(
                          _formatNumber(value),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                    reservedSize: 45,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  bottom: BorderSide(color: AppColors.primary, width: 2),
                  left: BorderSide(color: AppColors.primary, width: 2),
                  top: BorderSide.none,
                  right: BorderSide.none,
                ),
              ),
              minX: 0,
              maxX: (widget.data.length - 1).toDouble(),
              minY: 0,
              maxY: maxY, // Use rounded maxY
              lineBarsData: [
                LineChartBarData(
                  spots:
                      widget.data
                          .asMap()
                          .entries
                          .map(
                            (entry) =>
                                FlSpot(entry.key.toDouble(), entry.value.total),
                          )
                          .toList(),
                  isCurved: true,
                  color: AppColors.primaryAccent,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryAccent.withValues(alpha: 0.3),
                        AppColors.primaryAccent.withValues(alpha: 0.1),
                        AppColors.primaryAccent.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipColor: (touchedSpot) => AppColors.primary,
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((spot) {
                      final value = spot.y;
                      final formattedValue = value.toIDR();
                      return LineTooltipItem(
                        formattedValue,
                        const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
            transformationConfig: FlTransformationConfig(
              scaleAxis: FlScaleAxis.horizontal,
              panEnabled: panEnabled,
              scaleEnabled: true,
              minScale: 1.0,
              maxScale: 10.0,
              transformationController: _controller,
            ),
          ),
        ),
      ),
    );
  }
}
