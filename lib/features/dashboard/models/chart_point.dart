class ChartPoint {
  final String label;
  final double total;

  ChartPoint({required this.label, required this.total});

  factory ChartPoint.fromJson(Map<String, dynamic> json) {
    return ChartPoint(
      label: json['label'],
      total: (json['total'] as num).toDouble(),
    );
  }
}
