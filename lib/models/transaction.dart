import 'dart:convert'; 
class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  static String encode(List<Transaction> transactions) => json.encode(
        transactions.map((tx) => tx.toJson()).toList(),
      );

  static List<Transaction> decode(String transactionsJson) =>
      (json.decode(transactionsJson) as List<dynamic>)
          .map<Transaction>((item) => Transaction.fromJson(item))
          .toList();
}
