import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/portfolio_asset.dart';

/// Minimalist list tile widget for displaying an individual portfolio asset.
class PortfolioAssetTile extends StatelessWidget {
  final PortfolioAsset asset;
  final VoidCallback? onTap;

  const PortfolioAssetTile({
    super.key,
    required this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isPositive = asset.dailyChangePercentage >= 0;
    final changeColor = isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFF3F4F6), width: 1.0),
        ),
        child: Row(
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Text(
                asset.assetCode.length > 4
                    ? asset.assetCode.substring(0, 4)
                    : asset.assetCode,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    asset.name,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${asset.totalQuantity.toStringAsFixed(asset.assetCode == 'BTC' ? 4 : 1)} shares • Avg ${currencyFormatter.format(asset.averageCost)}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormatter.format(asset.currentValue),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 18.0,
                      color: changeColor,
                    ),
                    Text(
                      '${isPositive ? '+' : ''}${asset.dailyChangePercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
