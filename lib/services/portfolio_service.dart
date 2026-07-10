import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/portfolio_asset.dart';
import '../models/transaction_record.dart';
import '../models/budget_entry.dart';
import '../models/financial_projection.dart';
import '../widgets/macro_overview_card.dart';

/// Finans Profesörü standartlarında bütçe, portföy, özgürlük hesapları
/// ve compound büyüme projeksiyonu sunan merkezi veri ve durum yönetim servisi.
class PortfolioService extends ChangeNotifier {
  // USDTRY Sabit Kuru (Excel'deki 46.84 baz alınmıştır)
  static const double usdTryRate = 46.84;

  // 1. Portföy Varlıkları listesi (Excel Tablo 3 & 4 değerlerine göre güncellendi)
  final List<PortfolioAsset> _assets = [
    const PortfolioAsset(
      assetCode: 'VOO',
      name: 'Vanguard S&P 500 ETF',
      currentPrice: 690.62 * usdTryRate, // 690.62 USD
      dailyChangePercent: 0.15,
      totalValue: 543947.10,
      horizon: AssetHorizon.longTerm,
    ),
    const PortfolioAsset(
      assetCode: 'QQQM',
      name: 'Invesco Nasdaq 100 ETF',
      currentPrice: 297.52 * usdTryRate, // 297.52 USD
      dailyChangePercent: 0.18,
      totalValue: 271973.55,
      horizon: AssetHorizon.longTerm,
    ),
    const PortfolioAsset(
      assetCode: 'IAU',
      name: 'iShares Gold Trust',
      currentPrice: 78.3 * usdTryRate, // 78.3 USD
      dailyChangePercent: 0.17,
      totalValue: 136007.72,
      horizon: AssetHorizon.longTerm,
    ),
    const PortfolioAsset(
      assetCode: 'BSV',
      name: 'iShares Short-Term Bond',
      currentPrice: 77.77 * usdTryRate, // 77.77 USD
      dailyChangePercent: 0.05,
      totalValue: 68003.86,
      horizon: AssetHorizon.midTerm,
    ),
    const PortfolioAsset(
      assetCode: 'VGIT',
      name: 'Vanguard Intermediate Bond',
      currentPrice: 58.81 * usdTryRate, // 58.81 USD
      dailyChangePercent: 0.08,
      totalValue: 40810.70,
      horizon: AssetHorizon.midTerm,
    ),
    const PortfolioAsset(
      assetCode: 'TLT',
      name: 'iShares 20+ Year Treasury',
      currentPrice: 85.45 * usdTryRate, // 85.45 USD
      dailyChangePercent: -0.11,
      totalValue: 27193.16,
      horizon: AssetHorizon.longTerm,
    ),
    const PortfolioAsset(
      assetCode: 'FTGC',
      name: 'First Trust Global Commodity',
      currentPrice: 27.8 * usdTryRate, // 27.8 USD
      dailyChangePercent: -0.77,
      totalValue: 136007.72,
      horizon: AssetHorizon.midTerm,
    ),
    const PortfolioAsset(
      assetCode: 'SPMO',
      name: 'Invesco S&P 500 Momentum',
      currentPrice: 152.98 * usdTryRate, // 152.98 USD
      dailyChangePercent: -0.30,
      totalValue: 27193.16,
      horizon: AssetHorizon.longTerm,
    ),
    const PortfolioAsset(
      assetCode: 'ARKK',
      name: 'ARK Innovation ETF',
      currentPrice: 9.18 * usdTryRate, // 9.18 USD
      dailyChangePercent: -0.20,
      totalValue: 27193.16,
      horizon: AssetHorizon.longTerm,
    ),
    const PortfolioAsset(
      assetCode: 'IBIT',
      name: 'iShares Bitcoin Trust',
      currentPrice: 36.12 * usdTryRate, // 36.12 USD
      dailyChangePercent: 0.17,
      totalValue: 27193.16,
      horizon: AssetHorizon.shortTerm,
    ),
    const PortfolioAsset(
      assetCode: 'EETH',
      name: 'iShares Ethereum Trust',
      currentPrice: 21.88 * usdTryRate, // 21.88 USD
      dailyChangePercent: 0.15,
      totalValue: 13617.53,
      horizon: AssetHorizon.shortTerm,
    ),
    const PortfolioAsset(
      assetCode: 'BES',
      name: 'Bireysel Emeklilik Sistemi',
      currentPrice: 1.00,
      dailyChangePercent: 0.10,
      totalValue: 68821.00,
      horizon: AssetHorizon.shortTerm,
    ),
    const PortfolioAsset(
      assetCode: 'STARTUP',
      name: 'Fonbulucu Girişim Yatırımları',
      currentPrice: 1.00,
      dailyChangePercent: 0.25,
      totalValue: 24725.41,
      horizon: AssetHorizon.longTerm,
    ),
  ];

