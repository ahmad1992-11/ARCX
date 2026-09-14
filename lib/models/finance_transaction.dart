class FinanceTransaction {
  final String id;
  final String title;
  final double amount;

  /// true = income
  /// false = expense
  final bool income;

  /// true = project
  /// false = personal
  final bool projectRelated;

  final String? projectId;
  final DateTime date;
  final String description;

  FinanceTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.income,
    required this.projectRelated,
    this.projectId,
    DateTime? date,
    this.description = '',
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'income': income,
      'projectRelated': projectRelated,
      'projectId': projectId,
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory FinanceTransaction.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinanceTransaction(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      income: json['income'] as bool? ?? false,
      projectRelated:
          json['projectRelated'] as bool? ?? false,
      projectId: json['projectId'] as String?,
      date: DateTime.tryParse(
        json['date'] as String? ?? '',
      ),
      description:
          json['description'] as String? ?? '',
    );
  }
}