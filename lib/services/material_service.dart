import '../models/material.dart';
import 'storage_service.dart';

class MaterialService {
  static final MaterialService instance = MaterialService._internal();

  MaterialService._internal();

  final StorageService _storage = StorageService.instance;

  List<MaterialItem> getAll() {
    return _storage.getMaterials();
  }

  Future<void> save(MaterialItem material) async {
    await _storage.saveMaterial(material);
  }

  Future<void> delete(String id) async {
    await _storage.deleteMaterial(id);
  }
}