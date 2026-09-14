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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'category': category,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'measurements': measurements.map((e) => e.toJson()).toList(),
      'notes': notes.map((e) => e.toJson()).toList(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      category: json['category'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
      createdAt: DateTime.tryParse(
        json['createdAt'] as String? ?? '',
      ),
      measurements:
          (json['measurements'] as List<dynamic>? ?? [])
              .map(
                (item) => Measurement.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
      notes:
          (json['notes'] as List<dynamic>? ?? [])
              .map(
                (item) => NoteItem.fromJson(
                  Map<String, dynamic>.from(item as Map),
                ),
              )
              .toList(),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'unit': unit,
      'date': date.toIso8601String(),
    };
  }

  factory Measurement.fromJson(Map<String, dynamic> json) {
    return Measurement(
      type: json['type'] as String? ?? '',
      value: (json['value'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String? ?? '',
      date: DateTime.tryParse(
        json['date'] as String? ?? '',
      ),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'date': date.toIso8601String(),
    };
  }

  factory NoteItem.fromJson(Map<String, dynamic> json) {
    return NoteItem(
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      date: DateTime.tryParse(
        json['date'] as String? ?? '',
      ),
    );
  }
}