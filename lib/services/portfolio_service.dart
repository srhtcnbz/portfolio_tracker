import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/portfolio_asset.dart';
import '../widgets/macro_overview_card.dart';

/// Service managing portfolio holdings and calculating macro overview allocations.
class PortfolioService extends ChangeNotifier {
  final List<PortfolioAsset> _assets = const [
    PortfolioAsset(
      assetCode: 'VOO',
      name: 'Vanguard S&P 500 ETF',
      currentValueTl: 512000.00,
      profitLossPercentage: 14.82,
      horizon: AssetHorizon.longTerm,
    ),
    PortfolioAsset(
      assetCode: 'QQQ',
      name: 'Invesco QQQ Trust',
      currentValueTl: 288400.00,
      profitLossPercentage: 18.40,
      horizon: AssetHorizon.longTerm,
    ),
    PortfolioAsset(
      assetCode: 'THYAO',
      name: 'Türk Hava Yolları',
      currentValueTl: 210500.00,
      profitLossPercentage: 6.15,
      horizon: AssetHorizon.midTerm,
    ),
    PortfolioAsset(
      assetCode: 'ASELS',
      name: 'Aselsan Elektronik',
      currentValueTl: 138000.00,
      profitLossPercentage: -2.40,
      horizon: AssetHorizon.midTerm,
    ),
    PortfolioAsset(
      assetCode: 'ALTIN',
      name: 'Gram Altın Fonu',
      currentValueTl: 85600.00,
      profitLossPercentage: 9.30,
      horizon: AssetHorizon.shortTerm,
    ),
    PortfolioAsset(
      assetCode: 'PPF',
      name: 'Para Piyasası Fonu',
      currentValueTl: 43000.00,
      profitLossPercentage: 4.10,
      horizon: AssetHorizon.shortTerm,
    ),
  ];

  /// Unmodifiable list of assets.
  List<PortfolioAsset> get assets => List.unmodifiable(_assets);

  /// Total current market valuation in Turkish Lira (₺).
  double get totalValueTl {
    return _assets.fold(0.0, (sum, asset) => sum + asset.currentValueTl);
  }

  /// Total weighted profit/loss return percentage across the portfolio.
  double get totalProfitLossPercentage {
    if (_assets.isEmpty || totalValueTl == 0) return 0.0;
    double weightedSum = 0.0;
    for (final asset in _assets) {
      final weight = asset.currentValueTl / totalValueTl;
      weightedSum += asset.profitLossPercentage * weight;
    }
    return weightedSum;
  }

  /// Calculates target vs actual percentage breakdown for Long/Mid/Short horizons.
  List<HorizonAllocation> get macroAllocations {
    final total = totalValueTl;
    if (total == 0) {
      return const [
        HorizonAllocation(
          label: 'Long-term',
          targetPercentage: 60.0,
          actualPercentage: 0.0,
          barColor: Color(0xFF1F2937),
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
          longTermSum += asset.currentValueTl;
          break;
        case AssetHorizon.midTerm:
          midTermSum += asset.currentValueTl;
          break;
        case AssetHorizon.shortTerm:
          shortTermSum += asset.currentValueTl;
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
