/// Represents an aggregated portfolio asset holding and its market status.
class PortfolioAsset {
  final String assetCode;
  final String name;
  final double totalQuantity;
  final double currentPrice;
  final double averageCost;
  final double dailyChangePercentage;

  const PortfolioAsset({
    required this.assetCode,
    required this.name,
    required this.totalQuantity,
    required this.currentPrice,
    required this.averageCost,
    required this.dailyChangePercentage,
  });

  /// Total current market value of this holding.
  double get currentValue => totalQuantity * currentPrice;

  /// Total cost basis of this holding.
  double get totalCost => totalQuantity * averageCost;

  /// Total absolute gain or loss.
  double get totalGainLoss => currentValue - totalCost;

  /// Percentage gain or loss relative to total cost.
  double get totalGainLossPercentage {
    if (totalCost == 0) return 0.0;
    return (totalGainLoss / totalCost) * 100.0;
  }
}
