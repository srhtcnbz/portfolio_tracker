import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A minimalist top summary card displaying the Macro Overview of the portfolio.
class MacroOverviewCard extends StatelessWidget {
  final double totalValue;
  final double totalGainLoss;
  final double gainLossPercentage;

  const MacroOverviewCard({
    super.key,
    required this.totalValue,
    required this.totalGainLoss,
    required this.gainLossPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isPositive = totalGainLoss >= 0;
    final gainColor = isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MACRO OVERVIEW',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: const Color(0xFF6B7280),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Text(
            currencyFormatter.format(totalValue),
            style: const TextStyle(
              fontSize: 34.0,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: gainColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14.0,
                      color: gainColor,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${isPositive ? '+' : ''}${currencyFormatter.format(totalGainLoss)} '
                      '(${isPositive ? '+' : ''}${gainLossPercentage.toStringAsFixed(2)}%)',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                        color: gainColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              const Text(
                'All-Time Return',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Divider(color: Color(0xFFF3F4F6), height: 1),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroMetric('Holdings', '4 Assets'),
              _buildMacroMetric('Risk Exposure', 'Balanced'),
              _buildMacroMetric('Cash Allocation', '12.4%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11.0,
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.0,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
