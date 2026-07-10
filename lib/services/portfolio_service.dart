import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/portfolio_asset.dart';
import '../widgets/macro_overview_card.dart';

/// Gerçek BIST ve Global ETF verilerini simüle eden ve durumu yöneten servis.
class PortfolioService extends ChangeNotifier {
  final List<PortfolioAsset> _assets = const [
    PortfolioAsset(
      assetCode: 'VOO',
      name: 'Vanguard S&P 500 ETF',
      currentPrice: 17450.00,
      dailyChangePercent: 1.85,
      totalValue: 512000.00,
      horizon: AssetHorizon.longTerm,
    ),
    PortfolioAsset(
      assetCode: 'QQQ',
      name: 'Invesco QQQ Trust',
      currentPrice: 16210.00,
      dailyChangePercent: 2.40,
      totalValue: 288400.00,
      horizon: AssetHorizon.longTerm,
    ),
    PortfolioAsset(
      assetCode: 'THYAO',
      name: 'Türk Hava Yolları',
      currentPrice: 312.50,
      dailyChangePercent: 3.15,
      totalValue: 210500.00,
      horizon: AssetHorizon.midTerm,
    ),
    PortfolioAsset(
      assetCode: 'ASELS',
      name: 'Aselsan Elektronik',
      currentPrice: 64.80,
      dailyChangePercent: -1.20,
      totalValue: 138000.00,
      horizon: AssetHorizon.midTerm,
    ),
    PortfolioAsset(
      assetCode: 'TUPRS',
      name: 'Tüpraş',
      currentPrice: 172.40,
      dailyChangePercent: 0.95,
      totalValue: 95000.00,
      horizon: AssetHorizon.midTerm,
    ),
    PortfolioAsset(
      assetCode: 'KCHOL',
      name: 'Koç Holding',
      currentPrice: 218.00,
      dailyChangePercent: -0.60,
      totalValue: 82000.00,
      horizon: AssetHorizon.shortTerm,
    ),
    PortfolioAsset(
      assetCode: 'GLDTR',
      name: 'Ziraat Altın ETF',
      currentPrice: 2840.00,
      dailyChangePercent: 1.10,
      totalValue: 64000.00,
      horizon: AssetHorizon.shortTerm,
    ),
  ];

  /// Portföydeki tüm varlıkların salt okunur listesi.
  List<PortfolioAsset> get assets => List.unmodifiable(_assets);

  /// Toplam portföy değeri (TL).
  double get totalValueTl {
    return _assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  /// Dün'e göre toplam günlük parasal değişim (TL).
  double get dailyChangeAmountTl {
    return _assets.fold(0.0, (sum, asset) {
      // Varlığın dünkü değeri: totalValue / (1 + changePct/100)
      final yesterdayValue = asset.totalValue / (1 + (asset.dailyChangePercent / 100));
      return sum + (asset.totalValue - yesterdayValue);
    });
  }

  /// Dün'e göre toplam günlük yüzde değişim (%).
  double get dailyChangePercentage {
    final totalNow = totalValueTl;
    if (totalNow == 0) return 0.0;
    final totalYesterday = totalNow - dailyChangeAmountTl;
    if (totalYesterday == 0) return 0.0;
    return ((totalNow - totalYesterday) / totalYesterday) * 100.0;
  }

  /// Hedef ile gerçekleşen alokasyon oranları (Long-term / Mid-term / Short-term).
  List<HorizonAllocation> get macroAllocations {
    final total = totalValueTl;
    if (total == 0) {
      return const [
        HorizonAllocation(
          label: 'Long-term',
          targetPercentage: 60.0,
          actualPercentage: 0.0,
          barColor: Color(0xFF111827),
        ),
        HorizonAllocation(
          label: 'Mid-term',
          targetPercentage: 30.0,
          actualPercentage: 0.0,
          barColor: Color(0xFF4B5563),
        ),
        HorizonAllocation(
          label: 'Short-term',
          targetPercentage: 10.0,
          actualPercentage: 0.0,
          barColor: Color(0xFF9CA3AF),
        ),
      ];
    }

    double longTermSum = 0.0;
    double midTermSum = 0.0;
    double shortTermSum = 0.0;

    for (final asset in _assets) {
      switch (asset.horizon) {
        case AssetHorizon.longTerm:
          longTermSum += asset.totalValue;
          break;
        case AssetHorizon.midTerm:
          midTermSum += asset.totalValue;
          break;
        case AssetHorizon.shortTerm:
          shortTermSum += asset.totalValue;
          break;
      }
    }

    return [
      HorizonAllocation(
        label: 'Long-term',
        targetPercentage: 60.0,
        actualPercentage: (longTermSum / total) * 100.0,
        barColor: const Color(0xFF111827),
      ),
      HorizonAllocation(
        label: 'Mid-term',
        targetPercentage: 30.0,
        actualPercentage: (midTermSum / total) * 100.0,
        barColor: const Color(0xFF4B5563),
      ),
      HorizonAllocation(
        label: 'Short-term',
        targetPercentage: 10.0,
        actualPercentage: (shortTermSum / total) * 100.0,
        barColor: const Color(0xFF9CA3AF),
      ),
    ];
  }
}
