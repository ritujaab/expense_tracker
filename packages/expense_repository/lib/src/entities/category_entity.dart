class CategoryEntity {
  String categoryId;
  String name;
  double totalExpenses;
  String icon;
  String color;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'name': name,
      'totalExpenses': totalExpenses,
      'icon': icon,
      'color': color,
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> document) {
    return CategoryEntity(
      categoryId: document['categoryId'],
      name: document['name'],
      totalExpenses: document['totalExpenses'],
      icon: document['icon'],
      color: document['color'],
    );
  }
}