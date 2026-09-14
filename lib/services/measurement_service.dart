import '../models/project.dart';
import 'project_service.dart';

class MeasurementService {
  static final MeasurementService instance =
      MeasurementService._internal();

  MeasurementService._internal();

  final ProjectService _projects =
      ProjectService.instance;

  /* ==========================================================
     BASIC CONVERSIONS
     ========================================================== */

  double millimeterToCentimeter(
    double value,
  ) {
    return value / 10;
  }

  double centimeterToMeter(
    double value,
  ) {
    return value / 100;
  }

  double meterToCentimeter(
    double value,
  ) {
    return value * 100;
  }

  double meterToMillimeter(
    double value,
  ) {
    return value * 1000;
  }

  double centimeterToMillimeter(
    double value,
  ) {
    return value * 10;
  }

  /* ==========================================================
     AREA
     ========================================================== */

  double rectangleArea(
    double length,
    double width,
  ) {
    return length * width;
  }

  double triangleArea(
    double base,
    double height,
  ) {
    return (base * height) / 2;
  }

  double circleArea(double radius) {
    return 3.141592653589793 *
        radius *
        radius;
  }

  /* ==========================================================
     VOLUME
     ========================================================== */

  double rectangularVolume(
    double length,
    double width,
    double height,
  ) {
    return length * width * height;
  }

  /* ==========================================================
     PROJECT MEASUREMENTS
     ========================================================== */

  Future<void> saveToProject({
    required String projectId,
    required String type,
    required double value,
    required String unit,
  }) async {
    await _projects.addMeasurement(
      projectId: projectId,
      type: type,
      value: value,
      unit: unit,
    );
  }

  List<Measurement> getProjectMeasurements(
    String projectId,
  ) {
    final project =
        _projects.getById(projectId);

    if (project == null) {
      return [];
    }

    return List.unmodifiable(
      project.measurements,
    );
  }
}