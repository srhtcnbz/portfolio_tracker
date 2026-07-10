import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';

/// Finansal Özgürlük Oranları, FIRE hedefleri ve pasif gelir takip sekmesi.
class FreedomTab extends StatelessWidget {
  const FreedomTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tlFormatter = NumberFormat.currency(symbol: '₺', decimalDigits: 2, locale: 'tr_TR');
    final service = Provider.of<PortfolioService>(context);

    // Fare Yarışı Kaçış Oranı (Toplam portföy / Hedef portföy) * 100
    final double escapeRatio = (service.totalValueTl / service.targetPortfolioValue) * 100.0;

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      children: [
        // Fare Yarışından Kurtuluş Durumu
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: const Color(0xFF111827), // Koyu premium kart tasarımı
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [BoxShadow(color: Color(0x24000000), blurRadius: 18, offset: Offset(0, 8))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FARE YARIŞINDAN KAÇIŞ',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Pasif Gelir Hedefi',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.emoji_events, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'FIRE HEDEFİ',
                          style: TextStyle(fontSize: 9.0, fontWeight: FontWeight.w800, color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mevcut Portföy',
                        style: TextStyle(fontSize: 12.0, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tlFormatter.format(service.totalValueTl),
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Hedef Varlık',
                        style: TextStyle(fontSize: 12.0, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tlFormatter.format(service.targetPortfolioValue),
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // İlerleme Çubuğu
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Stack(
                  children: [
                    Container(height: 8, color: Colors.white24),
                    FractionallySizedBox(
                      widthFactor: (escapeRatio / 100).clamp(0.0, 1.0),
                      child: Container(
                        height: 8,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.amber, Colors.orangeAccent]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'İlerleme: %${escapeRatio.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600, color: Color(0xFFD1D5DB)),
                  ),
                  const Text(
                    'Kaçış Portföy Hedefi',
                    style: TextStyle(fontSize: 11.0, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Özgürlük Rapor Başlığı
        const Text(
          'ÖZGÜRLÜK DURUMU VE PASİF GELİR',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B7280),
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 14),

        // Çiğdem ve Serhat Rapor Kartları (Excel sayfasındaki bireysel durumlar)
        _buildFreedomUserCard(
          userName: 'ÇİĞDEM',
          freedomRate: service.cigdemFreedomRatio,
          currentPassive: service.cigdemPassiveIncomeMonthly,
          targetPortfolio: 9367980.00, // Excel'deki Çiğdem Hedef Portföy
          targetWithdrawalRate: 6.0,
          formatter: tlFormatter,
        ),
        const SizedBox(height: 14),
        _buildFreedomUserCard(
          userName: 'SERHAT',
          freedomRate: service.serhatFreedomRatio,
          currentPassive: service.serhatPassiveIncomeMonthly,
          targetPortfolio: 22483152.00, // Excel'deki Serhat Hedef Portföy
          targetWithdrawalRate: 5.0,
          formatter: tlFormatter,
        ),
        const SizedBox(height: 20),

        // Passive Income vs Monthly Expense Summary Box
        Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AYLIK FİNANSAL SAĞLIK ÖZETİ',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Mevcut Pasif Gelir (Aylık):', style: TextStyle(fontSize: 13.0, color: Color(0xFF4B5563))),
                  Text(tlFormatter.format(service.totalPassiveIncomeMonthly),
                      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: Color(0xFF16A34A))),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aylık Toplam Giderler:', style: TextStyle(fontSize: 13.0, color: Color(0xFF4B5563))),
                  Text(tlFormatter.format(service.totalMonthlyExpense),
                      style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: Color(0xFFDC2626))),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Color(0xFFF3F4F6), height: 1),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Özgürlük Oranı:', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                  Text('%${service.totalFreedomRatio.toStringAsFixed(1)}',
                      style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFreedomUserCard({
    required String userName,
    required double freedomRate,
    required double currentPassive,
    required double targetPortfolio,
    required double targetWithdrawalRate,
    required NumberFormat formatter,
  }) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 12, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                userName,
                style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2937).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Çekim Hedefi: %${targetWithdrawalRate.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Circular Progress Indicator for individual freedom ratio
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: freedomRate / 100,
                      backgroundColor: const Color(0xFFF3F4F6),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF111827)),
                      strokeWidth: 5,
                    ),
                    Center(
                      child: Text(
                        '%${freedomRate.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800, color: Color(0xFF111827)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pasif Gelir:', style: TextStyle(fontSize: 12.0, color: Color(0xFF6B7280))),
                        Text(formatter.format(currentPassive),
                            style: const TextStyle(fontSize: 13.0, fontWeight: FontWeight.w700, color: Color(0xFF1F2937))),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Hedef Portföy:', style: TextStyle(fontSize: 12.0, color: Color(0xFF6B7280))),
                        Text(formatter.format(targetPortfolio),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF4B5563))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
