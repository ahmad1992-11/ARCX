import '../models/project.dart';
import '../models/finance_transaction.dart';
import '../models/material.dart';
import '../models/user_profile.dart';
import '../models/project_element.dart';

class StorageService {
  static final StorageService instance =
      StorageService._internal();

  StorageService._internal();

  final List<Project> _projects = [];
  final List<FinanceTransaction> _transactions = [];
  final List<MaterialItem> _materials = [];
  final List<ProjectElement> _elements = [];

  UserProfile? _userProfile;

  bool _initialized = false;

  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    _initialized = true;
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
  }

  Future<void> deleteProject(String id) async {
    _projects.removeWhere(
      (project) => project.id == id,
    );

    _elements.removeWhere(
      (element) => element.projectId == id,
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
  }

  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere(
      (transaction) => transaction.id == id,
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
  }

  Future<void> deleteMaterial(String id) async {
    _materials.removeWhere(
      (material) => material.id == id,
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
  }

  Future<void> deleteProjectElement(
    String id,
  ) async {
    _elements.removeWhere(
      (element) => element.id == id,
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
  }
}