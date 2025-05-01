class Saving {
  final DateTime date;
  final double amount;

  Saving({required this.date, required this.amount});

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      date: DateTime.parse(json['Date']),
      amount: (json['Amount'] as num).toDouble(),
    );
  }
}
