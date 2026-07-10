/// Aylık gelir veya gider kalemini tutan veri modeli.
class BudgetEntry {
  final String id;
  final String category; // Cansu, Serhat, Çiğdem, Ev, Altyapı, Yol/Yakıt vb.
  final String title;    // Maaş, Kira, Fatura, Okul Servisi vb.
  final double amount;   // Miktar (TL)
  final bool isIncome;   // Gelir mi? (Gider ise false)

  const BudgetEntry({
    required this.id,
    required this.category,
    required this.title,
    required this.amount,
    required this.isIncome,
  });
}
