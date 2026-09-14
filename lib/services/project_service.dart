import '../models/project.dart';
import '../models/project_element.dart';
import 'storage_service.dart';

class ProjectService {
  static final ProjectService instance =
      ProjectService._internal();

  ProjectService._internal();

  final StorageService _storage =
      StorageService.instance;

  /* ==========================================================
     PROJECT CRUD
     ========================================================== */

  List<Project> getAll() {
    return _storage.getProjects();
  }

  Project? getById(String id) {
    return _storage.getProject(id);
  }

  Future<Project> create({
    required String name,
    required String location,
    String category = 'Architecture',
  }) async {
    final project = Project(
      id: _generateId('PROJECT'),
      name: name,
      location: location,
      category: category,
    );

    await _storage.saveProject(project);

    return project;
  }

  Future<void> update(Project project) async {
    await _storage.saveProject(project);
  }

  Future<void> delete(String id) async {
    await _storage.deleteProject(id);
  }

  /* ==========================================================
     PROJECT ELEMENTS
     ========================================================== */

  List<ProjectElement> getElements(
    String projectId,
  ) {
    return _storage.getProjectElements(projectId);
  }

  Future<void> addElement(
    ProjectElement element,
  ) async {
    await _storage.saveProjectElement(element);
  }

  Future<void> updateElement(
    ProjectElement element,
  ) async {
    await _storage.saveProjectElement(element);
  }

  Future<void> deleteElement(
    String id,
  ) async {
    await _storage.deleteProjectElement(id);
  }

  /* ==========================================================
     NOTES
     ========================================================== */

  Future<void> addNote({
    required String projectId,
    required String title,
    required String text,
  }) async {
    final project = _storage.getProject(projectId);

    if (project == null) return;

    project.notes.add(
      NoteItem(
        title: title,
        text: text,
      ),
    );

    await _storage.saveProject(project);
  }

  /* ==========================================================
     MEASUREMENTS
     ========================================================== */

  Future<void> addMeasurement({
    required String projectId,
    required String type,
    required double value,
    required String unit,
  }) async {
    final project = _storage.getProject(projectId);

    if (project == null) return;

    project.measurements.add(
      Measurement(
        type: type,
        value: value,
        unit: unit,
      ),
    );

    await _storage.saveProject(project);
  }

  /* ==========================================================
     ID GENERATOR
     ========================================================== */

  String _generateId(String prefix) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  }
}