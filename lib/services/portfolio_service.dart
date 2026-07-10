import 'package:flutter/foundation.dart';
import '../models/portfolio_asset.dart';
import '../models/transaction_record.dart';

/// A production-ready service managing portfolio state and transaction records.
/// Can be wired to Cloud Firestore or used locally via Provider.
class PortfolioService extends ChangeNotifier {
  final List<TransactionRecord> _transactions = [
    TransactionRecord(
      id: 'tx_001',
      date: DateTime.now().subtract(const Duration(days: 15)),
      assetCode: 'AAPL',
      transactionType: 'BUY',
      quantity: 25.0,
      price: 184.50,
    ),
    TransactionRecord(
      id: 'tx_002',
      date: DateTime.now().subtract(const Duration(days: 10)),
      assetCode: 'MSFT',
      transactionType: 'BUY',
      quantity: 12.0,
      price: 412.30,
    ),
    TransactionRecord(
      id: 'tx_003',
      date: DateTime.now().subtract(const Duration(days: 4)),
      assetCode: 'NVDA',
      transactionType: 'BUY',
      quantity: 30.0,
      price: 122.00,
    ),
    TransactionRecord(
      id: 'tx_004',
      date: DateTime.now().subtract(const Duration(days: 2)),
      assetCode: 'BTC',
      transactionType: 'BUY',
      quantity: 0.45,
      price: 64200.00,
    ),
  ];

  final List<PortfolioAsset> _assets = [
    const PortfolioAsset(
      assetCode: 'AAPL',
      name: 'Apple Inc.',
      totalQuantity: 25.0,
      currentPrice: 195.80,
      averageCost: 184.50,
      dailyChangePercentage: 1.42,
    ),
    const PortfolioAsset(
      assetCode: 'MSFT',
      name: 'Microsoft Corp.',
      totalQuantity: 12.0,
      currentPrice: 428.10,
      averageCost: 412.30,
      dailyChangePercentage: -0.38,
    ),
    const PortfolioAsset(
      assetCode: 'NVDA',
      name: 'NVIDIA Corp.',
      totalQuantity: 30.0,
      currentPrice: 128.45,
      averageCost: 122.00,
      dailyChangePercentage: 3.15,
    ),
    const PortfolioAsset(
      assetCode: 'BTC',
      name: 'Bitcoin',
      totalQuantity: 0.45,
      currentPrice: 66800.00,
      averageCost: 64200.00,
      dailyChangePercentage: 2.10,
    ),
  ];

  /// Unmodifiable view of transaction records.
  List<TransactionRecord> get transactions => List.unmodifiable(_transactions);

  /// Unmodifiable view of portfolio asset holdings.
  List<PortfolioAsset> get assets => List.unmodifiable(_assets);

  /// Total current market valuation of all assets in the portfolio.
  double get totalPortfolioValue {
    return _assets.fold(0.0, (sum, asset) => sum + asset.currentValue);
  }

  /// Total cost basis across all holdings.
  double get totalCostBasis {
    return _assets.fold(0.0, (sum, asset) => sum + asset.totalCost);
  }

  /// Total absolute profit / loss.
  double get totalProfitLoss => totalPortfolioValue - totalCostBasis;

  /// Total profit / loss percentage.
  double get totalProfitLossPercentage {
    if (totalCostBasis == 0) return 0.0;
    return (totalProfitLoss / totalCostBasis) * 100.0;
  }

  /// Adds a new [TransactionRecord] and notifies listeners.
  void addTransaction(TransactionRecord record) {
    _transactions.insert(0, record);
    notifyListeners();
  }
}
