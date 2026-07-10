import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/portfolio_service.dart';
import '../widgets/macro_overview_card.dart';
import '../widgets/portfolio_asset_tile.dart';
import '../widgets/add_transaction_modal.dart';
import '../widgets/budget_tab.dart';
import '../widgets/freedom_tab.dart';
import '../widgets/projection_tab.dart';
import 'asset_detail_screen.dart';

/// Yatırım portföyü ana kontrol paneli ekranı.
/// Alt menü ile Portföy, Bütçe, Özgürlük ve Projeksiyon sekmeleri arasında geçiş yapılabilir.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  void _showAddModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) => const AddTransactionModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<PortfolioService>(context);

    // Sekme Listesi
    final List<Widget> tabs = [
      _buildPortfolioTab(service),
      const BudgetTab(),
      const FreedomTab(),
      const ProjectionTab(),
    ];

    // Sekmelere göre dinamik başlıklar
    final List<String> titles = [
      'Yatırım Dashboard',
      'Gelir & Gider Bütçesi',
      'Özgürlük Oranı & FIRE',
      'Gelecek Varlık Projeksiyonu',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PORTFOLIO TRACKER',
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              titles[_currentIndex],
              style: const TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        actions: [
          if (_currentIndex == 0)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF111827)),
              onPressed: () => _showAddModal(context),
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
      body: IndexedStack(
        index: _currentIndex,
        children: tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF111827),
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedLabelStyle: const TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 10.0),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Portföy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Bütçe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Özgürlük',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_outlined),
            activeIcon: Icon(Icons.trending_up),
            label: 'Projeksiyon',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.add),
              label: const Text(
                'İşlem Ekle',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () => _showAddModal(context),
            )
          : null,
    );
  }

  // PORTFÖY SEKME TASARIMI (Ana scrollable görünüm)
  Widget _buildPortfolioTab(PortfolioService service) {
    final assets = service.assets;
    final allocations = service.macroAllocations;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Üst Bölüm: Macro Overview Kartı (Toplam Değer, Dün'e göre Değişim, Alokasyon)
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
          sliver: SliverToBoxAdapter(
            child: MacroOverviewCard(
              totalValueTl: service.totalValueTl,
              dailyChangeAmountTl: service.dailyChangeAmountTl,
              dailyChangePercentage: service.dailyChangePercentage,
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
          padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 80.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final asset = assets[index];
                final isLast = index == assets.length - 1;

                return Column(
                  children: [
                    PortfolioAssetTile(
                      asset: asset,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AssetDetailScreen(asset: asset),
                          ),
                        );
                      },
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
  }
}
