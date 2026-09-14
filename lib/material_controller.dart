import 'package:flutter/foundation.dart';

import 'models/material.dart';
import 'services/material_service.dart';

class MaterialController extends ChangeNotifier {
  static final MaterialController instance =
      MaterialController._internal();

  MaterialController._internal();

  final MaterialService _service =
      MaterialService.instance;

  List<MaterialItem> _materials = [];

  bool _isLoading = false;

  List<MaterialItem> get materials =>
      List.unmodifiable(_materials);

  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _materials = _service.getAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> save(
    MaterialItem material,
  ) async {
    await _service.save(material);
    await load();
  }

  Future<void> delete(String id) async {
    await _service.delete(id);
    await load();
  }
}