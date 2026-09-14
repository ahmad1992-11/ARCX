import '../models/finance_transaction.dart';
import 'storage_service.dart';

class FinanceService {
  static final FinanceService instance =
      FinanceService._internal();

  FinanceService._internal();

  final StorageService _storage =
      StorageService.instance;

  List<FinanceTransaction> getAll() {
    return _storage.getTransactions();
  }

  Future<FinanceTransaction> add({
    required String title,
    required double amount,
    required bool income,
    required bool projectRelated,
    String? projectId,
    String description = '',
  }) async {
    final transaction = FinanceTransaction(
      id: _generateId(),
      title: title,
      amount: amount,
      income: income,
      projectRelated: projectRelated,
      projectId: projectId,
      description: description,
    );

    await _storage.saveTransaction(
      transaction,
    );

    return transaction;
  }

  Future<void> update(
    FinanceTransaction transaction,
  ) async {
    await _storage.saveTransaction(
      transaction,
    );
  }

  Future<void> delete(String id) async {
    await _storage.deleteTransaction(id);
  }

  /* ==========================================================
     PROJECT FINANCE
     ========================================================== */

  double projectIncome() {
    return _sum(
      projectRelated: true,
      income: true,
    );
  }

  double projectExpense() {
    return _sum(
      projectRelated: true,
      income: false,
    );
  }

  double projectBalance() {
    return projectIncome() -
        projectExpense();
  }

  /* ==========================================================
     PERSONAL FINANCE
     ========================================================== */

  double personalIncome() {
    return _sum(
      projectRelated: false,
      income: true,
    );
  }

  double personalExpense() {
    return _sum(
      projectRelated: false,
      income: false,
    );
  }

  double personalBalance() {
    return personalIncome() -
        personalExpense();
  }

  /* ==========================================================
     TOTALS
     ========================================================== */

  double _sum({
    required bool projectRelated,
    required bool income,
  }) {
    return _storage
        .getTransactions()
        .where(
          (transaction) =>
              transaction.projectRelated ==
                  projectRelated &&
              transaction.income == income,
        )
        .fold(
          0.0,
          (sum, transaction) =>
              sum + transaction.amount,
        );
  }

  String _generateId() {
    return 'FIN-${DateTime.now().microsecondsSinceEpoch}';
  }
}