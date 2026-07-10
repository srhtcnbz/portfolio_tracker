import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Allocation summary data model for a specific investment horizon.
class HorizonAllocation {
  final String label;
  final double targetPercentage;
  final double actualPercentage;
  final Color barColor;

  const HorizonAllocation({
    required this.label,
    required this.targetPercentage,
    required this.actualPercentage,
    required this.barColor,
  });
}

/// A minimalist, high-end Macro Overview card showing total portfolio value in TL
/// and the breakdown of Long-term (60%), Mid-term (30%), and Short-term (10%) targets vs actuals.
class MacroOverviewCard extends StatelessWidget {
  final double totalValueTl;
  final double totalProfitLossPercentage;
  final List<HorizonAllocation> allocations;

  const MacroOverviewCard({
    super.key,
    required this.totalValueTl,
    required this.totalProfitLossPercentage,
    required this.allocations,
  });

  @override
  Widget build(BuildContext context) {
    final tlFormatter = NumberFormat.currency(
      symbol: '₺',
      decimalDigits: 2,
      locale: 'tr_TR',
    );
    final isPositive = totalProfitLossPercentage >= 0;
    final badgeColor = isPositive ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'MACRO OVERVIEW',
                style: TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: Color(0xFF6B7280),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.shield_outlined, size: 13, color: Color(0xFF4B5563)),
                    SizedBox(width: 4),
                    Text(
                      'TARGET vs ACTUAL',
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // Total Value & Return Badge
          Text(
            tlFormatter.format(totalValueTl),
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14.0,
                      color: badgeColor,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${isPositive ? '+' : ''}${totalProfitLossPercentage.toStringAsFixed(2)}%',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8.0),
              const Text(
                'Total Portfolio Return',
                style: TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24.0),
          const Divider(color: Color(0xFFF3F4F6), height: 1),
          const SizedBox(height: 20.0),

          // Allocation Section Header
          const Text(
            'ALLOCATION STRATEGY',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 14.0),

          // Allocation Breakdown Bars
          ...allocations.map((item) => _buildAllocationRow(item)),
        ],
      ),
    );
  }

  Widget _buildAllocationRow(HorizonAllocation item) {
    final diff = item.actualPercentage - item.targetPercentage;
    final diffText = diff >= 0
        ? '+${diff.toStringAsFixed(1)}%'
        : '${diff.toStringAsFixed(1)}%';
    final diffColor = diff >= 0 ? const Color(0xFF16A34A) : const Color(0xFFD97706);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: item.barColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(Target ${item.targetPercentage.toStringAsFixed(0)}%)',
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${item.actualPercentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: diffColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      diffText,
                      style: TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: diffColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Container(
                  height: 7,
                  width: double.infinity,
                  color: const Color(0xFFF3F4F6),
                ),
                FractionallySizedBox(
                  widthFactor: (item.actualPercentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    height: 7,
                    color: item.barColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
