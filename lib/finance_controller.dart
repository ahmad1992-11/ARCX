import 'package:flutter/foundation.dart';

import '../models/finance_transaction.dart';
import '../services/finance_service.dart';

class FinanceController extends ChangeNotifier {
  static final FinanceController instance =
      FinanceController._internal();

  FinanceController._internal();

  final FinanceService _service =
      FinanceService.instance;

  List<FinanceTransaction> _transactions = [];

  bool _isLoading = false;

  List<FinanceTransaction> get transactions =>
      List.unmodifiable(_transactions);

  bool get isLoading => _isLoading;

  double get projectIncome =>
      _transactions
          .where(
            (item) =>
                item.projectRelated &&
                item.income,
          )
          .fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

  double get projectExpense =>
      _transactions
          .where(
            (item) =>
                item.projectRelated &&
                !item.income,
          )
          .fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

  double get projectBalance =>
      projectIncome - projectExpense;

  double get personalIncome =>
      _transactions
          .where(
            (item) =>
                !item.projectRelated &&
                item.income,
          )
          .fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

  double get personalExpense =>
      _transactions
          .where(
            (item) =>
                !item.projectRelated &&
                !item.income,
          )
          .fold(
            0.0,
            (sum, item) => sum + item.amount,
          );

  double get personalBalance =>
      personalIncome - personalExpense;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _transactions = _service.getAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<FinanceTransaction> add({
    required String title,
    required double amount,
    required bool income,
    required bool projectRelated,
    String? projectId,
    String description = '',
  }) async {
    final transaction = await _service.add(
      title: title,
      amount: amount,
      income: income,
      projectRelated: projectRelated,
      projectId: projectId,
      description: description,
    );

    await load();

    return transaction;
  }

  Future<void> update(
    FinanceTransaction transaction,
  ) async {
    await _service.update(transaction);
    await load();
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
    await load();
  }
}