import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/core/utils.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';
import 'package:spendiary/features/dashboard/presentation/widgets/chart_container.dart';

class ExpensesChart extends StatefulWidget {
  final List<ChartPoint> data;

  const ExpensesChart({super.key, required this.data});

  @override
  State<ExpensesChart> createState() => _ExpensesChartState();
}

class _ExpensesChartState extends State<ExpensesChart> {
  late final TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initializeChartZoom();

    return ChartContainer(
      height: 250,
      width: _calculateChartWidth(),
      child: LineChart(
        _buildLineChartData(),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastEaseInToSlowEaseOut,
        transformationConfig: _getTransformationConfig(),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    final rawMaxY = widget.data
        .map((e) => e.total)
        .reduce((a, b) => a > b ? a : b);
    final yInterval = _calculateYInterval(rawMaxY);
    final maxY = _calculateRoundedMaxY(rawMaxY, yInterval);

    return LineChartData(
      gridData: const FlGridData(show: false),
      titlesData: _buildTitlesData(yInterval),
      borderData: _buildBorderData(),
      minX: 0,
      maxX: (widget.data.length - 1).toDouble(),
      minY: 0,
      maxY: maxY,
      lineBarsData: [_buildLineBarData()],
      lineTouchData: _buildTouchData(),
    );
  }

  FlTitlesData _buildTitlesData(double yInterval) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitlesWidget: _buildBottomTitle,
          reservedSize: 20,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: yInterval,
          getTitlesWidget: _buildLeftTitle,
          reservedSize: 45,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _buildBottomTitle(double value, TitleMeta meta) {
    if (value >= 0 && value < widget.data.length && value == value.toInt()) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          widget.data[value.toInt()].label,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      );
    }
    return const Text('');
  }

  Widget _buildLeftTitle(double value, TitleMeta meta) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 4.0, top: 8.0),
      child: Text(
        value.humanReadable(),
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: AppColors.primary, width: 2),
        left: BorderSide(color: AppColors.primary, width: 2),
        top: BorderSide.none,
        right: BorderSide.none,
      ),
    );
  }

  LineChartBarData _buildLineBarData() {
    return LineChartBarData(
      spots:
          widget.data
              .asMap()
              .entries
              .map((e) => FlSpot(e.key.toDouble(), e.value.total))
              .toList(),
      isCurved: true,
      color: AppColors.primaryAccent,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            AppColors.primaryAccent.withValues(alpha: 0.3),
            AppColors.primaryAccent.withValues(alpha: 0.1),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  LineTouchData _buildTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        getTooltipColor: (_) => AppColors.primary,
        getTooltipItems:
            (spots) =>
                spots
                    .map(
                      (spot) => LineTooltipItem(
                        spot.y.toIDR(),
                        const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                        ),
                      ),
                    )
                    .toList(),
      ),
    );
  }

  FlTransformationConfig _getTransformationConfig() {
    return FlTransformationConfig(
      scaleAxis: FlScaleAxis.horizontal,
      panEnabled: true,
      scaleEnabled: true,
      minScale: 1.0,
      maxScale: 10.0,
      transformationController: _transformationController,
    );
  }

  void _initializeChartZoom() {
    final screenWidth = MediaQuery.of(context).size.width;
    final dataWidth = _calculateDataWidth();

    if (screenWidth > dataWidth) {
      _transformationController.value = Matrix4.identity();

      return;
    }

    final ratio = (dataWidth - screenWidth) / screenWidth + 1;

    final currentPan = _transformationController.value.getTranslation().x;

    double clampedPan = currentPan.clamp(-50.0, 0.0);

    _transformationController.value = Matrix4.diagonal3Values(ratio, ratio, 1)
      ..translate(clampedPan);
  }

  double _calculateDataWidth() {
    const pointSpacing = 40.0;
    return widget.data.length * pointSpacing;
  }

  double _calculateChartWidth() {
    return max(_calculateDataWidth(), 300.0);
  }

  double _calculateYInterval(double maxY) {
    if (maxY <= 5000) return 1000;
    if (maxY <= 50000) return 10000;
    if (maxY <= 100000) return 20000;
    if (maxY <= 500000) return 100000;
    return 500000;
  }

  double _calculateRoundedMaxY(double maxValue, double interval) {
    return (maxValue / interval).ceil() * interval;
  }
}
