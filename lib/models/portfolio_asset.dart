/// Yatırım ufku (Long-term / Mid-term / Short-term) ve hedef oranları.
enum AssetHorizon {
  longTerm('Long-term', 60.0),
  midTerm('Mid-term', 30.0),
  shortTerm('Short-term', 10.0);

  final String label;
  final double targetPercentage;
  const AssetHorizon(this.label, this.targetPercentage);
}

/// Portföydeki tek bir varlığın detaylarını (fiyat, değişim, toplam değer) tutan model.
class PortfolioAsset {
  final String assetCode;
  final String name;
  final double currentPrice;
  final double dailyChangePercent;
  final double totalValue;
  final AssetHorizon horizon;

  const PortfolioAsset({
    required this.assetCode,
    required this.name,
    required this.currentPrice,
    required this.dailyChangePercent,
    required this.totalValue,
    required this.horizon,
  });

  /// Günlük veya toplam kâr durumu.
  bool get isProfitable => dailyChangePercent >= 0;
}