  // İşlemler Listesi
  final List<TransactionRecord> _transactions = [];

  // 2. Bütçe Gelir Listesi (Excel Sayfa 9 bütçe gelirlerine göre)
  final List<BudgetEntry> _incomes = [
    const BudgetEntry(
      id: 'i1',
      category: 'ÇİĞDEM',
      title: 'Maaş ÇİĞDEM',
      amount: 70000.00,
      isIncome: true,
    ),
    const BudgetEntry(
      id: 'i2',
      category: 'SERHAT',
      title: 'Maaş Kök SERHAT',
      amount: 98850.00,
      isIncome: true,
    ),
    const BudgetEntry(
      id: 'i3',
      category: 'SERHAT',
      title: 'Tediye SERHAT',
      amount: 42835.00 / 3, // Aylık ortalaması (yılda 4 defa tediye)
      isIncome: true,
    ),
    const BudgetEntry(
      id: 'i4',
      category: 'SERHAT',
      title: 'Tazminat SERHAT',
      amount: 14150.00,
      isIncome: true,
    ),
  ];

  // 3. Bütçe Gider Listesi (Excel Sayfa 9 & 10 bütçe giderlerine göre)
  final List<BudgetEntry> _expenses = [
    // CANSU çocuk giderleri
    const BudgetEntry(id: 'e1', category: 'Cansu', title: 'Okul / Yemek / Kitap', amount: 36730.00, isIncome: false),
    const BudgetEntry(id: 'e2', category: 'Cansu', title: 'Okul Servisi', amount: 5667.00, isIncome: false),
    const BudgetEntry(id: 'e3', category: 'Cansu', title: 'Anadolu Ateşi Kurs', amount: 7083.00, isIncome: false),
    const BudgetEntry(id: 'e4', category: 'Cansu', title: 'Giyim ve Oyuncak', amount: 5000.00, isIncome: false),
    // SERHAT araba/kart/bireysel
    const BudgetEntry(id: 'e5', category: 'Serhat', title: 'Kredi Kartları Serhat', amount: 45000.00, isIncome: false),
    const BudgetEntry(id: 'e6', category: 'Serhat', title: 'Araç Yakıtı (Aylık)', amount: 4410.00, isIncome: false),
    const BudgetEntry(id: 'e7', category: 'Serhat', title: 'Otomobil Sigorta / Kasko', amount: 1640.00, isIncome: false),
    const BudgetEntry(id: 'e8', category: 'Serhat', title: 'Bakım & MTV Payı', amount: 734.00, isIncome: false),
    // ÇİĞDEM bireysel
    const BudgetEntry(id: 'e9', category: 'Çiğdem', title: 'Giyim & Saç/Güzellik', amount: 2500.00, isIncome: false),
    const BudgetEntry(id: 'e10', category: 'Çiğdem', title: 'Spor & Bireysel Gider', amount: 1400.00, isIncome: false),
    const BudgetEntry(id: 'e11', category: 'Çiğdem', title: 'Hafta sonu Yemek/Sosyal', amount: 12000.00, isIncome: false),
    // Ev ve Yaşam
    const BudgetEntry(id: 'e12', category: 'Ev/Kira', title: 'Kira veya Ev Kredisi', amount: 16000.00, isIncome: false),
    const BudgetEntry(id: 'e13', category: 'Ev/Kira', title: 'Aidat & Bakım', amount: 500.00, isIncome: false),
    // Abonelikler / Faturalar
    const BudgetEntry(id: 'e14', category: 'Altyapı/Fatura', title: 'Isınma & Doğalgaz', amount: 1500.00, isIncome: false),
    const BudgetEntry(id: 'e15', category: 'Altyapı/Fatura', title: 'Elektrik / Su / İnternet', amount: 2090.00, isIncome: false),
    const BudgetEntry(id: 'e16', category: 'Altyapı/Fatura', title: 'Netflix & Abonelikler', amount: 90.00, isIncome: false),
    const BudgetEntry(id: 'e17', category: 'Altyapı/Fatura', title: 'Telefon Faturaları', amount: 1133.00, isIncome: false),
  ];

