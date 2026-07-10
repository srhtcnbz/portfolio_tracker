import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../models/budget_entry.dart';

/// Aylık Bütçe, Tasarruf Oranı ve Gelir/Gider listelerini gösteren sekme.
class BudgetTab extends StatelessWidget {
  const BudgetTab({super.key});

  void _showAddBudgetDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Ev/Yaşam';
    bool isIncome = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('BÜTÇE KALEMİ EKLE', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<bool>(
                value: isIncome,
                decoration: const InputDecoration(labelText: 'Tür'),
                items: const [
                  DropdownMenuItem(value: false, child: Text('Gider')),
                  DropdownMenuItem(value: true, child: Text('Gelir')),
                ],
                onChanged: (val) {
                  if (val != null) isIncome = val;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Açıklama (Örn: Kira, Fatura)'),
                validator: (val) => (val == null || val.trim().isEmpty) ? 'Gerekli' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Tutar (₺)'),
                validator: (val) => (val == null || double.tryParse(val.replaceAll(',', '.')) == null)
                    ? 'Geçerli bir tutar girin'
                    : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Kategori / Grup'),
                items: const [
                  DropdownMenuItem(value: 'Cansu', child: Text('Cansu (Çocuk)')),
                  DropdownMenuItem(value: 'Serhat', child: Text('Serhat (Kişisel/Araç)')),
                  DropdownMenuItem(value: 'Çiğdem', child: Text('Çiğdem (Kişisel)')),
                  DropdownMenuItem(value: 'Ev/Kira', child: Text('Ev / Kira')),
                  DropdownMenuItem(value: 'Altyapı/Fatura', child: Text('Altyapı & Faturalar')),
                ],
                onChanged: (val) {
                  if (val != null) category = val;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İPTAL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF111827)),
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                final amt = double.tryParse(amountController.text.replaceAll(',', '.')) ?? 0.0;
                final entry = BudgetEntry(
                  id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                  category: category,
                  title: titleController.text.trim(),
                  amount: amt,
                  isIncome: isIncome,
                );
                Provider.of<PortfolioService>(context, listen: false).addBudgetEntry(entry);
                Navigator.of(context).pop();
              }
            },
            child: const Text('KAYDET', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tlFormatter = NumberFormat.currency(symbol: '₺', decimalDigits: 2, locale: 'tr_TR');
    final service = Provider.of<PortfolioService>(context);

    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
        children: [
          // Tasarruf Oranı ve Genel Durum Özeti (Minimalist Premium Gösterge)
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 16, offset: Offset(0, 6))],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TASARRUF ORANI',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF6B7280),
                            letterSpacing: 1.1,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Aylık Nakit Akışı',
                          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                    // Tasarruf Yüzdesi Rozeti
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '%${service.savingsRate.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Tasarruf Barı
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    children: [
                      Container(height: 10, color: const Color(0xFFF3F4F6)),
                      FractionallySizedBox(
                        widthFactor: (service.savingsRate / 100).clamp(0.0, 1.0),
                        child: Container(height: 10, color: const Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Bütçe Bilgi Kartları
                Row(
                  children: [
                    _buildSummaryCard(
                      label: 'AYLIK GELİR',
                      amount: service.totalMonthlyIncome,
                      formatter: tlFormatter,
                      color: const Color(0xFF16A34A),
                    ),
                    const SizedBox(width: 12),
                    _buildSummaryCard(
                      label: 'AYLIK GIDER',
                      amount: service.totalMonthlyExpense,
                      formatter: tlFormatter,
                      color: const Color(0xFFDC2626),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'NET BİRİKİM / SAVINGS',
                        style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
                      ),
                      Text(
                        tlFormatter.format(service.netMonthlySavings),
                        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Gelir Kalemleri Başlığı
          _buildSectionHeader(context, 'AYLIK GELİRLER', () => _showAddBudgetDialog(context)),
          const SizedBox(height: 10),

          // Gelir Listesi
          ...service.incomes.map((entry) => _buildEntryTile(context, entry, tlFormatter)),

          const SizedBox(height: 24),
          // Gider Kalemleri Başlığı
          _buildSectionHeader(context, 'AYLIK GİDERLER', () => _showAddBudgetDialog(context)),
          const SizedBox(height: 10),

          // Gider Listesi
          ...service.expenses.map((entry) => _buildEntryTile(context, entry, tlFormatter)),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required double amount,
    required NumberFormat formatter,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 6),
            Text(
              formatter.format(amount),
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B7280),
            letterSpacing: 1.1,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 18.0, color: Color(0xFF111827)),
          onPressed: onAdd,
        ),
      ],
    );
  }

  Widget _buildEntryTile(BuildContext context, BudgetEntry entry, NumberFormat formatter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  entry.category.toUpperCase(),
                  style: const TextStyle(fontSize: 9.0, fontWeight: FontWeight.w700, color: Color(0xFF4B5563)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                entry.title,
                style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                formatter.format(entry.amount),
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w700,
                  color: entry.isIncome ? const Color(0xFF16A34A) : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFF9CA3AF)),
                onPressed: () {
                  Provider.of<PortfolioService>(context, listen: false).deleteBudgetEntry(entry.id, entry.isIncome);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
