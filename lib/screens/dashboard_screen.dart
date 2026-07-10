import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../widgets/macro_overview_card.dart';
import '../widgets/portfolio_asset_tile.dart';

/// Minimalist investment tracking dashboard screen.
/// Features a top Macro Overview card (60/30/10 target vs actual allocation breakdown)
/// and a scrollable ListView.builder of portfolio assets.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Professional minimalist light grey background
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
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Investment Dashboard',
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF374151)),
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
          final allocations = portfolioService.macroAllocations;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Top Macro Overview Section
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
                sliver: SliverToBoxAdapter(
                  child: MacroOverviewCard(
                    totalValueTl: portfolioService.totalValueTl,
                    totalProfitLossPercentage: portfolioService.totalProfitLossPercentage,
                    allocations: allocations,
                  ),
                ),
              ),

              // Section Header for Asset Holdings List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PORTFOLIO ASSETS',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '${assets.length} HOLDINGS',
                        style: const TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Vertical Scrollable List of Individual Assets
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 32.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final asset = assets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: PortfolioAssetTile(
                          asset: asset,
                          onTap: () {
                            // Placeholder tap action for future detailed view
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
