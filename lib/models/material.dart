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
}