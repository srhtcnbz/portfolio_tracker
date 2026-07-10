import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../widgets/macro_overview_card.dart';
import '../widgets/portfolio_asset_tile.dart';

/// Yatırım portföyü ana kontrol paneli ekranı.
/// Provider ile PortfolioService üzerinden anlık verileri çeker.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
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
              'Yatırım Dashboard',
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
            icon: const Icon(Icons.refresh, color: Color(0xFF374151)),
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
              // Üst Bölüm: Macro Overview Kartı (Toplam Değer, Dün'e göre Değişim, Alokasyon)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
                sliver: SliverToBoxAdapter(
                  child: MacroOverviewCard(
                    totalValueTl: portfolioService.totalValueTl,
                    dailyChangeAmountTl: portfolioService.dailyChangeAmountTl,
                    dailyChangePercentage: portfolioService.dailyChangePercentage,
                    allocations: allocations,
                  ),
                ),
              ),

              // Liste Başlığı
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'PORTFÖY VARLIKLARI',
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        '${assets.length} VARLIK',
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

              // Varlık Listesi: ListView.builder yapısına denk SliverList (modern kart + ince divider)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 36.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final asset = assets[index];
                      final isLast = index == assets.length - 1;

                      return Column(
                        children: [
                          PortfolioAssetTile(
                            asset: asset,
                            onTap: () {},
                          ),
                          if (!isLast)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(
                                color: Color(0xFFE5E7EB),
                                height: 1,
                                thickness: 0.8,
                              ),
                            ),
                        ],
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
