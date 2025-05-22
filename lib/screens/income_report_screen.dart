import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../utils/shared_preferences_helper.dart';

class IncomeReportScreen extends StatefulWidget {
  const IncomeReportScreen({super.key});

  @override
  State<IncomeReportScreen> createState() => _IncomeReportScreenState();
}

class _IncomeReportScreenState extends State<IncomeReportScreen> {
  List<Transaction> _transactions = [];
  double _totalIncome = 0.0;

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }

  Future<void> _loadReportData() async {
    final allTransactions = await SharedPreferencesHelper.getTransactions();
    final incomeTransactions = allTransactions
        .where((tx) => tx.amount > 0 && tx.description == 'Pemasukan')
        .toList();

    final total = incomeTransactions.fold<double>(0.0, (sum, tx) => sum + tx.amount);

    setState(() {
      _transactions = incomeTransactions;
      _totalIncome = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 210, 130, 248),
        foregroundColor: Colors.white,
        automaticallyImplyLeading: true, // ✅ Hilangkan ikon back
        title: const Text('Laporan Pemasukan'),
        // ❌ Tidak perlu atur background/foreground color agar default
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _transactions.isEmpty
            ? const Center(
                child: Text('Tidak ada data pemasukan.'),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pemasukan: Rp ${_totalIncome.toStringAsFixed(2)}',
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
                          title: Text('Rp ${tx.amount.toStringAsFixed(2)}'),
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
