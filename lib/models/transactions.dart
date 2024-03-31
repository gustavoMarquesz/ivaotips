import 'dart:convert';

class Transaction {
  final String id;
  final String title;
  final double value;
  double valorTotalBanca;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.date,
    required this.valorTotalBanca,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'value': value,
      'date': date.toIso8601String(),
      'valorTotalBanca': valorTotalBanca,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      value: json['value'],
      date: DateTime.parse(json['date']),
      valorTotalBanca: json['valorTotalBanca'],
    );
  }
}
