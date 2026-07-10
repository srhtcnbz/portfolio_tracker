import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/portfolio_asset.dart';

/// Her bir varlık için modern, yuvarlatılmış köşeli kart görünümünde AssetTile widget'ı.
/// Sol: Sembol ve İsim
/// Orta: Güncel Fiyat ve Günlük Değişim Yüzdesi
/// Sağ: Toplam Değer (TL) ve Kâr/Zarar Durum Badge'i
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
    final badgeColor = isProfit ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sol: Varlık ismi ve sembolü (Örn: VOO - Vanguard S&P 500)
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Container(
                    width: 46.0,
                    height: 46.0,
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
                  const SizedBox(width: 12.0),
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
                          asset.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Orta: Güncel Fiyat (TL bazlı) ve altında küçük puntoyla günlük değişim yüzdesi
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tlFormatter.format(asset.currentPrice),
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    '${isProfit ? '+' : ''}%${asset.dailyChangePercent.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
            ),

            // Sağ: Toplam Değer (TL) ve Kâr/Zarar etiket Badge'i
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tlFormatter.format(asset.totalValue),
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 11.0,
                          color: badgeColor,
                        ),
                        const SizedBox(width: 3.0),
                        Text(
                          isProfit ? 'KÂR' : 'ZARAR',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: badgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
