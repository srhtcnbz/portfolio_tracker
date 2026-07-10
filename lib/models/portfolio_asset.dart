/// Category classification for portfolio allocation horizon.
enum AssetHorizon {
  longTerm('Long-term', 60.0),
  midTerm('Mid-term', 30.0),
  shortTerm('Short-term', 10.0);

  final String label;
  final double targetPercentage;
  const AssetHorizon(this.label, this.targetPercentage);
}

/// Represents an asset holding in the portfolio with valuation in TL (₺).
class PortfolioAsset {
  final String assetCode;
  final String name;
  final double currentValueTl;
  final double profitLossPercentage;
  final AssetHorizon horizon;

  const PortfolioAsset({
    required this.assetCode,
    required this.name,
    required this.currentValueTl,
    required this.profitLossPercentage,
    required this.horizon,
  });

  /// Whether this holding is currently in profit.
  bool get isProfitable => profitLossPercentage >= 0;
}
