class CategoryEntity {
  String categoryId;
  String name;
  double totalExpenses;
  String icon;
  String color;
  String type;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
    required this.type
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'totalExpenses': totalExpenses,
      'icon': icon,
      'color': color,
      'type': type
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> document) {
    return CategoryEntity(
      categoryId: document['categoryId'],
      name: document['name'],
      totalExpenses: document['totalExpenses'],
      icon: document['icon'],
      color: document['color'],
      type: document['type']
    );
  }
}