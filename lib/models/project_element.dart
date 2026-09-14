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
}