import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../models/financial_projection.dart';

/// 30 yıllık compound interest büyüme projeksiyonu sekmesi.
class ProjectionTab extends StatelessWidget {
  const ProjectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tlFormatter = NumberFormat.currency(symbol: '₺', decimalDigits: 0, locale: 'tr_TR');
    final service = Provider.of<PortfolioService>(context);
    final projections = service.financialProjections;

    // Excel projeksiyonundaki getiri parametreleri özeti
    const double netAnnualGrowthRate = 9.8; // %9.8 net getiri
    final double yearlySavings = service.netMonthlySavings * 12;

    return Column(
      children: [
        // Parametreler Özet Kartı
        Container(
          margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
          padding: const EdgeInsets.all(18.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PROJEKSİYON PARAMETRELERİ',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildParamItem('Yıllık Büyüme', '%$netAnnualGrowthRate Net'),
                  _buildParamItem('Yıllık Ekleme', tlFormatter.format(yearlySavings)),
                  _buildParamItem('Çekim Kuralı', '%4 Kuralı'),
                ],
              ),
            ],
          ),
        ),

        // Başlık satırı
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '30 YILLIK BÜYÜME SİMÜLASYONU',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6B7280),
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '${projections.length} YIL',
                style: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),

        // Projeksiyon Tablosu (Sonsuz kaydırmalı liste)
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: DataTable(
                    columnSpacing: 22.0,
                    horizontalMargin: 16.0,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
                    headingHeight: 46.0,
                    dataRowMinHeight: 44.0,
                    dataRowMaxHeight: 48.0,
                    columns: const [
                      DataColumn(label: Text('Yıl', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      DataColumn(label: Text('Yaş', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      DataColumn(label: Text('Başlangıç Portföy', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      DataColumn(label: Text('Yıllık Tasarruf', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      DataColumn(label: Text('Yıllık Getiri', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      DataColumn(label: Text('Yıl Sonu Toplam', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                      DataColumn(label: Text('Aylık Pasif Gelir (%4)', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11))),
                    ],
                    rows: projections.map((proj) {
                      final isTargetReached = proj.endingPortfolio >= service.targetPortfolioValue;

                      return DataRow(
                        cells: [
                          DataCell(Text(proj.year.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                          DataCell(Text(proj.age.toString(), style: const TextStyle(fontSize: 12))),
                          DataCell(Text(tlFormatter.format(proj.startingPortfolio), style: const TextStyle(fontSize: 12))),
                          DataCell(Text(tlFormatter.format(proj.annualSavings), style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)))),
                          DataCell(Text(tlFormatter.format(proj.expectedReturn), style: const TextStyle(fontSize: 12, color: Color(0xFF16A34A)))),
                          DataCell(
                            Text(
                              tlFormatter.format(proj.endingPortfolio),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isTargetReached ? const Color(0xFF16A34A) : const Color(0xFF111827),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF16A34A).withOpacity(0.06),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tlFormatter.format(proj.expectedPassiveIncome),
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildParamItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w600, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: Color(0xFF111827)),
        ),
      ],
    );
  }
}
