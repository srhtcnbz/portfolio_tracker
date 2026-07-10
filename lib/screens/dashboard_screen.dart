import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../widgets/macro_overview_card.dart';
import '../widgets/portfolio_asset_tile.dart';

/// Minimalist investment tracking dashboard screen.
/// Features a top summary card ("Macro Overview") and a vertical list of portfolio assets.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional minimalist light-grey background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PORTFOLIO TRACKER',
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Investment Dashboard',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Color(0xFF374151)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Color(0xFF374151)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFE5E7EB),
            height: 1.0,
          ),
        ),
      ),
      body: Consumer<PortfolioService>(
        builder: (context, portfolioService, child) {
          final assets = portfolioService.assets;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 16.0),
                sliver: SliverToBoxAdapter(
                  child: MacroOverviewCard(
                    totalValue: portfolioService.totalPortfolioValue,
                    totalGainLoss: portfolioService.totalProfitLoss,
                    gainLossPercentage: portfolioService.totalProfitLossPercentage,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PORTFOLIO ASSETS',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '${assets.length} HOLDINGS',
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 32.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final asset = assets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: PortfolioAssetTile(
                          asset: asset,
                          onTap: () {
                            // Tap handler for future detail screen
                          },
                        ),
                      );
                    },
                    childCount: assets.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
