import '../models/project.dart';
import '../models/project_element.dart';
import 'project_service.dart';

class ProjectContextService {
  static final ProjectContextService instance =
      ProjectContextService._internal();

  ProjectContextService._internal();

  final ProjectService _projectService =
      ProjectService.instance;

  Project? getProject(String projectId) {
    return _projectService.getById(projectId);
  }

  List<Project> getProjects() {
    return _projectService.getAll();
  }

  List<ProjectElement> getElements(
    String projectId,
  ) {
    return _projectService.getElements(projectId);
  }

  Future<Project> createProject({
    required String name,
    required String location,
    String category = 'Architecture',
  }) async {
    return _projectService.create(
      name: name,
      location: location,
      category: category,
    );
  }

  Future<void> updateProject(Project project) async {
    await _projectService.update(project);
  }

  Future<void> deleteProject(String projectId) async {
    await _projectService.delete(projectId);
  }

  Future<void> addNote({
    required String projectId,
    required String title,
    required String text,
  }) async {
    await _projectService.addNote(
      projectId: projectId,
      title: title,
      text: text,
    );
  }

  Future<void> addMeasurement({
    required String projectId,
    required String type,
    required double value,
    required String unit,
  }) async {
    await _projectService.addMeasurement(
      projectId: projectId,
      type: type,
      value: value,
      unit: unit,
    );
  }

  Future<void> addElement(
    ProjectElement element,
  ) async {
    await _projectService.addElement(element);
  }

  Future<void> updateElement(
    ProjectElement element,
  ) async {
    await _projectService.updateElement(element);
  }

  Future<void> deleteElement(String elementId) async {
    await _projectService.deleteElement(elementId);
  }
}