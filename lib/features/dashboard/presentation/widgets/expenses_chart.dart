import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:spendiary/core/theme/app_colors.dart';
import 'package:spendiary/features/dashboard/data/models/chart_point.dart';

class ExpensesChart extends StatelessWidget {
  final List<ChartPoint> data;

  const ExpensesChart({super.key, required this.data});

  String _formatNumber(double num) {
    if (num >= 1000000) {
      return '${(num / 1000000).toStringAsFixed(1)}M';
    }
    if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final maxY = data.map((e) => e.total).reduce((a, b) => a > b ? a : b) * 1.1;

    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 &&
                            value < data.length &&
                            value == value.toInt()) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              data[value.toInt()].label,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                      reservedSize: 20, // Add reserved space for labels
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 4.0),
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
                    top: BorderSide.none, // Disable top border
                    right: BorderSide.none, // Disable right border
                  ),
                ),
                minX: 0,
                maxX: (data.length - 1).toDouble(),
                minY: 0,
                maxY: maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots:
                        data
                            .asMap()
                            .entries
                            .map(
                              (entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value.total,
                              ),
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
                          AppColors.primaryAccent.withValues(
                            alpha: 0.3,
                          ), // Top color (more visible)
                          AppColors.primaryAccent.withValues(
                            alpha: 0.1,
                          ), // Middle
                          AppColors.primaryAccent.withValues(
                            alpha: 0.0,
                          ), // Bottom (fully transparent)
                        ],
                        stops: [
                          0.0,
                          0.5,
                          1.0,
                        ], // Controls color transition points
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.primary,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final value = spot.y;
                        final formattedValue = NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp. ',
                          decimalDigits: 2,
                        ).format(value);

                        return LineTooltipItem(
                          formattedValue,
                          const TextStyle(color: AppColors.textPrimary),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
