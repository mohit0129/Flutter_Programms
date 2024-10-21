import 'package:flutter/material.dart';
import '../models/meal_model.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  final VoidCallback toggleFavorite;

  MealItem({required this.meal, required this.toggleFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(meal.name),
        trailing: IconButton(
          icon: Icon(meal.isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: toggleFavorite,
        ),
      ),
    );
  }
}