  // Getters
  List<PortfolioAsset> get assets => List.unmodifiable(_assets);
  List<TransactionRecord> get transactions => List.unmodifiable(_transactions);
  List<BudgetEntry> get incomes => List.unmodifiable(_incomes);
  List<BudgetEntry> get expenses => List.unmodifiable(_expenses);

  // Toplam Portföy Değeri (TL)
  double get totalValueTl {
    return _assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  // Dün'e göre toplam günlük parasal değişim (TL)
  double get dailyChangeAmountTl {
    return _assets.fold(0.0, (sum, asset) {
      final yesterdayValue = asset.totalValue / (1 + (asset.dailyChangePercent / 100));
      return sum + (asset.totalValue - yesterdayValue);
    });
  }

  // Dün'e göre toplam yüzde değişim (%)
  double get dailyChangePercentage {
    final totalNow = totalValueTl;
    if (totalNow == 0) return 0.0;
    final yesterday = totalNow - dailyChangeAmountTl;
    if (yesterday == 0) return 0.0;
    return ((totalNow - yesterday) / yesterday) * 100.0;
  }

  // BÜTÇE HESAPLAMALARI
  double get totalMonthlyIncome => _incomes.fold(0.0, (sum, entry) => sum + entry.amount);
  double get totalMonthlyExpense => _expenses.fold(0.0, (sum, entry) => sum + entry.amount);
  double get netMonthlySavings => totalMonthlyIncome - totalMonthlyExpense;

  // Tasarruf Oranı (%)
  double get savingsRate {
    final income = totalMonthlyIncome;
    if (income == 0) return 0.0;
    return (netMonthlySavings / income) * 100.0;
  }

  // PASİF GELİR & ÖZGÜRLÜK ORANLARI (Excel Sayfa 1)
  // Çiğdem Pasif Gelir (VOO/QQQM vb. yatırımlardan kurgulanan kural: Portföyün %29.39'unun %6 Çekimi)
  double get cigdemPassiveIncomeMonthly {
    // Çiğdem Pasif Gelir Hedefi: ₺200,000 USD (yaklaşık 9.36M TL) hedefe karşı 6% çekim simülasyonu
    // Excel'deki güncel pasif gelir: ₺22,285.30
    return 22285.30;
  }

  double get serhatPassiveIncomeMonthly {
    // Excel'deki güncel pasif gelir: ₺18,571.08
    return 18571.08;
  }

  double get totalPassiveIncomeMonthly => cigdemPassiveIncomeMonthly + serhatPassiveIncomeMonthly;

  // Özgürlük Oranları (%)
  double get cigdemFreedomRatio => 47.6; // Excel'deki Özgürlük Oranı: %47.6
  double get serhatFreedomRatio => 19.8; // Excel'deki Özgürlük Oranı: %19.8
  double get totalFreedomRatio {
    // Toplam bütçe bazlı aylık gideri, mevcut toplam pasif gelirin karşılama oranı
    final expense = totalMonthlyExpense;
    if (expense == 0) return 0.0;
    return (totalPassiveIncomeMonthly / expense) * 100.0;
  }

  // Hedef Portföy Büyüklüğü (TL)
  double get targetPortfolioValue => 31851132.00; // Excel: ₺31,851,132.00

  // 30 YILLIK COMPOUND GROWTH PROJEKSİYON TABLOSU (Excel Sayfa 8 - Büyüme Hızı: %9.8, Yıllık Tasarruf)
  List<FinancialProjection> get financialProjections {
    final List<FinancialProjection> list = [];
    double currentPortfolio = totalValueTl;
    final double yearlySavings = netMonthlySavings * 12; // Yıllık net tasarruf miktarı
    const double netAnnualGrowthRate = 0.098; // Beklenen net getiri hızı (%9.8)

    int startAge = 40; // Örnek başlangıç yaşı (Serhat yaş ufkuna paralel)
    int startYear = DateTime.now().year;

    for (int i = 1; i <= 30; i++) {
      final startingVal = currentPortfolio;
      // Sene sonu portföy formülü: (Portföy + Tasarruf) * (1 + Getiri Oranı)
      final expectedGrowth = (startingVal + yearlySavings) * netAnnualGrowthRate;
      final endingVal = startingVal + yearlySavings + expectedGrowth;

      // Aylık ortalama çekilebilecek pasif gelir (%4 Çekim kuralı baz alınarak)
      final passiveIncome = (endingVal * 0.04) / 12;

      list.add(
        FinancialProjection(
          year: startYear + i,
          age: startAge + i,
          startingPortfolio: startingVal,
          annualSavings: yearlySavings,
          expectedReturn: expectedGrowth,
          endingPortfolio: endingVal,
          expectedPassiveIncome: passiveIncome,
        ),
      );

      currentPortfolio = endingVal; // Bir sonraki sene başlangıcı
    }
    return list;
  }

  // HEDEF vs GERÇEKLEŞEN ALOKASYON ORANLARI
  List<HorizonAllocation> get macroAllocations {
    final total = totalValueTl;
    if (total == 0) {
      return const [
        HorizonAllocation(label: 'Long-term', targetPercentage: 60.0, actualPercentage: 0.0, barColor: Color(0xFF111827)),
        HorizonAllocation(label: 'Mid-term', targetPercentage: 30.0, actualPercentage: 0.0, barColor: Color(0xFF4B5563)),
        HorizonAllocation(label: 'Short-term', targetPercentage: 10.0, actualPercentage: 0.0, barColor: Color(0xFF9CA3AF)),
      ];
    }

    double longTermSum = 0.0;
    double midTermSum = 0.0;
    double shortTermSum = 0.0;

    for (final asset in _assets) {
      switch (asset.horizon) {
        case AssetHorizon.longTerm:
          longTermSum += asset.totalValue;
          break;
        case AssetHorizon.midTerm:
          midTermSum += asset.totalValue;
          break;
        case AssetHorizon.shortTerm:
          shortTermSum += asset.totalValue;
          break;
      }
    }

    return [
      HorizonAllocation(
        label: 'Long-term',
        targetPercentage: 60.0,
        actualPercentage: (longTermSum / total) * 100.0,
        barColor: const Color(0xFF111827),
      ),
      HorizonAllocation(
        label: 'Mid-term',
        targetPercentage: 30.0,
        actualPercentage: (midTermSum / total) * 100.0,
        barColor: const Color(0xFF4B5563),
      ),
      HorizonAllocation(
        label: 'Short-term',
        targetPercentage: 10.0,
        actualPercentage: (shortTermSum / total) * 100.0,
        barColor: const Color(0xFF9CA3AF),
      ),
    ];
  }

  // Bütçe kalemi (Gelir/Gider) ekleme metodu
  void addBudgetEntry(BudgetEntry entry) {
    if (entry.isIncome) {
      _incomes.add(entry);
    } else {
      _expenses.add(entry);
    }
    notifyListeners();
  }

  // Bütçe kalemi silme metodu
  void deleteBudgetEntry(String id, bool isIncome) {
    if (isIncome) {
      _incomes.removeWhere((element) => element.id == id);
    } else {
      _expenses.removeWhere((element) => element.id == id);
    }
    notifyListeners();
  }

  // Yeni portföy işlemi (Alış/Satış) ekleme metodu
  void addTransaction(TransactionRecord record) {
    _transactions.insert(0, record);

    // İlgili varlığı veya nakit değerini güncelle
    final index = _assets.indexWhere((element) => element.assetCode.toUpperCase() == record.assetCode.toUpperCase());
    final multiplier = record.transactionType == 'BUY' ? 1.0 : -1.0;

    if (index != -1) {
      final oldAsset = _assets[index];
      // Toplam değeri güncelle: eskiToplamDeğer + (miktar * fiyat * multiplier)
      final addedValue = record.quantity * record.price * multiplier;
      final newTotalValue = (oldAsset.totalValue + addedValue).clamp(0.0, double.infinity);

      _assets[index] = PortfolioAsset(
        assetCode: oldAsset.assetCode,
        name: oldAsset.name,
        currentPrice: record.price,
        dailyChangePercent: oldAsset.dailyChangePercent,
        totalValue: newTotalValue,
        horizon: oldAsset.horizon,
      );
    } else {
      // Yeni varlık olarak ekle
      _assets.add(
        PortfolioAsset(
          assetCode: record.assetCode,
          name: '${record.assetCode} Varlığı',
          currentPrice: record.price,
          dailyChangePercent: 1.0,
          totalValue: record.quantity * record.price,
          horizon: AssetHorizon.longTerm,
        ),
      );
    }
    notifyListeners();
  }
}
