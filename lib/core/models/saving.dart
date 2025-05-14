import 'package:spendiary/core/models/transaction.dart';

class Saving extends Transaction {
  final DateTime date;
  final String description;
  final double amount;

  Saving({required this.date, required this.description, required this.amount});

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      date: DateTime.parse(json['Date']),
      description: json['Description'],
      amount: (json['Amount'] as num).toDouble(),
    );
  }
}
