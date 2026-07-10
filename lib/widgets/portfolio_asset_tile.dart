import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/portfolio_asset.dart';

/// Minimalist list tile displaying an individual portfolio asset holding.
/// Shows Asset Code on the left, current TL valuation and colored P&L percentage on the right.
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
    final tlFormatter = NumberFormat.currency(
      symbol: '₺',
      decimalDigits: 2,
      locale: 'tr_TR',
    );
    final isProfit = asset.isProfitable;
    final changeColor = isProfit ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left: Asset Code Badge & Name
            Container(
              width: 48.0,
              height: 48.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                asset.assetCode.length > 5
                    ? asset.assetCode.substring(0, 5)
                    : asset.assetCode,
                style: const TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w800,
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
                    asset.assetCode,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    '${asset.name} • ${asset.horizon.label}',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            // Right: Current Value in TL & Colored P/L percentage
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  tlFormatter.format(asset.currentValueTl),
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: changeColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 11.0,
                        color: changeColor,
                      ),
                      const SizedBox(width: 3.0),
                      Text(
                        '${isProfit ? '+' : ''}${asset.profitLossPercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: changeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
