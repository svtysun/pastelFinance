import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../utils/shared_preferences_helper.dart';

class SpendingReportScreen extends StatefulWidget {
  const SpendingReportScreen({super.key});

  @override
  State<SpendingReportScreen> createState() => _SpendingReportScreenState();
}

class _SpendingReportScreenState extends State<SpendingReportScreen> {
  List<Transaction> _transactions = [];
  double _totalSpending = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    final allTransactions = await SharedPreferencesHelper.getTransactions();
    final spendingTransactions = allTransactions
        .where((tx) => tx.amount < 0 && tx.description == 'Pengeluaran') // ✅ FIXED
        .toList();

    final total = spendingTransactions.fold<double>(0.0, (sum, tx) => sum + tx.amount);

    setState(() {
      _transactions = spendingTransactions;
      _totalSpending = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Pengeluaran'),
        backgroundColor: const Color.fromARGB(255, 210, 130, 248),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _transactions.isEmpty
            ? const Center(
                child: Text('Tidak ada data pengeluaran.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pengeluaran: Rp ${_totalSpending.abs().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rincian Transaksi:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      shrinkWrap: true,
                      itemCount: _transactions.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final tx = _transactions[index];
                        return ListTile(
                          title: Text('Rp ${tx.amount.abs().toStringAsFixed(2)}'),
                          subtitle: Text('Tanggal: ${dateFormatter.format(tx.date)}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
