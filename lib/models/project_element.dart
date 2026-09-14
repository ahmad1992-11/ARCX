enum ProjectElementType {
  site,
  building,
  floor,
  room,
  wall,
  door,
  window,
  furniture,
  structure,
  custom,
}

class ProjectElement {
  final String id;
  final String projectId;

  String name;
  ProjectElementType type;

  double x;
  double y;
  double width;
  double height;
  double rotation;

  Map<String, dynamic> properties;

  ProjectElement({
    required this.id,
    required this.projectId,
    required this.name,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
    this.rotation = 0,
    Map<String, dynamic>? properties,
  }) : properties = properties ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'type': type.name,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'rotation': rotation,
      'properties': properties,
    };
  }

  factory ProjectElement.fromJson(
    Map<String, dynamic> json,
  ) {
    final typeName =
        json['type'] as String? ?? 'custom';

    final type = ProjectElementType.values.firstWhere(
      (item) => item.name == typeName,
      orElse: () => ProjectElementType.custom,
    );

    final rawProperties =
        json['properties'] as Map<String, dynamic>?;

    return ProjectElement(
      id: json['id'] as String? ?? '',
      projectId: json['projectId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: type,
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      width: (json['width'] as num?)?.toDouble() ?? 0,
      height: (json['height'] as num?)?.toDouble() ?? 0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      properties: rawProperties ?? {},
    );
  }
}