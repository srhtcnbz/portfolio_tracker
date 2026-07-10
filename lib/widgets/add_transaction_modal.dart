import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/transaction_record.dart';
import '../services/portfolio_service.dart';

/// Yeni işlem ekleme (Alış/Satış) alt penceresi (Modal Bottom Sheet).
class AddTransactionModal extends StatefulWidget {
  final String? initialAssetCode;

  const AddTransactionModal({
    super.key,
    this.initialAssetCode,
  });

  @override
  State<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends State<AddTransactionModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _assetCodeController;
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String _transactionType = 'BUY'; // 'BUY' veya 'SELL'

  @override
  void initState() {
    super.initState();
    _assetCodeController = TextEditingController(text: widget.initialAssetCode ?? '');
  }

  @override
  void dispose() {
    _assetCodeController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final quantity = double.tryParse(_quantityController.text.replaceAll(',', '.')) ?? 0.0;
      final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;

      final record = TransactionRecord(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        date: DateTime.now(),
        assetCode: _assetCodeController.text.trim().toUpperCase(),
        transactionType: _transactionType,
        quantity: quantity,
        price: price,
      );

      Provider.of<PortfolioService>(context, listen: false).addTransaction(record);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${record.assetCode} için ${_transactionType == 'BUY' ? 'Alış' : 'Satış'} işlemi kaydedildi.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF111827),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, bottomInset + 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'YENİ İŞLEM EKLE',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Alış / Satış Seçimi
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    label: 'Alış (BUY)',
                    type: 'BUY',
                    color: const Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: _buildTypeButton(
                    label: 'Satış (SELL)',
                    type: 'SELL',
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Sembol Alanı
            TextFormField(
              controller: _assetCodeController,
              decoration: InputDecoration(
                labelText: 'Varlık Sembolü (Örn: VOO, THYAO)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              validator: (val) => (val == null || val.trim().isEmpty) ? 'Sembol giriniz' : null,
            ),
            const SizedBox(height: 14.0),

            // Adet & Fiyat Alanları
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Adet / Miktar',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    ),
                    validator: (val) => (val == null || double.tryParse(val.replaceAll(',', '.')) == null)
                        ? 'Geçerli sayı'
                        : null,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Birim Fiyat (₺)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                    ),
                    validator: (val) => (val == null || double.tryParse(val.replaceAll(',', '.')) == null)
                        ? 'Geçerli fiyat'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            // Kaydet Butonu
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111827),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                ),
                onPressed: _submit,
                child: const Text(
                  'İŞLEMİ KAYDET',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String label,
    required String type,
    required Color color,
  }) {
    final isSelected = _transactionType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _transactionType = type;
        });
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            color: isSelected ? color : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}
