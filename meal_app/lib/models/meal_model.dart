class Meal {
  final String id;
  final String name;
  final bool isVeg;
  final bool isFavorite;

  Meal({
    required this.id,
    required this.name,
    required this.isVeg,
    this.isFavorite = false,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      name: json['name'],
      isVeg: json['isVeg'],
    );
  }
}
