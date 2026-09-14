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
}