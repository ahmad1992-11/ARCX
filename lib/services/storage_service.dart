import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/project.dart';
import '../models/finance_transaction.dart';
import '../models/material.dart';
import '../models/user_profile.dart';
import '../models/project_element.dart';

class StorageService {
  static final StorageService instance =
      StorageService._internal();

  StorageService._internal();

  static const String _projectsKey = 'arcx.projects';
  static const String _transactionsKey = 'arcx.transactions';
  static const String _materialsKey = 'arcx.materials';
  static const String _elementsKey = 'arcx.elements';
  static const String _userProfileKey = 'arcx.user_profile';

  final List<Project> _projects = [];
  final List<FinanceTransaction> _transactions = [];
  final List<MaterialItem> _materials = [];
  final List<ProjectElement> _elements = [];

  UserProfile? _userProfile;

  SharedPreferences? _preferences;

  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    _preferences = await SharedPreferences.getInstance();

    await _loadProjects();
    await _loadTransactions();
    await _loadMaterials();
    await _loadElements();
    await _loadUserProfile();

    _initialized = true;
  }

  SharedPreferences get _prefs {
    final preferences = _preferences;

    if (preferences == null) {
      throw StateError(
        'StorageService has not been initialized.',
      );
    }

    return preferences;
  }

  /* ==========================================================
     PROJECTS
     ========================================================== */

  List<Project> getProjects() {
    return List.unmodifiable(_projects);
  }

  Project? getProject(String id) {
    try {
      return _projects.firstWhere(
        (project) => project.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveProject(Project project) async {
    final index = _projects.indexWhere(
      (item) => item.id == project.id,
    );

    if (index == -1) {
      _projects.add(project);
    } else {
      _projects[index] = project;
    }

    await _saveProjects();
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere(
      (project) => project.id == id,
    );

    _elements.removeWhere(
      (element) => element.projectId == id,
    );

    await _saveProjects();
    await _saveElements();
  }

  Future<void> _loadProjects() async {
    final raw = _prefs.getString(_projectsKey);

    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return;
      }

      _projects
        ..clear()
        ..addAll(
          decoded.map(
            (item) => Project.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );
    } catch (_) {
      _projects.clear();
    }
  }

  Future<void> _saveProjects() async {
    final encoded = jsonEncode(
      _projects.map((item) => item.toJson()).toList(),
    );

    await _prefs.setString(
      _projectsKey,
      encoded,
    );
  }

  /* ==========================================================
     FINANCE
     ========================================================== */

  List<FinanceTransaction> getTransactions() {
    return List.unmodifiable(_transactions);
  }

  Future<void> saveTransaction(
    FinanceTransaction transaction,
  ) async {
    final index = _transactions.indexWhere(
      (item) => item.id == transaction.id,
    );

    if (index == -1) {
      _transactions.add(transaction);
    } else {
      _transactions[index] = transaction;
    }

    await _saveTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere(
      (transaction) => transaction.id == id,
    );

    await _saveTransactions();
  }

  Future<void> _loadTransactions() async {
    final raw = _prefs.getString(_transactionsKey);

    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return;
      }

      _transactions
        ..clear()
        ..addAll(
          decoded.map(
            (item) => FinanceTransaction.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );
    } catch (_) {
      _transactions.clear();
    }
  }

  Future<void> _saveTransactions() async {
    final encoded = jsonEncode(
      _transactions
          .map((item) => item.toJson())
          .toList(),
    );

    await _prefs.setString(
      _transactionsKey,
      encoded,
    );
  }

  /* ==========================================================
     MATERIALS
     ========================================================== */

  List<MaterialItem> getMaterials() {
    return List.unmodifiable(_materials);
  }

  Future<void> saveMaterial(
    MaterialItem material,
  ) async {
    final index = _materials.indexWhere(
      (item) => item.id == material.id,
    );

    if (index == -1) {
      _materials.add(material);
    } else {
      _materials[index] = material;
    }

    await _saveMaterials();
  }

  Future<void> deleteMaterial(String id) async {
    _materials.removeWhere(
      (material) => material.id == id,
    );

    await _saveMaterials();
  }

  Future<void> _loadMaterials() async {
    final raw = _prefs.getString(_materialsKey);

    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return;
      }

      _materials
        ..clear()
        ..addAll(
          decoded.map(
            (item) => MaterialItem.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );
    } catch (_) {
      _materials.clear();
    }
  }

  Future<void> _saveMaterials() async {
    final encoded = jsonEncode(
      _materials
          .map((item) => item.toJson())
          .toList(),
    );

    await _prefs.setString(
      _materialsKey,
      encoded,
    );
  }

  /* ==========================================================
     PROJECT ELEMENTS
     ========================================================== */

  List<ProjectElement> getProjectElements(
    String projectId,
  ) {
    return List.unmodifiable(
      _elements.where(
        (element) => element.projectId == projectId,
      ),
    );
  }

  Future<void> saveProjectElement(
    ProjectElement element,
  ) async {
    final index = _elements.indexWhere(
      (item) => item.id == element.id,
    );

    if (index == -1) {
      _elements.add(element);
    } else {
      _elements[index] = element;
    }

    await _saveElements();
  }

  Future<void> deleteProjectElement(
    String id,
  ) async {
    _elements.removeWhere(
      (element) => element.id == id,
    );

    await _saveElements();
  }

  Future<void> _loadElements() async {
    final raw = _prefs.getString(_elementsKey);

    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is! List) {
        return;
      }

      _elements
        ..clear()
        ..addAll(
          decoded.map(
            (item) => ProjectElement.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          ),
        );
    } catch (_) {
      _elements.clear();
    }
  }

  Future<void> _saveElements() async {
    final encoded = jsonEncode(
      _elements
          .map((item) => item.toJson())
          .toList(),
    );

    await _prefs.setString(
      _elementsKey,
      encoded,
    );
  }

  /* ==========================================================
     USER PROFILE
     ========================================================== */

  UserProfile? getUserProfile() {
    return _userProfile;
  }

  Future<void> saveUserProfile(
    UserProfile profile,
  ) async {
    _userProfile = profile;

    final encoded = jsonEncode(
      profile.toJson(),
    );

    await _prefs.setString(
      _userProfileKey,
      encoded,
    );
  }

  Future<void> _loadUserProfile() async {
    final raw = _prefs.getString(_userProfileKey);

    if (raw == null || raw.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(raw);

      if (decoded is Map) {
        _userProfile = UserProfile.fromJson(
          Map<String, dynamic>.from(decoded),
        );
      }
    } catch (_) {
      _userProfile = null;
    }
  }

  /* ==========================================================
     CLEAR
     ========================================================== */

  Future<void> clearAll() async {
    _projects.clear();
    _transactions.clear();
    _materials.clear();
    _elements.clear();
    _userProfile = null;

    await _prefs.remove(_projectsKey);
    await _prefs.remove(_transactionsKey);
    await _prefs.remove(_materialsKey);
    await _prefs.remove(_elementsKey);
    await _prefs.remove(_userProfileKey);
  }
}