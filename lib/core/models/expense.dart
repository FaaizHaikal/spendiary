class Expense {
  final DateTime date;
  final String description;
  final double amount;

  Expense({
    required this.date,
    required this.description,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      date: DateTime.parse(json['Date']),
      description: json['Description'],
      amount: (json['Amount'] as num).toDouble(),
    );
  }
}
