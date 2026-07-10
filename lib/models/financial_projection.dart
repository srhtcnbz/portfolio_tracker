/// Geleceğe yönelik yıllık varlık büyümesi ve beklenen pasif gelir projeksiyon satırı.
class FinancialProjection {
  final int year;
  final int age;
  final double startingPortfolio; // Yıl başı portföy değeri (TL)
  final double annualSavings;     // Yıl içinde yapılacak birikim eklemesi (TL)
  final double expectedReturn;    // Yıl sonu beklenen büyüme kazancı (TL)
  final double endingPortfolio;    // Yıl sonu toplam portföy değeri (TL)
  final double expectedPassiveIncome; // O yılki portföyün üretebileceği yıllık pasif gelir (TL)

  const FinancialProjection({
    required this.year,
    required this.age,
    required this.startingPortfolio,
    required this.annualSavings,
    required this.expectedReturn,
    required this.endingPortfolio,
    required this.expectedPassiveIncome,
  });
}
