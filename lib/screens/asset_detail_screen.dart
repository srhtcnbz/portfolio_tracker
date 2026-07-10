import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/portfolio_asset.dart';
import '../services/portfolio_service.dart';
import '../widgets/add_transaction_modal.dart';

/// Belirli bir varlığın detay ekranı.
/// Performans grafiğini ve o varlığa ait işlem geçmişini gösterir.
class AssetDetailScreen extends StatelessWidget {
  final PortfolioAsset asset;

  const AssetDetailScreen({super.key, required this.asset});

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => AddTransactionModal(initialAssetCode: asset.assetCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tlFormatter = NumberFormat.currency(
      symbol: '₺',
      decimalDigits: 2,
      locale: 'tr_TR',
    );
    final isProfit = asset.isProfitable;
    final badgeColor = isProfit ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF111827)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          asset.assetCode,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF111827)),
            onPressed: () => _showAddModal(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<PortfolioService>(
        builder: (context, portfolioService, child) {
          final transactions = portfolioService.transactions
              .where((t) => t.assetCode.toUpperCase() == asset.assetCode.toUpperCase())
              .toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Üst Detay Kartı & Fiyat Bilgisi
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.name,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF6B7280),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            tlFormatter.format(asset.currentPrice),
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            decoration: BoxDecoration(
                              color: badgeColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isProfit ? Icons.trending_up : Icons.trending_down,
                                  size: 16.0,
                                  color: badgeColor,
                                ),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${isProfit ? '+' : ''}%${asset.dailyChangePercent.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: badgeColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),

                      // Simüle Performans Grafiği Kutusu
                      Container(
                        height: 160.0,
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'FİYAT PERFORMANSI (1Y)',
                                  style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF6B7280),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  tlFormatter.format(asset.totalValue),
                                  style: const TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                            // Simüle Mini Grafik Görseli (Minimalist Bar/Line İllüstrasyonu)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _chartBar(height: 35, color: badgeColor.withOpacity(0.3)),
                                _chartBar(height: 50, color: badgeColor.withOpacity(0.4)),
                                _chartBar(height: 45, color: badgeColor.withOpacity(0.5)),
                                _chartBar(height: 65, color: badgeColor.withOpacity(0.6)),
                                _chartBar(height: 55, color: badgeColor.withOpacity(0.7)),
                                _chartBar(height: 75, color: badgeColor.withOpacity(0.85)),
                                _chartBar(height: 90, color: badgeColor),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // İşlem Geçmişi Başlığı
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'İŞLEM GEÇMİŞİ',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '${transactions.length} İŞLEM',
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // İşlem Listesi
              if (transactions.isEmpty)
                const SliverPadding(
                  padding: EdgeInsets.all(32.0),
                  sliver: SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Bu varlık için henüz kayıtlı işlem bulunmuyor.',
                        style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13.0),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 36.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tx = transactions[index];
                        final isBuy = tx.isBuy;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 38.0,
                                    height: 38.0,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isBuy
                                          ? const Color(0xFF16A34A).withOpacity(0.1)
                                          : const Color(0xFFDC2626).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Icon(
                                      isBuy ? Icons.add : Icons.remove,
                                      size: 18.0,
                                      color: isBuy ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                    ),
                                  ),
                                  const SizedBox(width: 12.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isBuy ? 'Alış İşlemi' : 'Satış İşlemi',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Text(
                                        DateFormat('dd.MM.yyyy').format(tx.date),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Color(0xFF9CA3AF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    tlFormatter.format(tx.totalValue),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),
                                  Text(
                                    '${tx.quantity} adet @ ${tlFormatter.format(tx.price)}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: transactions.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'İşlem Ekle',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () => _showAddModal(context),
      ),
    );
  }

  Widget _chartBar({required double height, required Color color}) {
    return Container(
      width: 22,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
