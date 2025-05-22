import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_transaction_screen.dart';
import '../models/transaction.dart';
import '../utils/shared_preferences_helper.dart';
import 'income_report_screen.dart'; // ✅ Tambahkan import

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  List<Transaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final all = await SharedPreferencesHelper.getTransactions();
    setState(() {
      _transactions = all
          .where((tx) => tx.amount > 0 && tx.description == 'Pemasukan')
          .toList();
    });
  }

  Future<void> _addTransaction() async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
    );

    if (result != null &&
        result.amount > 0 &&
        result.description == 'Pemasukan') {
      await SharedPreferencesHelper.addTransaction(result);
      _loadTransactions();
    }
  }

  Future<void> _editTransaction(int index) async {
    final result = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddTransactionScreen(transaction: _transactions[index]),
      ),
    );

    if (result != null &&
        result.amount > 0 &&
        result.description == 'Pemasukan') {
      await SharedPreferencesHelper.updateTransaction(result);
      _loadTransactions();
    }
  }

  Future<void> _deleteTransaction(String id) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi'),
          content: const Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmDelete ?? false) {
      await SharedPreferencesHelper.deleteTransaction(id);
      _loadTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IncomeReportScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF0FFF0),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _transactions.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada pemasukan.\nTekan tombol + untuk menambahkan.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.separated(
                itemCount: _transactions.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final tx = _transactions[index];
                  return ListTile(
                    title: Text(tx.description),
                    subtitle: Text(
                      'Rp ${tx.amount.toStringAsFixed(2)}\nTanggal: ${dateFormatter.format(tx.date)}',
                    ),
                    isThreeLine: true,
                    onTap: () => _editTransaction(index),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTransaction(tx.id),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 210, 130, 248),
        onPressed: _addTransaction,
        child: const Icon(Icons.add),
      ),
    );
  }
}
