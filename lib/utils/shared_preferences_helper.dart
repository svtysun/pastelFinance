import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';

class SharedPreferencesHelper {
  static const _keyTransactions = 'transactions';

  static Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyTransactions);
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> addTransaction(Transaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    transactions.add(transaction);
    final jsonList = transactions.map((tx) => tx.toJson()).toList();
    prefs.setString(_keyTransactions, json.encode(jsonList));
  }

  static Future<void> updateTransaction(Transaction updatedTx) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    final index = transactions.indexWhere((tx) => tx.id == updatedTx.id);
    if (index != -1) {
      transactions[index] = updatedTx;
      final jsonList = transactions.map((tx) => tx.toJson()).toList();
      prefs.setString(_keyTransactions, json.encode(jsonList));
    }
  }

  static Future<void> deleteTransaction(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = await getTransactions();
    transactions.removeWhere((tx) => tx.id == id);
    final jsonList = transactions.map((tx) => tx.toJson()).toList();
    prefs.setString(_keyTransactions, json.encode(jsonList));
  }
}
