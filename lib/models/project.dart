class Project {
  final String id;
  String name;
  String location;
  String category;
  String status;
  final DateTime createdAt;

  final List<Measurement> measurements;
  final List<NoteItem> notes;

  Project({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    this.status = 'Active',
    DateTime? createdAt,
    List<Measurement>? measurements,
    List<NoteItem>? notes,
  })  : createdAt = createdAt ?? DateTime.now(),
        measurements = measurements ?? [],
        notes = notes ?? [];
}

class Measurement {
  final String type;
  final double value;
  final String unit;
  final DateTime date;

  Measurement({
    required this.type,
    required this.value,
    required this.unit,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}

class NoteItem {
  final String title;
  final String text;
  final DateTime date;

  NoteItem({
    required this.title,
    required this.text,
    DateTime? date,
  }) : date = date ?? DateTime.now();
}