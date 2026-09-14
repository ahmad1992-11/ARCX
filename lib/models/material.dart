class MaterialItem {
  final String id;
  String name;
  String category;
  String unit;
  double price;

  String brand;
  String color;
  String description;

  MaterialItem({
    required this.id,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    this.brand = '',
    this.color = '',
    this.description = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'unit': unit,
      'price': price,
      'brand': brand,
      'color': color,
      'description': description,
    };
  }

  factory MaterialItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return MaterialItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      brand: json['brand'] as String? ?? '',
      color: json['color'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}