/// Represents a single investment transaction record in the portfolio.
class TransactionRecord {
  final String id;
  final DateTime date;
  final String assetCode;
  final String transactionType; // e.g., 'BUY' or 'SELL'
  final double quantity;
  final double price;

  const TransactionRecord({
    required this.id,
    required this.date,
    required this.assetCode,
    required this.transactionType,
    required this.quantity,
    required this.price,
  });

  /// Total value of this transaction (quantity * price).
  double get totalValue => quantity * price;

  /// Whether this transaction represents an asset acquisition.
  bool get isBuy => transactionType.toUpperCase() == 'BUY';

  /// Creates a copy of this [TransactionRecord] with updated fields.
  TransactionRecord copyWith({
    String? id,
    DateTime? date,
    String? assetCode,
    String? transactionType,
    double? quantity,
    double? price,
  }) {
    return TransactionRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      assetCode: assetCode ?? this.assetCode,
      transactionType: transactionType ?? this.transactionType,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  /// Converts this [TransactionRecord] to a map suitable for Firestore storage.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'assetCode': assetCode,
      'transactionType': transactionType,
      'quantity': quantity,
      'price': price,
    };
  }

  /// Creates a [TransactionRecord] from a map (e.g., from Cloud Firestore).
  factory TransactionRecord.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return TransactionRecord(
      id: documentId ?? (map['id'] as String? ?? ''),
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      assetCode: map['assetCode'] as String? ?? '',
      transactionType: map['transactionType'] as String? ?? 'BUY',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  String toString() {
    return 'TransactionRecord(id: $id, date: $date, assetCode: $assetCode, '
        'transactionType: $transactionType, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionRecord &&
        other.id == id &&
        other.date == date &&
        other.assetCode == assetCode &&
        other.transactionType == transactionType &&
        other.quantity == quantity &&
        other.price == price;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      date,
      assetCode,
      transactionType,
      quantity,
      price,
    );
  }
}
