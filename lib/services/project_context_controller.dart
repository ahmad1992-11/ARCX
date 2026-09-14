import 'package:flutter/foundation.dart';

import '../models/project.dart';
import '../models/project_element.dart';
import 'project_context_service.dart';

class ProjectContextController extends ChangeNotifier {
  static final ProjectContextController instance =
      ProjectContextController._internal();

  ProjectContextController._internal();

  final ProjectContextService _service =
      ProjectContextService.instance;

  List<Project> _projects = [];
  Project? _activeProject;
  List<ProjectElement> _elements = [];

  bool _isLoading = false;

  List<Project> get projects => List.unmodifiable(_projects);

  Project? get activeProject => _activeProject;

  List<ProjectElement> get elements =>
      List.unmodifiable(_elements);

  bool get isLoading => _isLoading;

  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    _projects = _service.getProjects();

    if (_activeProject != null) {
      final exists = _projects.any(
        (project) => project.id == _activeProject!.id,
      );

      if (!exists) {
        _activeProject = null;
        _elements = [];
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectProject(String projectId) async {
    _activeProject = _service.getProject(projectId);

    if (_activeProject == null) {
      _elements = [];
    } else {
      _elements = _service.getElements(projectId);
    }

    notifyListeners();
  }

  Future<Project> createProject({
    required String name,
    required String location,
    String category = 'Architecture',
  }) async {
    final project = await _service.createProject(
      name: name,
      location: location,
      category: category,
    );

    await loadProjects();
    await selectProject(project.id);

    return project;
  }

  Future<void> updateProject(Project project) async {
    await _service.updateProject(project);

    await loadProjects();

    if (_activeProject?.id == project.id) {
      _activeProject = _service.getProject(project.id);
      _elements = _service.getElements(project.id);
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    await _service.deleteProject(projectId);

    if (_activeProject?.id == projectId) {
      _activeProject = null;
      _elements = [];
    }

    await loadProjects();
  }

  Future<void> addNote({
    required String projectId,
    required String title,
    required String text,
  }) async {
    await _service.addNote(
      projectId: projectId,
      title: title,
      text: text,
    );

    await _refreshActiveProject(projectId);
  }

  Future<void> addMeasurement({
    required String projectId,
    required String type,
    required double value,
    required String unit,
  }) async {
    await _service.addMeasurement(
      projectId: projectId,
      type: type,
      value: value,
      unit: unit,
    );

    await _refreshActiveProject(projectId);
  }

  Future<void> addElement(ProjectElement element) async {
    await _service.addElement(element);

    if (_activeProject?.id == element.projectId) {
      _elements = _service.getElements(element.projectId);
      notifyListeners();
    }
  }

  Future<void> updateElement(ProjectElement element) async {
    await _service.updateElement(element);

    if (_activeProject?.id == element.projectId) {
      _elements = _service.getElements(element.projectId);
      notifyListeners();
    }
  }

  Future<void> deleteElement(String elementId) async {
    await _service.deleteElement(elementId);

    if (_activeProject != null) {
      _elements =
          _service.getElements(_activeProject!.id);
      notifyListeners();
    }
  }

  Future<void> _refreshActiveProject(String projectId) async {
    if (_activeProject?.id == projectId) {
      _activeProject = _service.getProject(projectId);
      _elements = _service.getElements(projectId);
      notifyListeners();
    }
  }
}